//
//  ViewController.swift
//  Covid-19
//
//  Created by 김태훈 on 2021/10/22.
//

import UIKit
import Charts
import Alamofire

class MainVC: UIViewController {

    @IBOutlet weak var totalCaseLabel: UILabel!
    @IBOutlet weak var newCaseLabel: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var labelStackView: UIStackView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicatorView.startAnimating()
        self.fetchCovidOverview { [weak self] result in
            guard let self = self else { return }
            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorView.isHidden = true
            self.labelStackView.isHidden = false
            self.pieChartView.isHidden = false

            switch result {
            case .success(let data):
                debugPrint("success \(data)")
                self.configureStackView(koreaCovidOverview: data.korea)
                let covidOverviewList = self.makeCovidOverviewList(cityCovidOverview: data)
                self.configureChartView(covidOverviewList: covidOverviewList)
            case .failure(let error):
                debugPrint("error \(error)")
            }
        }
    }
    
    func makeCovidOverviewList(cityCovidOverview: CityCovidOverview) -> [CovidOverview] {
        return [
            cityCovidOverview.seoul,
            cityCovidOverview.busan,
            cityCovidOverview.chungbuk,
            cityCovidOverview.chungnam,
            cityCovidOverview.daegu,
            cityCovidOverview.daejeon,
            cityCovidOverview.gangwon,
            cityCovidOverview.gwangju,
            cityCovidOverview.gyeongbuk,
            cityCovidOverview.gyeonggi,
            cityCovidOverview.gyeongnam,
            cityCovidOverview.incheon,
            cityCovidOverview.jeju,
            cityCovidOverview.jeonbuk,
            cityCovidOverview.jeonnam,
            cityCovidOverview.sejong
        ]
    }
    
    func configureChartView(covidOverviewList: [CovidOverview]) {
        self.pieChartView.delegate = self
        let entries = covidOverviewList.compactMap { [weak self] overview -> PieChartDataEntry? in
            guard let self = self else { return nil }
            return PieChartDataEntry(
                value: self.removeFormatString(string: overview.newCase),
                label: overview.countryName,
                data: overview
            )
        }
        
        let dataSet = PieChartDataSet(entries: entries, label: "코로나 발생 현황")
        dataSet.sliceSpace = 1
        dataSet.entryLabelColor = .black
        dataSet.valueTextColor = .black
        dataSet.xValuePosition = .outsideSlice
        dataSet.valueLinePart1OffsetPercentage = 0.8
        dataSet.valueLinePart1Length = 0.2
        dataSet.valueLinePart2Length = 0.3
        
        dataSet.colors = ChartColorTemplates.vordiplom() +
        ChartColorTemplates.joyful() +
        ChartColorTemplates.material() +
        ChartColorTemplates.liberty()
        
        self.pieChartView.data = PieChartData(dataSet: dataSet)
        self.pieChartView.spin(duration: 0.3, fromAngle: self.pieChartView.rotationAngle, toAngle: self.pieChartView.rotationAngle + 80)
    }
    
    func removeFormatString(string: String) -> Double {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: string)?.doubleValue ?? 0
    }
    
    func configureStackView(koreaCovidOverview: CovidOverview) {
        self.totalCaseLabel.text = "\(koreaCovidOverview.totalCase)명"
        self.newCaseLabel.text = "\(koreaCovidOverview.newCase)명"
    }
    
    func fetchCovidOverview(completion: @escaping (Result<CityCovidOverview, Error>) -> Void) {
        let url = "https://api.corona-19.kr/korea/country/new/"
        let param = [
            "serviceKey": "APIKey"
        ]
        
        AF.request(url, method: .get, parameters: param)
            .responseData { response in
                switch response.result {
                case let .success(data):
                    do {
                        let result = try JSONDecoder().decode(CityCovidOverview.self, from: data)
                        completion(.success(result))
                    } catch {
                        completion(.failure(error))
                    }
                case let .failure(error):
                    completion(.failure(error))
                }
            }
    }
}

extension MainVC: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let covidDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "CovidDetailVC") as? CovidDetailVC,
              let covidOverview = entry.data as? CovidOverview
        else { return }
        
        covidDetailVC.covidOverview = covidOverview
        self.navigationController?.pushViewController(covidDetailVC, animated: true)
    }
}
