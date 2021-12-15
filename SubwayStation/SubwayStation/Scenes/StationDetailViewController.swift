//
//  StationDetailViewController.swift
//  SubwayStation
//
//  Created by MA2103 on 2021/12/10.
//

import UIKit
import SnapKit
import Alamofire

final class StationDetailViewController: UIViewController {
    private let station: Station
    private var realtimeArrivalList = [StationArrivalDataResponseModel.RealTimeArrival]()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        
        return refreshControl
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(
            width: view.frame.width - 32.0,
            height: 100.0
        )
        
        layout.sectionInset = UIEdgeInsets(
            top: 16.0,
            left: 16.0,
            bottom: 16.0,
            right: 16.0
        )
        
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        
        collectionView.register(
            StationDetailCollectionViewCell.self,
            forCellWithReuseIdentifier: StationDetailCollectionViewCell.identifier
        )
        
        collectionView.refreshControl = refreshControl
        
        return collectionView
    }()
    
    init(station: Station) {
        self.station = station
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "\(station.stationName)"
        setCollectionViewLayout()
        fetchData()
    }
    
    private func setCollectionViewLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc func fetchData() {
        let stationName = self.station.stationName
        let urlString = "http://swopenapi.seoul.go.kr/api/subway/sample/json/realtimeStationArrival/0/5/\(stationName.replacingOccurrences(of: "역", with: ""))"
        
        AF.request(urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            .responseDecodable(of: StationArrivalDataResponseModel.self) { [weak self] response in
                guard let self = self else { return }
                
                self.refreshControl.endRefreshing()

                switch response.result {
                case .success(let data):
                    debugPrint(data.realtimeArrivalList)
                    self.realtimeArrivalList = data.realtimeArrivalList
                    self.collectionView.reloadData()
                    self.autoFetching()
                    
                case .failure(let err):
                    debugPrint("Error: \(err)")
                }
            }
            .resume()
    }
    
    /// 도전과제: 도착 정보 표시 후, 1분 뒤에 자동으로 서버에 요청하는 코드 구현
    private func autoFetching() {
        let timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: false, block: { _ in
            self.fetchData()
        })
        RunLoop.current.add(timer, forMode: .common)
    }
}

extension StationDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.realtimeArrivalList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: StationDetailCollectionViewCell.identifier,
            for: indexPath
        ) as? StationDetailCollectionViewCell
        else {
             return UICollectionViewCell()
        }
        
        cell.setup(with: realtimeArrivalList[indexPath.row])
        
        return cell
    }
}

extension StationDetailViewController: UICollectionViewDelegate {

}



