//
//  ViewController.swift
//  WeatherAPITest
//
//  Created by 김태훈 on 2021/01/24.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.requestWhenInUseAuthorization()
        return manager
    }()
    
    var latitude = ""
    var longitude = ""
    var weekData: [WeatherFcst?] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.startUpdatingLocation()
        
        if let lat = locationManager.location?.coordinate.latitude,
           let lon = locationManager.location?.coordinate.longitude {
            self.latitude = "\(lat)"
            self.longitude = "\(lon)"
            print(self.latitude, self.longitude)
            
            WeatherAPIManager.shared.fetchFcstData(lat: self.latitude, lon: self.longitude) { [weak self] (result) in
                guard let self = self else { return }
                self.weekData = result
                print(self.weekData)
            }
        }
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = locations.last {
            manager.stopUpdatingLocation()
            self.latitude = "\(location.coordinate.latitude)"
            self.longitude = "\(location.coordinate.longitude)"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weekData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("before cell")
        guard let cell: WeatherTableViewCell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherTableViewCell, let weekData: WeatherFcst = self.weekData[indexPath.row] else {
                print("Error!!!!!")
                return UITableViewCell() }
        
        cell.weekLabel.text = "\(weekData.dateTime)"
        cell.tempLabel.text = "\(weekData.maxTempString)/\(weekData.minTempString)"
        cell.weatherImageView.image = UIImage(systemName: weekData.conditionName)
        
//        cell.tempLabel = self.weekDa
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
