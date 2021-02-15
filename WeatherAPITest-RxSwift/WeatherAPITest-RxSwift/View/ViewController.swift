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
    
    let currentViewModel = CurrentViewModel()
    let fcstViewModel = FcstViewModel()
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
        setCurrentBinding()
        setFcstBinding()
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
    
    func setCurrentBinding() {
        let locationManager = LocationManager.shared
        let input = CurrentViewModel.Input(location: locationManager.location, placemark: locationManager.placemark)
        let output = currentViewModel.bind(input: input)
        
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
    
    func setFcstBinding() {
        let locationManager = LocationManager.shared
        let input = FcstViewModel.Input(location: locationManager.location)
        let output = fcstViewModel.bind(input: input)
        
        output.isLoading
            .map { !$0 }
            .bind(to: activityIndicatorView.rx.isHidden)
            .disposed(by: bag)
        
        output.fcstData
            .bind(to: tableView.rx.items(cellIdentifier: C.Cell.identifier, cellType: WeatherTableViewCell.self)) { index, item, cell in
                
                cell.weekLabel.text = item.weekWeather?.dateTime
                cell.tempLabel.text = "\(item.weekWeather?.maxTempString ?? "-") / \(item.weekWeather?.minTempString ?? "-")"
                cell.weatherImageView.image = UIImage(systemName: item.weekWeather?.conditionName ?? "sum.max")
                
                let morningPM: PMModel = item.weekPM![0]
                let afterrnoonPM: PMModel = item.weekPM![1]
                let eveningPM: PMModel = item.weekPM![2]
                
                cell.morningPMLabel.text = "\(morningPM.pm10Status) / \(morningPM.pm25Status)"
                cell.afternoonPMLabel.text = "\(afterrnoonPM.pm10Status) / \(afterrnoonPM.pm25Status)"
                cell.eveningPMLabel.text = "\(eveningPM.pm10Status) / \(eveningPM.pm25Status)"
                
            }.disposed(by: bag)
    }
}

