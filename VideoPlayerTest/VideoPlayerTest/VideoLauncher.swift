//
//  VideoLauncher.swift
//  VideoPlayerTest
//
//  Created by MA2103 on 2021/12/30.
//

import UIKit
import AVFoundation
import SnapKit



class VideoLauncher: NSObject {
    let keyWindow = UIApplication.shared.connectedScenes
        .filter { $0.activationState == .foregroundActive }
        .map { $0 as? UIWindowScene }
        .compactMap { $0 }
        .first?.windows
        .filter { $0.isKeyWindow }.first
    
    func showVideoPlayer() {
        
        if let keyWindow = keyWindow {
            let view = UIView(frame: keyWindow.frame)
            view.backgroundColor = UIColor.white
            
            view.frame = CGRect(
                x: keyWindow.frame.width - 10,
                y: keyWindow.frame.height - 10,
                width: 10,
                height: 10
            )
            
//            let videoPlayerView = VideoPlayerView(frame: CGRect(
//                x: 0,
//                y: 0,
//                width: keyWindow.frame.width,
//                height: keyWindow.frame.width * 9 / 16 // 16 x 9 HD
//            ))
            let videoPlayerView = VideoPlayerView()
            view.addSubview(videoPlayerView)
            
            videoPlayerView.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.top.equalToSuperview().inset(50)
                $0.height.equalTo(videoPlayerView.snp.width).multipliedBy(9.0/16.0).priority(750)
            }
            
            keyWindow.addSubview(view)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
                view.frame = keyWindow.frame

            } completion: { _ in
                // do something later
//                UIApplication.shared.setStatusBarHidden(true, with: .fade)
            }
        }
    }
}
