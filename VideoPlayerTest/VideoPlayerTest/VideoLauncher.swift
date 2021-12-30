//
//  VideoLauncher.swift
//  VideoPlayerTest
//
//  Created by MA2103 on 2021/12/30.
//

import UIKit
import AVFoundation
import SnapKit

class VideoPlayerView: UIView {
    var isPlaying = false

    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.startAnimating()
        return aiv
    }()
    
    let pauseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(systemName: "pause")
        button.tintColor = .white
        button.isHidden = true
        
        button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        return button
    }()
    
    @objc func handlePause() {
        if isPlaying {
            player?.pause()
            pauseButton.setImage(systemName: "play")
        } else {
            player?.play()
            pauseButton.setImage(systemName: "pause")
        }

        isPlaying.toggle()
    }
    
    let controlsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()
    
    let videoLengthLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .right
        label.sizeToFit()
        return label
    }()
    
    let videoSlider: UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = .tintColor
        slider.maximumTrackTintColor = .white
        slider.setThumbImage(UIImage(systemName: "circle.fill"), for: .normal)
        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        return slider
    }()
    
    @objc func handleSliderChange() {
        print(videoSlider.value)
        
        if let duration = player?.currentItem?.duration {
            
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = Float64(videoSlider.value) * totalSeconds
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            
            player?.seek(to: seekTime, completionHandler: { _ in
                //
            })
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupPlayerView()
        
        controlsContainerView.frame = frame
        addSubview(controlsContainerView)
        
        controlsContainerView.addSubview(activityIndicatorView)
        activityIndicatorView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        controlsContainerView.addSubview(pauseButton)
        pauseButton.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.height.equalTo(80)
        }
        
        controlsContainerView.addSubview(videoLengthLabel)
        
        videoLengthLabel.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().inset(8)
            $0.width.equalTo(60)
            $0.height.equalTo(24)
        }
        
        controlsContainerView.addSubview(videoSlider)
        
        videoSlider.snp.makeConstraints {
            $0.trailing.equalTo(videoLengthLabel.snp.leading)
            $0.bottom.equalTo(videoLengthLabel)
            $0.leading.equalToSuperview().inset(8)
            $0.height.equalTo(30)
        }
        
        backgroundColor = .black
    }
    
    var player: AVPlayer?
    
    func setupPlayerView() {
        let urlString = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"

        if let url = URL(string: urlString) {
            player = AVPlayer(url: url)

            let playerLayer = AVPlayerLayer(player: player)
            self.layer.addSublayer(playerLayer)
            playerLayer.frame = self.frame

            player?.play()
            
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
            
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges" {
            activityIndicatorView.stopAnimating()
            controlsContainerView.backgroundColor = .clear
            pauseButton.isHidden = false
            isPlaying = true
            
            if let duration = player?.currentItem?.duration {
                let seconds = CMTimeGetSeconds(duration)
                let secondsText = Int(seconds) % 60
                let minutesText = String(format: "%02d", Int(seconds) / 60)
                videoLengthLabel.text = "\(minutesText):\(secondsText)"
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

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
            
            let videoPlayerView = VideoPlayerView(frame: CGRect(
                x: 0,
                y: 0,
                width: keyWindow.frame.width,
                height: keyWindow.frame.width * 9 / 16 // 16 x 9 HD
            ))
            view.addSubview(videoPlayerView)
            
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
