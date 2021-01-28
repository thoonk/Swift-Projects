//
//  PMAPIManager.swift
//  WeatherAPITest
//
//  Created by 김태훈 on 2021/01/28.
//

import Foundation
import Alamofire

class PMAPIManger {
    
    static let shared = PMAPIManger()
    private init() {}
    
    private let currentUrl = "https://api.openweathermap.org/data/2.5/air_pollution?appid=APIKey"
    
    private let fcstUrl = "https://api.openweathermap.org/data/2.5/air_pollution/forecast?appid=APIKey"
    
    func fetchCurrentData(lat: String, lon: String, completion: @escaping (_ result: PMModel) -> Void) {
        let urlString = "\(currentUrl)&lat=\(lat)&lon=\(lon)"
        requestCurrentData(with: urlString, completion: completion)
    }
    
    func fetchFcstData(lat: String, lon: String, completion: @escaping (_ result: [PMModel]) -> Void) {
        let urlString = "\(fcstUrl)&lat=\(lat)&lon=\(lon)"
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
    
    func requestFcstData(with url: String, completion: @escaping (_ result: [PMModel]) -> Void) {
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
    
    private func parseFcstJSON(_ data: Any) -> [PMModel]? {
        do {
            let pmData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            let result = try JSONDecoder().decode(PMData.self, from: pmData)

            var pms: [PMModel] = []

            for i in 0..<result.list.count {
                let dt = Date(timeIntervalSince1970: result.list[i].dt).toLocalized(with: "KST", by: "normal")
                let time = dt.split(separator: " ")
                let pm10 = result.list[i].components.pm10
                let pm25 = result.list[i].components.pm25
                if time[1] == "12:00", dt >= Date().toLocalized(with: "KST", by: "short") + " 12:00" {
                    let pm = PMModel(dateTime: dt, pm10: pm10, pm25: pm25)
                    pms.append(pm)
                }
            }
            return pms
        } catch {
            print("PM Fcst JSON Error: \(error.localizedDescription)")
            return nil
        }
    }
}
