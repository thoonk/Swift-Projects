//
//  PMAPIManager.swift
//  WeatherAPITest
//
//  Created by 김태훈 on 2021/01/28.
//

import Foundation
import Alamofire

class PMAPIManger {
    
    private enum URLType {
        case current
        case forecast
    }
    
    static let shared = PMAPIManger()
    private init() {}
        
    func fetchCurrentData(lat: String, lon: String, completion: @escaping (_ result: PMModel) -> Void) {
        let urlString = "\(createUrl(URLType.current))&lat=\(lat)&lon=\(lon)"
        requestCurrentData(with: urlString, completion: completion)
    }
    
    func fetchFcstData(lat: String, lon: String, completion: @escaping (_ result: [[PMModel]]) -> Void) {
        let urlString = "\(createUrl(URLType.forecast))&lat=\(lat)&lon=\(lon)"
        requestFcstData(with: urlString, completion: completion)
    }

    private func requestCurrentData(with url: String, completion: @escaping (_ result: PMModel) -> Void) {
        AF.request(url).responseJSON { response in
            switch response.result {
            case.success(let data):
                guard let pmModel = self.parseCurrentJSON(data) else { return }
                
                completion(pmModel)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func requestFcstData(with url: String, completion: @escaping (_ result: [[PMModel]]) -> Void) {
        AF.request(url).responseJSON { response in
            switch response.result {
            case.success(let data):
                guard let pmModel = self.parseFcstJSON(data) else { return }
                completion(pmModel)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func parseCurrentJSON(_ data: Any) -> PMModel? {
        do {
            let pmData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            let result = try JSONDecoder().decode(PMData.self, from: pmData)

            let pmDate = Date(timeIntervalSince1970: result.list[0].dt).toLocalized(with: "KST", by: "day")
            let pm = PMModel(dateTime: pmDate, pm10: result.list[0].components.pm10, pm25: result.list[0].components.pm25)

            return pm
            
        } catch {
            print("Current JSON Error: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func parseFcstJSON(_ data: Any) -> [[PMModel]]? {
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
        case .current:
            urlString += "/air_pollution?"
        case .forecast:
            urlString += "/air_pollution/forecast?"
        }
        urlString += "appid=\(C.apiKey)"
        
        return urlString
    }
}
