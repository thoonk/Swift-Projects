//
//  VideoPlayerView.swift
//  VideoPlayerTest
//
//  Created by MA2103 on 2022/01/03.
//

import UIKit
import AVFoundation
import SnapKit

class VideoPlayerView: UIView {
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?

    var isPlaying = false
    
    var isFullScreen: Bool {
        get {
            guard let interfaceOrientation =  UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.windowScene?.interfaceOrientation else { return false }
            return interfaceOrientation.isLandscape
        }
    }

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
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .right
        label.sizeToFit()
        return label
    }()
    
    let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .right
        return label
    }()
 
    let videoSlider: UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = .systemBlue
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
        setupGradientLayer()
        
        addSubview(controlsContainerView)
        controlsContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
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
            $0.trailing.equalToSuperview().inset(5)
            $0.bottom.equalToSuperview().inset(3)
            $0.width.equalTo(50)
            $0.height.equalTo(24)
        }
        
        controlsContainerView.addSubview(currentTimeLabel)
        currentTimeLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(5)
            $0.bottom.equalTo(videoLengthLabel)
            $0.width.equalTo(50)
            $0.height.equalTo(24)
        }
        
        controlsContainerView.addSubview(videoSlider)
        videoSlider.snp.makeConstraints {
            $0.trailing.equalTo(videoLengthLabel.snp.leading).offset(4)
            $0.bottom.equalToSuperview()
            $0.leading.equalTo(currentTimeLabel.snp.trailing).offset(4)
            $0.height.equalTo(30)
        }
        
        backgroundColor = .black
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playerLayer?.frame = self.bounds
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges" {
            activityIndicatorView.stopAnimating()
            controlsContainerView.backgroundColor = .clear
            pauseButton.isHidden = false
            isPlaying = true
            
            if let duration = player?.currentItem?.duration {
                let seconds = CMTimeGetSeconds(duration)
                let secondsText = Int(seconds.truncatingRemainder(dividingBy: 60))
                let minutesText = String(format: "%02d", Int(seconds) / 60)
                videoLengthLabel.text = "\(minutesText):\(secondsText)"
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension VideoPlayerView {
    func setupPlayerView() {
        let urlString = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"

        if let url = URL(string: urlString) {
            player = AVPlayer(url: url)
            player?.actionAtItemEnd = .pause

            self.playerLayer = AVPlayerLayer(player: player)
            self.layer.addSublayer(playerLayer!)
            self.playerLayer?.frame = self.bounds
            self.playerLayer?.videoGravity = .resizeAspect
            
            player?.play()
            
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
            
            let interval = CMTime(value: 1, timescale: 2)
            player?.addPeriodicTimeObserver(
                forInterval: interval,
                queue: DispatchQueue.main,
                using: { [weak self] time in
                    guard let self = self else { return }
                    let seconds = CMTimeGetSeconds(time)
                    let secondsString = String(format: "%02d", Int(seconds.truncatingRemainder(dividingBy: 60)))
                    let minuteString = String(format: "%02d", Int(seconds / 60))
                    self.currentTimeLabel.text = "\(minuteString):\(secondsString)"
                    
                    if let duration = self.player?.currentItem?.duration {
                        let durationSeconds = CMTimeGetSeconds(duration)
                        self.videoSlider.value = Float(seconds / durationSeconds)
                    }
                }
            )
        }
    }
    
    func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.clear, UIColor.black]
        gradientLayer.locations = [0.7, 1.2]
        controlsContainerView.layer.addSublayer(gradientLayer)
    }
    
    func setupOrientationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.onOrientationChanged),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
    }
    
    @objc func onOrientationChanged() {

    }
}
