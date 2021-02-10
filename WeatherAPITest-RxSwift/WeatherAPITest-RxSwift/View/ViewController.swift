//
//  ViewController.swift
//  WeatherAPITest
//
//  Created by 김태훈 on 2021/01/24.
//

import UIKit
import RxCocoa
import RxSwift
import RxCoreLocation
import CoreLocation

class ViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    
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
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        currentWeatherLabel.adjustsFontSizeToFitWidth = true
        locationLabel.adjustsFontSizeToFitWidth = true
    }
}

