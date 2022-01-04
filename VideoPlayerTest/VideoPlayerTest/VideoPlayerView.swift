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

    lazy var controlsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.startAnimating()
        return aiv
    }()
    
    lazy var pauseButton: UIButton = {
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
    
    lazy var fullScreenButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(systemName: "arrow.up.left.an d.arrow.down.right")
        button.tintColor = .white
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(handleFullScreen), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handleFullScreen() {
        if isFullScreen {
            // portrait 전환
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        } else {
            // landscape 전환
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        }
    }
    
    lazy var videoLengthLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    lazy var separotorLabel: UILabel = {
        let label = UILabel()
        label.text = "/"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    lazy var currentTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
 
    lazy var videoSlider: UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = .white
        slider.maximumTrackTintColor = .systemGray
        let thumbnailImage = makeCircleWith(size: CGSize(width: 18, height: 18), backgroundColor: .white)
        // UIImage(systemName: "circle.fill")
        slider.setThumbImage(thumbnailImage, for: .normal)
        // slider.thumbTintColor = .white
        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        return slider
    }()
    
    @objc func handleSliderChange() {
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
        setupOrientationObserver()
        setupLayout()
        
        backgroundColor = .black
    }
    
    deinit {
        player?.pause()
        playerLayer?.removeFromSuperlayer()
        self.player = nil
        
        NotificationCenter.default.removeObserver(
            self,
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
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
        let urlString = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4"
        // "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"

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
    
    func setupLayout() {
        addSubview(controlsContainerView)
        
        controlsContainerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.top.bottom.equalToSuperview()
        }
        
        let videoTimeStackView = UIStackView(arrangedSubviews: [currentTimeLabel, separotorLabel, videoLengthLabel])
        videoTimeStackView.distribution = .fillProportionally
        videoTimeStackView.spacing = 4.0
        
        [
            activityIndicatorView,
            pauseButton,
            videoSlider,
            videoTimeStackView,
            fullScreenButton
        ]
            .forEach { controlsContainerView.addSubview($0) }
        
        activityIndicatorView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        pauseButton.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.height.equalTo(80)
        }
        
        videoSlider.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(5)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        videoTimeStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(10)
            $0.bottom.equalTo(videoSlider.snp.top).offset(5)
            $0.height.equalTo(24)
        }
        
        currentTimeLabel.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(40)
        }

        videoLengthLabel.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(40)
        }
        
        fullScreenButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
            $0.bottom.equalTo(videoTimeStackView)
            $0.width.height.equalTo(25)
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
        if isFullScreen {
            // portrait 전환
            fullScreenButton.setImage(systemName: "arrow.up.left.and.arrow.down.right")
        } else {
            // landscape 전환
            fullScreenButton.setImage(systemName: "arrow.down.right.and.arrow.up.left")
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
}
