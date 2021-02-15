//
//  FcstViewModel.swift
//  WeatherAPITest-RxSwift
//
//  Created by 김태훈 on 2021/02/13.
//

import Foundation
import RxSwift
import CoreLocation

class FcstViewModel: ViewModelType {
    
    private var fcstSubject = PublishSubject<[FcstModel]>()
    
    var bag: DisposeBag = DisposeBag()
    
    struct Input {
        let location: ReplaySubject<CLLocation>
    }
    
    struct Output {
        let fcstData: Observable<[FcstModel]>
        let errorMessage: Observable<String>
    }
    
    func bind(input: Input) -> Output {
        
        let error = PublishSubject<String>()
        
        input.location
            .take(1)
            .flatMapLatest { (location) -> Observable<[FcstModel]> in
                return FcstAPIManager.shared.fetchFcstData(lat: "\(location.coordinate.latitude)", lon: "\(location.coordinate.longitude)")
            }.subscribe(onNext: { [weak self] data in
                self?.fcstSubject.onNext(data)
            }, onError: { err in
                error.onNext(err.localizedDescription)
            }).disposed(by: bag)
        
        let fcstData = fcstSubject

        return Output(fcstData: fcstData,
                      errorMessage: error)
    }
}
