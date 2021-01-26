//
//  ViewController.swift
//  WeatherAPITest
//
//  Created by 김태훈 on 2021/01/24.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var weekData: [WeatherFcst?] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        if latitude != nil, longitude != nil {
            WeatherAPIManager.shared.fetchFcstData(lat: latitude!, lon: longitude!) { [weak self] (result) in
                guard let self = self else { return }
                self.weekData = result
            }
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = manager.location?.coordinate {
            
            print("latitude: \(coordinate.latitude), logitude: \(coordinate.longitude)")
            self.latitude = coordinate.latitude
            self.longitude = coordinate.longitude
            locationManager.stopUpdatingLocation()
        }
    }
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: WeatherTableViewCell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherTableViewCell else { return UITableViewCell() }
        
//        cell.tempLabel = self.weekDa
        
        return cell
    }
}
