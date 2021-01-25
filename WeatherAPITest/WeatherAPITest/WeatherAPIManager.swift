//
//  WeatherAPIManager.swift
//  WeatherAPITest
//
//  Created by 김태훈 on 2021/01/24.
//

import Foundation

class WeatherAPIManager {
    
    static let shared = WeatherAPIManager()
    
    func getForecast() {
        
        let url =
        "http://apis.data.go.kr/1360000/VilageFcstInfoService/getUltraSrtFcst?serviceKey=APIKey&base_date=20210124&base_time=0630&nx=37&ny=126&dataType=json"
    }
}
