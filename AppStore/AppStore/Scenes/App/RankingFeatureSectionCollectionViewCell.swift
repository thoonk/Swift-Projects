//
//  RankingFeatureSectionCollectionViewCell.swift
//  AppStore
//
//  Created by MA2103 on 2021/12/09.
//

import UIKit
import SnapKit

final class RankingFeatureSectionCollectionViewCell: UICollectionViewCell {
    static let identifier = "RankingFeatureSectionCollectionViewCell"
    static var height: CGFloat = 70.0
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 7.0
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.separator.cgColor
        imageView.backgroundColor = .tertiarySystemGroupedBackground
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0, weight: .bold)
        label.textColor = .label
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13.0, weight: .semibold)
        label.textColor = .secondaryLabel
        
        return label
    }()
    
    private lazy var downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("받기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13.0, weight: .bold)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .secondarySystemBackground
        button.layer.cornerRadius = 12.0
        button.clipsToBounds = true
        
        return button
    }()
    
    private lazy var inAppPurchaseInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "앱 내 구입"
        label.font = .systemFont(ofSize: 10.0, weight: .semibold)
        label.textColor = .secondaryLabel
        
        return label
    }()
    
    func setup(with data: RankingFeature) {
        setupLayout()
        
        titleLabel.text = data.title
        descriptionLabel.text = data.description
        inAppPurchaseInfoLabel.isHidden = !data.isInPurchaseApp
    }
}

private extension RankingFeatureSectionCollectionViewCell {
    func setupLayout() {
        [
            imageView,
            titleLabel,
            descriptionLabel,
            downloadButton,
            inAppPurchaseInfoLabel
        ].forEach { addSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview().inset(4.0)
            $0.bottom.equalToSuperview().inset(4.0)
            $0.width.equalTo(imageView.snp.height)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(8.0)
            $0.trailing.equalTo(downloadButton.snp.leading)
            $0.top.equalToSuperview().inset(8.0)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.equalTo(titleLabel.snp.trailing)
        }
        
        downloadButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(50.0)
            $0.height.equalTo(24.0)
        }
        
        inAppPurchaseInfoLabel.snp.makeConstraints {
            $0.top.equalTo(downloadButton.snp.bottom).offset(4.0)
            $0.centerX.equalTo(downloadButton.snp.centerX)
        }
    }
}
