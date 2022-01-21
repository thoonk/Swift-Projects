//
//  AppUtility.swift
//  VideoPlayerTest
//
//  Created by thoonk on 2022/01/21.
//

import UIKit

struct AppUtility {
    static func lock(with orientation: UIInterfaceOrientation) {
        var orientationMask: UIInterfaceOrientationMask {
            switch orientation {
            case .unknown:
                return .all
            case .portrait:
                return .portrait
            case .portraitUpsideDown:
                return .portraitUpsideDown
            case .landscapeLeft:
                return .landscapeLeft
            case .landscapeRight:
                return .landscapeRight
            @unknown default:
                return .all
            }
        }
        
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientationMask
        }
    }
}
