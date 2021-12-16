//
//  UIButton.swift
//  Outstagram
//
//  Created by MA2103 on 2021/12/16.
//

import UIKit

extension UIButton {
    func setImage(systemName: String) {
        contentHorizontalAlignment = .fill
        contentVerticalAlignment = .fill
        
        imageView?.contentMode = .scaleAspectFill
        
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.contentInsets = .zero
            config.image = UIImage(systemName: systemName)
            
            self.configuration = config
        } else {
            imageEdgeInsets = .zero
            setImage(UIImage(systemName: systemName), for: .normal)
        }
    }
}
