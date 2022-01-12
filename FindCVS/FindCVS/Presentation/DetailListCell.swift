//
//  DetailListCell.swift
//  FindCVS
//
//  Created by thoonk on 2022/01/12.
//

import UIKit

final class DetailListCell: UITableViewCell {
    static let identifier = "DetailListCell"
    
    lazy var placeNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.font =  .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = .darkGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with data: DetailListCellData) {
        placeNameLabel.text = data.placeName
        addressLabel.text = data.address
        distanceLabel.text = data.distance
    }
}

private extension DetailListCell {
    private func setupLayout() {
        [placeNameLabel, addressLabel, distanceLabel]
            .forEach { contentView.addSubview($0) }
        
        placeNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(18)
        }
        
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(placeNameLabel.snp.bottom).offset(3)
            $0.leading.equalTo(placeNameLabel)
            $0.bottom.equalToSuperview().inset(12)
        }
        
        distanceLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
    }
}
