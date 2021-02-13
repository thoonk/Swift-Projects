//
//  WeatherAPIManager.swift
//  WeatherAPITest
//
//  Created by 김태훈 on 2021/01/24.
//

import Foundation
import Alamofire
import RxSwift

class WeatherAPIManager {
    
    private enum URLType {
        case current
        case forecast
    }
    
    static let shared = WeatherAPIManager()
    private init() {}

    // MARK: - Request Current Data
    func fetchCurrentData(lat: String, lon: String) -> Observable<WeatherCurrent> {
        return Observable.create() { emitter in
            let urlString = "\(self.createUrl(URLType.current))&lat=\(lat)&lon=\(lon)"
            self.requestCurrentData(with: urlString) { result in
                switch result {
                case .success(let data):
                    emitter.onNext(data)
                case .failure(let err):
                    emitter.onError(err)
                }
            }
            return Disposables.create()
        }
    }
    
    private func requestCurrentData(with url: String, completion: @escaping (Result<WeatherCurrent, Error>) -> Void) {
        AF.request(url).responseJSON { response in
            switch response.result {
            case.success(let data):
                guard let weatherData = self.parseCurrentJSON(data) else { return }
                completion(.success(weatherData))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
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
    
    // MARK: - Request Forecast Data
    func fetchFcstData(lat: String, lon: String) -> Observable<[WeatherFcst]> {
        return Observable.create() { emitter in
            let urlString = "\(self.createUrl(URLType.forecast))&lat=\(lat)&lon=\(lon)"
            self.requestFcstData(with: urlString) { result in
                switch result {
                case .success(let data):
                    emitter.onNext(data)
                case .failure(let err):
                    emitter.onError(err)
                }
            }
            return Disposables.create()
        }
    }
    
    private func requestFcstData(with url: String, completion: @escaping (Result<[WeatherFcst], Error>) -> Void) {
        AF.request(url).responseJSON { response in
            switch response.result {
            case.success(let data):
                guard let weatherData = self.parseFcstJSON(data) else { return }
                completion(.success(weatherData))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
  
    private func parseFcstJSON(_ data: Any) -> [WeatherFcst]? {
        do {
            let weatherData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            let result = try JSONDecoder().decode(WeatherFcstData.self, from: weatherData)
            var weathers: [WeatherFcst] = []
            
            for i in 0..<result.daily.count {
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
    
    private func createUrl(_ type: URLType) -> String {
        var urlString = C.baseUrl
        
        switch type {
        case .current:
            urlString += "/weather?units=metric"
        case .forecast:
            urlString += "/onecall?units=metric&exclude=hourly,minutely,current"
        }
        urlString += "&appid=\(C.apiKey)"
        
        return urlString
    }
}
