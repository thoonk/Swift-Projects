//
//  Date.swift
//  WeatherAPITest
//
//  Created by 김태훈 on 2021/01/24.
//

import Foundation

extension Date {
    func toKST() -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            dateFormatter.timeZone = TimeZone(identifier: "KST")
            return dateFormatter.string(from: self)
    }
}
