//
//  ViewController.swift
//  WeatherAPITest
//
//  Created by 김태훈 on 2021/01/24.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    
    let viewModel = CurrentViewModel()
    var bag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currentWeatherImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentWeatherLabel: UILabel!
    @IBOutlet weak var pm10Label: UILabel!
    @IBOutlet weak var pm25Label: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        currentWeatherLabel.adjustsFontSizeToFitWidth = true
        locationLabel.adjustsFontSizeToFitWidth = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        bag = DisposeBag()
    }
    
    func setBinding() {
        let locationManager = LocationManager.shared
        let input = CurrentViewModel.Input(location: locationManager.location, placemark: locationManager.placemark)
        let output = viewModel.bind(input: input)
        
        output.locationName
            .bind(to: locationLabel.rx.text)
            .disposed(by: bag)
        
        output.conditionName
            .map {
                UIImage(systemName: $0)
            }
            .observe(on: MainScheduler.instance)
            .bind(to: currentWeatherImageView.rx.image)
            .disposed(by: bag)
        
        output.temperature
            .bind(to: currentWeatherLabel.rx.text)
            .disposed(by: bag)
        
        output.pm10Status
            .bind(to: pm10Label.rx.text)
            .disposed(by: bag)
        
        output.pm25Status
            .bind(to: pm25Label.rx.text)
            .disposed(by: bag)
    }
}

