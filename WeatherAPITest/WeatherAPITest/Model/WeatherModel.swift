//
//  WeatherModel.swift
//  WeatherAPITest
//
//  Created by 김태훈 on 2021/01/26.
//

import Foundation

struct WeatherFcst {
    let conditionId: Int
    let minTemp: Double
    let maxTemp: Double
    let dateTime: String
    
    var minTempString: String {
        return String(format: "%.1f", minTemp)
    }
    
    var maxTempString: String {
        return String(format: "%.1f", maxTemp)
    }
    
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}

