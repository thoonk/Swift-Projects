//
//  PlayerTimeLineCell.swift
//  VideoPlayerTest
//
//  Created by thoonk on 2022/01/10.
//

import UIKit
import SnapKit

final class PlayerTimeLineCell: UITableViewCell {
    static let identifier = "PlayerTimeLineCell"
    
    // MARK: - UI Components
    lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = "타임 라인 설명"
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .regular)
        label.text = "00:00:00"
        label.textColor = .orange
        return label
    }()
    
    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func configure(with data: TimeLine) {
        titleLabel.text = data.title
        timeLabel.text = formatTimeForDesc(with: data.timeStamp)
    }
}
 
// MARK: - Private Methods
private extension PlayerTimeLineCell {
    func setupLayout() {
        self.selectionStyle = .none
        
        [thumbnailImageView, titleLabel, timeLabel]
            .forEach { contentView.addSubview($0) }
        
        thumbnailImageView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview().inset(10)
            $0.width.equalTo(self.bounds.width / 2)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(7)
        }
    }
}
