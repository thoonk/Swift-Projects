//
//  WeatherAPIManager.swift
//  WeatherAPITest
//
//  Created by 김태훈 on 2021/01/24.
//

import Foundation
import Alamofire

class WeatherAPIManager {
    
    static let shared = WeatherAPIManager()
    private init() {}
    
    private let currentUrl = "https://api.openweathermap.org/data/2.5/weather?appid=APIKey&units=metric"
    
    private let fcstUrl = "https://api.openweathermap.org/data/2.5/onecall?appid=APIKey&units=metric&exclude=hourly,minutely,current"
    
    func fetchCurrentData(lat: String, lon: String, completion: @escaping (_ result: WeatherCurrent) -> Void) {
        let urlString = "\(currentUrl)&lat=\(lat)&lon=\(lon)"
        requestCurrentData(with: urlString, completion: completion)
    }
    
    func fetchFcstData (lat: String, lon: String, completion: @escaping (_ result: [WeatherFcst]) -> Void) {
        let urlString = "\(fcstUrl)&lat=\(lat)&lon=\(lon)"
        requestFcstData(with: urlString, completion: completion)
    }
    
    private func requestCurrentData(with url: String, completion: @escaping (_ result: WeatherCurrent) -> Void) {
        AF.request(url).responseJSON { response in
            switch response.result {
            case.success(let data):
                guard let weatherData = self.parseCurrentJSON(data) else { return }
                completion(weatherData)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func requestFcstData(with url: String, completion: @escaping (_ result: [WeatherFcst]) -> Void) {
        AF.request(url).responseJSON { response in
            switch response.result {
            case.success(let data):
                guard let weatherData = self.parseFcstJSON(data) else { return }
                completion(weatherData)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func parseCurrentJSON(_ data: Any) -> WeatherCurrent? {
        do {
            let weatherData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            let result = try JSONDecoder().decode(WeatherCurrentData.self, from: weatherData)
            let weather = WeatherCurrent(conditionId: result.weather[0].id, temperature: result.main.temp)
            return weather
            
        } catch {
            print("Current JSON Error: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func parseFcstJSON(_ data: Any) -> [WeatherFcst]? {
        do {
            let weatherData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            let result = try JSONDecoder().decode(WeatherFcstData.self, from: weatherData)
            var weathers: [WeatherFcst] = []

            for i in 0..<5 {
                let currentData = result.daily[i]
                let weekDate: String = Date(timeIntervalSince1970: currentData.dt).toLocalized(with: result.timezone, by: "day")
                let minTemp = currentData.temp.min
                let maxTemp = currentData.temp.max
                let weatherId = currentData.weather[0].id
            
                let dailyWeather = WeatherFcst(conditionId: weatherId, minTemp: minTemp, maxTemp: maxTemp, dateTime: weekDate)
                weathers.append(dailyWeather)
            }
            return weathers

        } catch {
            print("Weather Fcst JSON Error: \(error.localizedDescription)")
            return nil
        }
    }
}
