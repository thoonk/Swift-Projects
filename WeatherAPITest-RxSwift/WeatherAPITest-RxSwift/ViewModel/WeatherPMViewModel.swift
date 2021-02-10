//
//  WeatherPMViewModel.swift
//  WeatherAPITest-RxSwift
//
//  Created by 김태훈 on 2021/02/10.
//

import Foundation
import RxSwift

class WeatherPMViewModel {
    
    var currentWeatherOb = PublishSubject<WeatherCurrent>()
    
    init() {
        
    }
    
}
