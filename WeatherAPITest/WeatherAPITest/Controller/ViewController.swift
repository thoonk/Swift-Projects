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
        return manager
    }()
    
    var latitude = ""
    var longitude = ""
    
    var currentWeather: WeatherCurrent? {
        didSet {
            self.currentWeatherImageView.image = UIImage(systemName: currentWeather?.conditionName ?? "-")
            self.currentWeatherLabel.text = currentWeather?.temperatureString
        }
    }
    
    var currentPM: PMModel? {
        didSet {
            self.pm10Label.text = currentPM?.pm10Status
            self.pm25Label.text = currentPM?.pm25Status
        }
    }
    
    var weekWeather: [WeatherFcst?] = [] 
    
    var weekPM: [[PMModel?]] = [] {
        didSet {
            tableView.reloadData()
            activityIndicatorView.stopAnimating()
            activityIndicatorView.isHidden = true
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currentWeatherImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentWeatherLabel: UILabel!
    @IBOutlet weak var pm10Label: UILabel!
    @IBOutlet weak var pm25Label: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDataUsingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        currentWeatherLabel.adjustsFontSizeToFitWidth = true
        locationLabel.adjustsFontSizeToFitWidth = true
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setDataUsingLocation() {
        if let lat = locationManager.location?.coordinate.latitude,
           let lon = locationManager.location?.coordinate.longitude {
            self.latitude = "\(lat)"
            self.longitude = "\(lon)"
            print(self.latitude, self.longitude)

            activityIndicatorView.startAnimating()
            
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            WeatherAPIManager.shared.fetchCurrentData(lat: self.latitude, lon: self.longitude) { [weak self] (result) in
                guard let self = self else { return }
                self.currentWeather = result
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            WeatherAPIManager.shared.fetchFcstData(lat: self.latitude, lon: self.longitude) { [weak self] (result) in
                guard let self = self else { return }
                self.weekWeather = result
                dispatchGroup.leave()
            }
            dispatchGroup.enter()
            PMAPIManger.shared.fetchCurrentData(lat: self.latitude, lon: self.longitude) { [weak self] (result) in
                guard let self = self else { return }
                self.currentPM = result
                dispatchGroup.leave()
            }
            dispatchGroup.enter()
            PMAPIManger.shared.fetchFcstData(lat: self.latitude, lon: self.longitude) { [weak self] (result) in
                guard let self = self else { return }
                self.weekPM = result
                dispatchGroup.leave()
            }
            dispatchGroup.notify(queue: .global(qos: .userInteractive)){
                print("jobs are completed asynchronous")
            }
            print("job enter finished")
        }
    }
    
    func alertToUser(_ title: String, _ message: String) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction.init(title: "확인", style: .cancel, handler: nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func handleAuthenticalStatus(status: CLAuthorizationStatus) {
        switch status {
        case.notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            alertToUser("위치 서비스가 제한됩니다.", "이 앱에서 자녀 보호 서비스가 위치 정보를 제한합니다.")
        case .denied:
            alertToUser("위치 정보의 사용이 불가합니다.", "설정에서 위치 접근을 허용해주세요.")
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            setDataUsingLocation()
        @unknown default:
            print("Dev Alert: Unknown case of status in handleAuth\(status)")
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        handleAuthenticalStatus(status: manager.authorizationStatus)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = locations.last {
            manager.stopUpdatingLocation()
            self.latitude = "\(location.coordinate.latitude)"
            self.longitude = "\(location.coordinate.longitude)"
            
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                var state = ""
                var city = ""
                var sub = ""
                if placemarks != nil {
                    let placemark = placemarks?.last
                    state = placemark?.administrativeArea ?? ""
                    city = placemark?.locality ?? ""
                    sub = placemark?.subLocality ?? ""
                } else {
                    print("Error: ", error!)
                }
                
                self.locationLabel.text = "\(state) \(city) \(sub)"
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weekWeather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: WeatherTableViewCell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherTableViewCell,
              let weather: WeatherFcst = self.weekWeather[indexPath.row],
              let morningPM: PMModel = self.weekPM[indexPath.row][0],
              let afternoonPM: PMModel = self.weekPM[indexPath.row][1],
              let eveningPM: PMModel = self.weekPM[indexPath.row][2]
        else { return UITableViewCell() }
        
        cell.weekLabel.text = "\(weather.dateTime)"
        cell.tempLabel.text = "\(weather.maxTempString) / \(weather.minTempString)"
        cell.weatherImageView.image = UIImage(systemName: weather.conditionName)
        cell.morningPMLabel.text = "\(morningPM.pm10Status) / \(morningPM.pm25Status)"
        cell.afternoonPMLabel.text = "\(afternoonPM.pm10Status) / \(afternoonPM.pm25Status)"
        cell.eveningPMLabel.text = "\(eveningPM.pm10Status) / \(eveningPM.pm25Status)"
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
