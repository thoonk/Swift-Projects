//
//  NewsListTableViewCell.swift
//  KeywordNews
//
//  Created by thoonk on 2022/02/04.
//

import UIKit

final class NewsListTableViewCell: UITableViewCell {
    
    static let identifier = "NewsListTableView"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15.0, weight: .semibold)
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .medium)
        
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0, weight: .medium)
        label.textColor = .secondaryLabel
        
        return label
    }()
    
    func configure() {
        setupLayout()
        
        selectionStyle = .none
        accessoryType = .disclosureIndicator
        
        titleLabel.text = "제목"
        descriptionLabel.text = "내용"
        dateLabel.text = "2022.02.04"
    }
}

private extension NewsListTableViewCell {
    func setupLayout() {
        [
            titleLabel,
            descriptionLabel,
            dateLabel
        ].forEach { addSubview($0) }
        
        let superViewInset: CGFloat = 16.0
        let verticalSpacing: CGFloat = 4.0
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16.0)
            $0.trailing.equalToSuperview().inset(48.0)
            $0.top.equalToSuperview().inset(superViewInset)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(verticalSpacing)
        }
        
        dateLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(titleLabel)
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(verticalSpacing)
            $0.bottom.equalToSuperview().inset(superViewInset)
        }
    }
}
