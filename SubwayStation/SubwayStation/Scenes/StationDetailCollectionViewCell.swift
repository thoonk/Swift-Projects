//
//  StationDetailCollectionViewCell.swift
//  SubwayStation
//
//  Created by MA2103 on 2021/12/10.
//

import UIKit
import SnapKit

final class StationDetailCollectionViewCell: UICollectionViewCell {
    static let identifier = "StationDetailCollectionViewCell"
    
    private lazy var lineLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .bold)
        
        return label
    }()
    
    private lazy var remainInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0, weight: .medium)
        
        return label
    }()
    
    func setup(with realTimeArrival: StationArrivalDataResponseModel.RealTimeArrival) {
        layer.cornerRadius = 8.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 10
        
        backgroundColor = .systemBackground
        
        [lineLabel, remainInfoLabel]
            .forEach { addSubview($0) }
        
        lineLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(15.0)
        }
        
        remainInfoLabel.snp.makeConstraints {
            $0.leading.equalTo(lineLabel.snp.leading)
            $0.top.equalTo(lineLabel.snp.bottom).offset(5)
            $0.bottom.equalToSuperview().inset(15.0)
        }
        
        lineLabel.text = realTimeArrival.line
        remainInfoLabel.text = realTimeArrival.remainTime
    }
}
