//
//  FcstAPIManager.swift
//  WeatherAPITest
//
//  Created by 김태훈 on 2021/01/24.
//

import Foundation
import Alamofire
import RxSwift

class FcstAPIManager {
    
    private enum URLType {
        case weather
        case pm
    }

    static let shared = FcstAPIManager()
    private init() {}
    
    // MARK: - Request Forecast Data
    func fetchFcstData(lat: String, lon: String) -> Observable<[FcstModel]> {
        return Observable.create() { emitter in
            
            self.combineWeatherAndFM(lat: lat, lon: lon) { result, err  in
                if err != nil {
                    emitter.onError(err!)
                } else{
                    if result != nil {
                        emitter.onNext(result!)
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    private func combineWeatherAndFM(lat: String, lon: String, completion: @escaping ([FcstModel]?, Error?) -> Void) {
        var fcst = [FcstModel]()
        var weather: [WeatherFcst] = []
        var pm: [[PMModel]] = []
        
        let urlStringForWeather = "\(self.createUrl(URLType.weather))&lat=\(lat)&lon=\(lon)"
        self.requestFcstWeather(with: urlStringForWeather) { result in
            switch result {
            case .success(let data):
                weather = data
                for i in 0..<weather.count {
                    fcst.append(FcstModel(weekWeather: weather[i], weekPM: nil))
                }
            case .failure(let err):
                print("RequestError in weather")
                completion(nil, err)
            }
        }
        
        let urlStringForPM = "\(self.createUrl(URLType.pm))&lat=\(lat)&lon=\(lon)"
        self.requestPMData(with: urlStringForPM) { result in
            switch result {
            case .success(let data):
                pm = data
                for i in 0..<weather.count {
                    fcst[i].weekPM = pm[i]
                }
                completion(fcst, nil)
            case .failure(let err):
                print("RequestError in pm")
                completion(nil, err)
            }
        }
    }
    
    private func requestFcstWeather(with url: String, completion: @escaping (Result<[WeatherFcst], Error>) -> Void) {
        AF.request(url).responseJSON { response in
            switch response.result {
            case.success(let data):
                guard let weatherData = self.parseWeatherJSON(data) else { return }
                completion(.success(weatherData))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
  
    private func parseWeatherJSON(_ data: Any) -> [WeatherFcst]? {
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

    private func requestPMData(with url: String, completion: @escaping (Result<[[PMModel]], Error>) -> Void) {
        AF.request(url).responseJSON { response in
            switch response.result {
            case.success(let data):
                guard let pmModel = self.parsePMJSON(data) else { return }
                completion(.success(pmModel))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    private func parsePMJSON(_ data: Any) -> [[PMModel]]? {
        do {
            let pmData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            let result = try JSONDecoder().decode(PMData.self, from: pmData)
            var pmDay: [PMModel] = []
            var pms: [[PMModel]] = []
            
            
            for i in 0..<result.list.count {
                
                let dt = Date(timeIntervalSince1970: result.list[i].dt).toLocalized(with: "KST", by: "normal")
                let time = dt.split(separator: " ")
                let pm10 = result.list[i].components.pm10
                let pm25 = result.list[i].components.pm25

                if pmDay.count == 3 {
                    pms.append(pmDay)
                    pmDay = []
                }
                
                if dt >= Date().toLocalized(with: "KST", by: "short") {
                    if time[1] == "09:00" || time[1] == "14:00" || time[1] == "19:00" {
                        let pm = PMModel(dateTime: dt, pm10: pm10, pm25: pm25)
                        pmDay.append(pm)
                    }
                }
            }
        
            // 날씨예보 개수만큼 맞추기
            for _ in 0..<4 {
                for _ in 0..<3 {
                    let nilPM = PMModel(dateTime: "-", pm10: -0.1234, pm25: -0.1234)
                    pmDay.append(nilPM)
                }
                pms.append(pmDay)
            }

            return pms
        } catch {
            print("PM Fcst JSON Error: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func createUrl(_ type: URLType) -> String {
        var urlString = C.baseUrl
        
        switch type {
        case .weather:
            urlString += "/onecall?units=metric&exclude=hourly,minutely,current&"
        case .pm:
            urlString += "/air_pollution/forecast?"
        }
        urlString += "appid=\(C.apiKey)"
        
        return urlString
    }
}
