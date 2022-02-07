//
//  UIView.swift
//  VideoPlayerTest
//
//  Created by thoonk on 2022/01/06.
//

import UIKit

extension UIView {
    var parentViewController: UIViewController? {
        // Starts from next (As we know self is not a UIViewController).
        var parentResponder: UIResponder? = self.next
        while parentResponder != nil {
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
            parentResponder = parentResponder?.next
        }
        return nil
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11.0, *) {
            clipsToBounds = true
            layer.cornerRadius = radius
            layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        } else {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }
    
    func makeCircleWith(size: CGSize, backgroundColor: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(backgroundColor.cgColor)
        context?.setStrokeColor(UIColor.clear.cgColor)
        let bounds = CGRect(origin: .zero, size: size)
        context?.addEllipse(in: bounds)
        context?.drawPath(using: .fill)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func formatTime(_ time: Int) -> String {
        let hours = time / 3600
        let minutes = (time / 60) % 60
        let seconds = time % 60
        
        let hourStr = String(format: "%02d", hours)
        let minuteStr = String(format: "%02d", minutes)
        let secondStr = String(format: "%02d", seconds)
        
        return hours > 0 ?
        "\(hourStr):\(minuteStr):\(secondStr)" :
        "\(minuteStr):\(secondStr)"
    }
    
    func formatTimeForDesc(with time: Int) -> String {
        let hours = String(format: "%02d", time / 3600)
        let minutes = String(format: "%02d", (time / 60) % 60)
        let seconds = String(format: "%02d", time % 60)
        
        return "\(hours):\(minutes):\(seconds)"
    }
}
