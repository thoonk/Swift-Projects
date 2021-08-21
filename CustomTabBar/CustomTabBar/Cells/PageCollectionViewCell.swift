//
//  PageCollectionViewCell.swift
//  CustomTabBar
//
//  Created by 김태훈 on 2021/08/20.
//

import UIKit

class PageCollectionViewCell: UICollectionViewCell {
    static let name = "PageCollectionViewCell"
    static let id = "pageCell"

    var pageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addSubview(pageLabel)
        self.backgroundColor = .white
        pageLabel
            .centerXAnchor
            .constraint(equalTo: self.centerXAnchor)
            .isActive = true
        pageLabel
            .centerYAnchor
            .constraint(equalTo: self.centerYAnchor)
            .isActive = true
    }
}
