//
//  FeatureSectionCollectionViewCell.swift
//  AppStore
//
//  Created by MA2103 on 2021/12/09.
//

import UIKit
import SnapKit
import Kingfisher

final class FeatureSectionCollectionViewCell: UICollectionViewCell {
    static let identifier = "FeatureSectionCollectionViewCell"
    
    private lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0, weight: .semibold)
        label.textColor = .systemBlue
        
        return label
    }()
    
    private lazy var appNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20.0, weight: .bold)
        label.textColor = .label
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0, weight: .semibold)
        label.textColor = .secondaryLabel
        
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 7.0
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.separator.cgColor
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    func setup(with data: Feature) {
        setupLayout()
        
        typeLabel.text = data.type
        appNameLabel.text = data.appName
        descriptionLabel.text = data.description
        
        if let imageURL = URL(string: data.imageURL) {
            imageView.kf.setImage(with: imageURL)
        }
    }
}

private extension FeatureSectionCollectionViewCell {
    func setupLayout() {
        [typeLabel, appNameLabel, descriptionLabel, imageView]
            .forEach { addSubview($0) }
        
        typeLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        appNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalTo(typeLabel.snp.bottom)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalTo(appNameLabel.snp.bottom).offset(4.0)
        }
        
        imageView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(8.0)
            $0.bottom.equalToSuperview().inset(8.0)
        }
    }
}
