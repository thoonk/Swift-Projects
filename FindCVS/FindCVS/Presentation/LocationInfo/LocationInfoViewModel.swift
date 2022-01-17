//
//  LocationInfoViewModel.swift
//  FindCVS
//
//  Created by thoonk on 2022/01/12.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

struct LocationInfoViewModel {
    let bag = DisposeBag()
    
    // subViewModels
    let detailListBackgroundViewModel = DetailListBackgroundViewModel()

    // Input
    let currentLocation = PublishRelay<MTMapPoint>()
    let mapCenterPoint = PublishRelay<MTMapPoint>()
    let selectPOIItem = PublishRelay<MTMapPOIItem>()
    let mapViewError = PublishRelay<String>()
    let currentLocationButtonTapped = PublishRelay<Void>()
    let detailListItemSelected = PublishRelay<Int>()
    
    // Output
    let setMapCenter: Signal<MTMapPoint>
    let errorMessage: Signal<String>
    let detailListCellData: Driver<[DetailListCellData]>
    let scrollToSelecedLocation: Signal<Int>
    private let documentData = PublishSubject<[KLDocument]>()
    
    
    init(model: LocationInfoModel = LocationInfoModel()) {
        // 네트워크 통신으로 데이터 불러오기
        let cvsLocationDataResult = mapCenterPoint
            .flatMapLatest(model.getLocation)
            .share()
        
        let cvsLocationDataValue = cvsLocationDataResult
            .compactMap { data -> LocationData? in
                guard case let .success(value) = data else {
                    return nil
                }
                return value
            }
        
        let cvsLocationDataErrorMessage = cvsLocationDataResult
            .compactMap { data -> String? in
                switch data {
                case let .success(data) where data.documents.isEmpty:
                    return """
                        500m 근처에 이용할 수 있는 편의점이 없습니다.
                    """
                case let .failure(error):
                    return error.localizedDescription
                default:
                    return nil
                }
            }
        
        cvsLocationDataValue
            .map { $0.documents }
            .bind(to: documentData)
            .disposed(by: bag)
        
        // 지도 중심점 설정
        let selectedDetailListItem = detailListItemSelected
            .withLatestFrom(documentData) { $1[$0] }
            .map(model.documentToMTMapPoint(_:))
        
        let moveToCurrentLocation = currentLocationButtonTapped
            .withLatestFrom(currentLocation)
        
        let currentMapCenter = Observable
            .merge(
                selectedDetailListItem,
                currentLocation.take(1),
                moveToCurrentLocation
            )
        
        setMapCenter = currentMapCenter
            .asSignal(onErrorSignalWith: .empty())
        
        errorMessage = Observable
            .merge(
            cvsLocationDataErrorMessage,
            mapViewError.asObservable()
            )
            .asSignal(onErrorJustReturn: "잠시 후 다시 시도해주세요.")
        
        detailListCellData = documentData
            .map(model.documentToCellData(_:))
            .asDriver(onErrorDriveWith: .empty())
        
        documentData
            .map { !$0.isEmpty }
            .bind(to: detailListBackgroundViewModel.shouldHideStatusLabel)
            .disposed(by: bag)
        
        scrollToSelecedLocation = selectPOIItem
            .map { $0.tag }
            .asSignal(onErrorJustReturn: 0)
    }
}
