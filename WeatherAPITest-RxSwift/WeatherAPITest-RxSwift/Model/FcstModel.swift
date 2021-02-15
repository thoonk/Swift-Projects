//
//  FcstModel.swift
//  WeatherAPITest-RxSwift
//
//  Created by 김태훈 on 2021/02/14.
//

import Foundation
import RxSwift

struct FcstModel {
    var weekWeather: WeatherFcst?
    var weekPM: [PMModel]?
}
