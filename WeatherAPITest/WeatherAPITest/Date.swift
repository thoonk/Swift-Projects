//
//  Date.swift
//  WeatherAPITest
//
//  Created by 김태훈 on 2021/01/24.
//

import Foundation

extension Date {
    func toLocalized(with id: String) -> String {
            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            dateFormatter.dateFormat = "EEEE"
            dateFormatter.timeZone = TimeZone(identifier: id)
            return dateFormatter.string(from: self)
    }
}
