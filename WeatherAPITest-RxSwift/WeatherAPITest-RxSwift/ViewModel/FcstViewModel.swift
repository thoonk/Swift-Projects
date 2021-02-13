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
    
    private var weatherSubject = PublishSubject<[WeatherFcst]>()
    private var pmSubject = PublishSubject<[[PMModel]]>()
    
    var bag: DisposeBag = DisposeBag()
    
    struct Input {
        let location: ReplaySubject<CLLocation>
    }
    
    struct Output {
        let weekWeather: Observable<[WeatherFcst]>
        let weekPM: Observable<[[PMModel]]>
        let errorMessage: Observable<String>
    }
    
    func bind(input: Input) -> Output {
        
        let error = PublishSubject<String>()
        
        input.location
            .take(1)
            .flatMapLatest { (location) -> Observable<[WeatherFcst]> in
                WeatherAPIManager.shared.fetchFcstData(lat: "\(location.coordinate.latitude)", lon: "\(location.coordinate.longitude)")
            }.subscribe(onNext: { [weak self] data in
                self?.weatherSubject.onNext(data)
            }, onError: { err in
                error.onNext(err.localizedDescription)
            }).disposed(by: bag)
        
        input.location
            .take(1)
            .flatMapLatest { (location) -> Observable<[[PMModel]]> in
                PMAPIManger.shared.fetchFcstData(lat: "\(location.coordinate.latitude)", lon: "\(location.coordinate.longitude)")
            }.subscribe(onNext: { [weak self] data in
                self?.pmSubject.onNext(data)
            }, onError: { err in
                error.onNext(err.localizedDescription)
            }).disposed(by: bag)

        let weekWeather = weatherSubject
        let weekPM = pmSubject
        
        return Output(weekWeather: weekWeather,
                      weekPM: weekPM,
                      errorMessage: error)
    }
}
