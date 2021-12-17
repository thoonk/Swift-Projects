//
//  ProfileCollectionViewCell.swift
//  Outstagram
//
//  Created by MA2103 on 2021/12/17.
//

import UIKit
import SnapKit

final class ProfileCollectionViewCell: UICollectionViewCell {
    static let identifier = "ProfileCollectionViewCell"
    
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .tertiaryLabel
        
        return imageView
    }()
    
    func setup() {
        addSubview(thumbnailImageView)
        
        thumbnailImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
