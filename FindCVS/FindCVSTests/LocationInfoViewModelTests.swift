//
//  LocationInfoViewModelTests.swift
//  FindCVSTests
//
//  Created by thoonk on 2022/01/17.
//

import XCTest
import Nimble
import RxSwift
import RxTest

@testable import FindCVS

class LocationInfoViewModelTests: XCTestCase {
    let bag = DisposeBag()
    
    let stubNetwork = LocalNetworkStub()
    var model: LocationInfoModel!
    var viewModel: LocationInfoViewModel!
    var doc: [KLDocument]!
    
    override func setUp() {
        self.model = LocationInfoModel(localNetwork: stubNetwork)
        self.viewModel = LocationInfoViewModel(model: model)
        self.doc = cvsList
    }
    
    func testSetMapCenter() {
        let scheduler = TestScheduler(initialClock: 0)
        
        // 더미 이벤트
        let dummyDataEvent = scheduler.createHotObservable([
            .next(0, cvsList)
        ])
        
        let documentData = PublishSubject<[KLDocument]>()
        dummyDataEvent
            .subscribe(documentData)
            .disposed(by: bag)
        
        // DataList 아이템(셀) 텝 이벤트
        let itemSelectedEvent = scheduler.createHotObservable([
            .next(1, 0)
        ])
        
        let itemSelected = PublishSubject<Int>()
        itemSelectedEvent
            .subscribe(itemSelected)
            .disposed(by: bag)
        
        let selectedItemMapPoint = itemSelected
            .withLatestFrom(documentData) { $1[$0] }
            .map(model.documentToMTMapPoint(_:))
        
        // 최초 현재 위치 이벤트
        let initialMapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: Double(37.505818168), longitude: Double(126.753112053)))!
        
        let currentLocationEvent = scheduler.createHotObservable([
            .next(0, initialMapPoint)
        ])
        
        let initialCurrentLocation = PublishSubject<MTMapPoint>()
        
        currentLocationEvent
            .subscribe(initialCurrentLocation)
            .disposed(by: bag)
        
        // 현재 위치 버튼 탭 이벤트
        let currentLocationButtonTapEvent = scheduler.createHotObservable([
            .next(2, Void()),
            .next(3, Void())
        ])
        
        let currentLocationButtonTapped = PublishSubject<Void>()
        
        currentLocationButtonTapEvent
            .subscribe(currentLocationButtonTapped)
            .disposed(by: bag)
        
        let moveToCurrentLocation = currentLocationButtonTapped
            .withLatestFrom(initialCurrentLocation)
        
        // Merge
        let currentMapCenter = Observable
            .merge(
                selectedItemMapPoint,
                initialCurrentLocation,
                moveToCurrentLocation
            )
        
        let currentMapCenterObserver = scheduler.createObserver(Double.self)
        
        currentMapCenter
            .map { $0.mapPointGeo().latitude }
            .subscribe(currentMapCenterObserver)
            .disposed(by: bag)
        
        scheduler.start()
        
        let secondMapPoint = model.documentToMTMapPoint(doc [0])
        
        expect(currentMapCenterObserver.events).to(
            equal([
                .next(0, initialMapPoint.mapPointGeo().latitude),
                .next(1, secondMapPoint.mapPointGeo().latitude),
                .next(2, initialMapPoint.mapPointGeo().latitude),
                .next(3, initialMapPoint.mapPointGeo().latitude),
            ])
        )
    }
}
