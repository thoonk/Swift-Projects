//
//  LocationInfoViewController.swift
//  FindCVS
//
//  Created by thoonk on 2022/01/12.
//

import UIKit
import CoreLocation
import RxSwift
import RxCocoa
import SnapKit

final class LocationInfoViewController: UIViewController {
    let bag = DisposeBag()
    let viewModel = LocationInfoViewModel()
    let detailListBackgroundView = DetailListBackgroundView()
    
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        
        return manager
    }()
    
    lazy var mapView: MTMapView = {
        let mapView = MTMapView()
        mapView.currentLocationTrackingMode = .onWithoutHeadingWithoutMapMoving
        mapView.delegate = self
        
        return mapView
    }()
    
    lazy var currentLocationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "location.fill"), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        return button
    }()
    
    lazy var detailList: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundView = detailListBackgroundView
        tableView.register(
            DetailListCell.self,
            forCellReuseIdentifier: DetailListCell.identifier
        )
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        bind(viewModel)
    }
    
    func bind(_ viewModel: LocationInfoViewModel) {
        detailListBackgroundView.bind(viewModel.detailListBackgroundViewModel)
        // Input
        currentLocationButton.rx.tap
            .bind(to: viewModel.currentLocationButtonTapped)
            .disposed(by: bag)
        
        detailList.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.detailListItemSelected)
            .disposed(by: bag)
        
        // Output
        viewModel.setMapCenter
            .emit(to: mapView.rx.setMapCenterPoint)
            .disposed(by: bag)
        
        viewModel.errorMessage
            .emit(to: self.rx.presentAlert)
            .disposed(by: bag)
        
        viewModel.detailListCellData
            .drive(detailList.rx.items) { tv, row, data in
                let cell = tv.dequeueReusableCell(withIdentifier: DetailListCell.identifier, for: IndexPath(row: row, section: 0)) as! DetailListCell
                cell.configure(with: data)
                return cell
            }
            .disposed(by: bag)
        
        viewModel.detailListCellData
            .map {
                $0.compactMap { $0.point }
            }
            .drive(self.rx.addPOIItems)
            .disposed(by: bag)
        
        viewModel.scrollToSelecedLocation
            .emit(to: self.rx.showSelectedLocation)
            .disposed(by: bag)

    }
}

private extension LocationInfoViewController {
    func setupLayout() {
        title = "내 주변 편의점 찾기"
        view.backgroundColor = .white
                
        [mapView, currentLocationButton, detailList]
            .forEach { view.addSubview($0) }
        
        mapView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.snp.centerY).offset(100)
        }
        
        currentLocationButton.snp.makeConstraints {
            $0.bottom.equalTo(detailList.snp.top).offset(-12)
            $0.leading.equalToSuperview().offset(12)
            $0.width.height.equalTo(40)
        }
        
        detailList.snp.makeConstraints {
            $0.centerX.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.top.equalTo(mapView.snp.bottom)
        }
    }
}

extension LocationInfoViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            
        case .authorizedAlways,
                .authorizedWhenInUse,
                .notDetermined:
            return
        default:
            viewModel.mapViewError.accept(MTMapviewError.locationAuthorizationDenied.errorDescription)
            return
        }
    }
}

extension LocationInfoViewController: MTMapViewDelegate {
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
//        #if DEBUG
//        viewModel.currentLocation.accept(MTMapPoint(geoCoord: MTMapPointGeo(latitude: 37.505818168, longitude: 126.753112053)))
//        #else
        viewModel.currentLocation.accept(location)
//        #endif
    }
    
    func mapView(_ mapView: MTMapView!, finishedMapMoveAnimation mapCenterPoint: MTMapPoint!) {
        viewModel.mapCenterPoint.accept(mapCenterPoint)
    }
    
    func mapView(_ mapView: MTMapView!, selectedPOIItem poiItem: MTMapPOIItem!) -> Bool {
        viewModel.selectPOIItem.accept(poiItem)
        return false
    }
    
    func mapView(_ mapView: MTMapView!, failedUpdatingCurrentLocationWithError error: Error!) {
        viewModel.mapViewError.accept(error.localizedDescription)
    }
}

extension Reactive where Base: MTMapView {
    var setMapCenterPoint: Binder<MTMapPoint> {
        return Binder(base) { base, point in
            base .setMapCenter(point, animated: true)
        }
    }
}

extension Reactive where Base: LocationInfoViewController {
    var presentAlert: Binder<String> {
        return Binder(base) {base, message in
            let alert = UIAlertController(
                title: "알림",
                message: message,
                preferredStyle: .alert
            )
            let action = UIAlertAction (title: "확인", style: .default, handler:  nil)
            alert.addAction(action)
            base.present(alert, animated: true, completion: nil)
        }
    }
    
    var showSelectedLocation: Binder<Int> {
        return Binder(base) { base, row in
            let indexPath = IndexPath(row: row, section: 0)
            base.detailList.selectRow(
                at: indexPath,
                animated: true,
                scrollPosition: .top
            )
        }
    }
    
    var addPOIItems: Binder<[MTMapPoint]> {
        return Binder(base) { base, points in
            let items = points
                .enumerated()
                .map { offset, point -> MTMapPOIItem in
                    let mapPOIItem = MTMapPOIItem()
                    
                    mapPOIItem.mapPoint = point
                    mapPOIItem.markerType = .bluePin
                    mapPOIItem.showAnimationType = .springFromGround
                    mapPOIItem.tag = offset
                    
                    return mapPOIItem
                }
            
            base.mapView.removeAllPOIItems()
            base.mapView.addPOIItems(items)
        }
    }
}

