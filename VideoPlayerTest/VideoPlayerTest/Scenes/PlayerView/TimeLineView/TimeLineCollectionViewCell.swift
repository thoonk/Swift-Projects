//
//  TimeLineCollectionViewCell.swift
//  VideoPlayerTest
//
//  Created by thoonk on 2022/02/07.
//

import UIKit
import SnapKit

final class TimeLineCollectionViewCell: UICollectionViewCell {
    static let identifier = "TimeLineViewCell"
    
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = "타임 라인 설명"
        label.textColor = .white
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.text = "00:00:00"
        label.textColor = .orange
        return label
    }()
    
    func configure(with data: TimeLine) {
        setupLayout()
        
        titleLabel.text = data.title
        timeLabel.text = formatTimeForDesc(with: data.timeStamp)
    }
}

// MARK: - Private Methods
private extension TimeLineCollectionViewCell {
    func setupLayout() {
        [
            thumbnailImageView,
            titleLabel,
            timeLabel
        ].forEach { contentView.addSubview($0) }
        
        let spacing: CGFloat = 5.0
        
        thumbnailImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(spacing)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(spacing)
            $0.leading.trailing.equalTo(thumbnailImageView)
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(spacing)
            $0.leading.trailing.equalTo(thumbnailImageView)
            $0.bottom.equalToSuperview().inset(spacing)
        }
    }
}
