//
//  WeatherData.swift
//  WeatherAPITest
//
//  Created by 김태훈 on 2021/01/26.
//

import Foundation

struct WeatherData: Codable {
    var timezone: String
    var daily: [Daily]
}

struct Daily: Codable {
    var dt: TimeInterval
    var temp: Temp
    var weather: [Weather]
}

struct Temp: Codable {
    var min: Double
    var max: Double
}
    
struct Weather: Codable {
    var id: Int
    var description: String
}

