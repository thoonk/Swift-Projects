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
    var latitude = ""
    var longitude = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let epochTime = TimeInterval(1611543600)
        let date = Date(timeIntervalSince1970: epochTime)
        print(date.toKST())
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = manager.location?.coordinate {
            print("latitude: \(coordinate.latitude), logitude: \(coordinate.longitude)")
            
            latitude = String(coordinate.latitude)
            longitude = String(coordinate.longitude)
            
            if latitude != "", longitude != "" {
                locationManager.stopUpdatingLocation()
            }
        }
    }
}
