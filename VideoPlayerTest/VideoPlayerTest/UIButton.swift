//
//  UIButton.swift
//  VideoPlayerTest
//
//  Created by MA2103 on 2021/12/30.
//

import UIKit

extension UIButton {
    func setImage(systemName: String, size: CGFloat) {
        contentHorizontalAlignment = .fill
        contentVerticalAlignment = .fill
        
        imageView?.contentMode = .scaleAspectFill
        
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.contentInsets = .zero
            config.image = UIImage(systemName: systemName)
            config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration.init(pointSize: size)
            
            self.configuration = config
        } else {
            imageEdgeInsets = .zero
            setImage(UIImage(systemName: systemName), for: .normal)
            setPreferredSymbolConfiguration(.init(pointSize: size), forImageIn: .normal)
        }
    }
}

