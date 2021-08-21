//
//  MenuBarCollectionViewCell.swift
//  CustomTabBar
//
//  Created by 김태훈 on 2021/08/20.
//

import UIKit

class MenuBarCollectionViewCell: UICollectionViewCell {
    static let name = "MenuBarCollectionViewCell"
    static let id = "menuBarCell"
    
    var menuTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Menu"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .systemGray4
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addSubview(menuTitleLabel)
        menuTitleLabel
            .centerXAnchor
            .constraint(equalTo: self.centerXAnchor)
            .isActive = true
        menuTitleLabel
            .centerYAnchor
            .constraint(equalTo: self.centerYAnchor)
            .isActive = true
    }

    override var isSelected: Bool {
        didSet {
            self.menuTitleLabel.textColor = isSelected ? .black : .systemGray4
        }
    }
}
