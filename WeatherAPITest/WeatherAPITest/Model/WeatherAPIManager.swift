//
//  WeatherAPIManager.swift
//  WeatherAPITest
//
//  Created by 김태훈 on 2021/01/24.
//

import Foundation
import Alamofire
import CoreLocation

class WeatherAPIManager {
    
    static let shared = WeatherAPIManager()
    private init() {}
    
    private let baseUrl = "https://api.openweathermap.org/data/2.5/onecall?appid=APIKey&units=metric&exclude=hourly,minutely,current"
    
    private var weekData = [WeatherFcst]()
    
    func getWeekDataCount() -> Int {
        return weekData.count
    }
    
    private func requestFcstData(with url: String, completion: @escaping (_ result: [WeatherFcst]) -> Void) {
        
        AF.request(url).responseJSON { response in
            switch response.result {
            case.success(let data):
                guard let weatherData = self.parseJSON(data) else { return }
                self.weekData = weatherData
//                print(weatherData)
                completion(weatherData)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchFcstData (lat: String, lon: String, completion: @escaping (_ result: [WeatherFcst]) -> Void) {
        let urlString = "\(baseUrl)&lat=\(lat)&lon=\(lon)"
        requestFcstData(with: urlString, completion: completion)
    }
    
    func parseJSON(_ data: Any) -> [WeatherFcst]? {
        
        do {
            let weatherData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            let result = try JSONDecoder().decode(WeatherData.self, from: weatherData)
            var weathers: [WeatherFcst] = []
            
            for i in 0..<result.daily.count {
                let currentData = result.daily[i]
                let weekDate: String = Date(timeIntervalSince1970: currentData.dt).toLocalized(with: result.timezone)
                let minTemp = currentData.temp.min
                let maxTemp = currentData.temp.max
                let weatherId = currentData.weather[0].id
                
                let dailyWeather = WeatherFcst(conditionId: weatherId, minTemp: minTemp, maxTemp: maxTemp, dateTime: weekDate)
                weathers.append(dailyWeather)
            }
            return weathers

        } catch {
            print("JSON Error: \(error.localizedDescription)")
            return nil
        }
    }
}
