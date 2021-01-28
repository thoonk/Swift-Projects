//
//  PMModel.swift
//  WeatherAPITest
//
//  Created by 김태훈 on 2021/01/28.
//

import Foundation

struct PMModel {
    let dateTime: String
    let pm10: Double
    let pm25: Double

    var pm10Status: String {
        switch pm10 {
        case 0...30.99:
            return "Good"
        case 31...50.99:
            return "Normal"
        case 51...100.99:
            return "Bad"
        case 101...:
            return "Very Bad"
        default:
            return "Unknown"
        }
    }
    
    var pm25Status: String {
        switch pm25 {
        case 0...15.99:
            return "Good"
        case 16...25.99:
            return "Normal"
        case 26...50.99:
            return "Bad"
        case 51...:
            return "Very Bad"
        default:
            return "Unknown"
        }
    }
}
