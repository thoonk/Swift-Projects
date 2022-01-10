//
//  PlayerView.swift
//  VideoPlayerTest
//
//  Created by MA2103 on 2022/01/03.
//

import UIKit
import AVFoundation
import SnapKit

protocol PlayerDelegate: AnyObject {
    func didSelectSpeed(with rate: SpeedRate)
}

final class PlayerView: UIView {
    // MARK: - Properties
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var isPlaying: Bool {
        player?.rate != 0 && player?.error == nil
    }
    
    var isFullScreen: Bool {
        get {
            guard let interfaceOrientation =  UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.windowScene?.interfaceOrientation else { return false }
            return interfaceOrientation.isLandscape
        }
    }
    
    var currentSpeed: SpeedRate = .originalSpeed {
        didSet {
            speedButton.setTitle("\(currentSpeed.title)", for: .normal)
        }
    }
    
    var delayItem: DispatchWorkItem?
    var isControlVisible = true
    var isPlayToTheEnd = false
    var tapGesture: UITapGestureRecognizer!

    // MARK: - UI Components
    lazy var controlsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.4)
        
        return view
    }()
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.startAnimating()
        return aiv
    }()
    
    lazy var pausePlayButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(systemName: "pause", size: 30)
        button.tintColor = .white
        button.isHidden = true
        button.addTarget(self, action: #selector(handlePausePlay), for: .touchUpInside)
        return button
    }()
    
    @objc func handlePausePlay() {
        if isPlaying {
            player?.pause()
            pausePlayButton.setImage(systemName: "play", size: 30)
        } else {
            player?.rate = self.currentSpeed.value
            pausePlayButton.setImage(systemName: "pause", size: 30)
            autoDisappearControlView()
        }
    }
    
    lazy var backwardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(systemName: "gobackward.10", size: 30)
        button.tintColor = .white
        button.isHidden = true
        button.contentMode = .scaleToFill

        button.addTarget(self, action: #selector(handleBackward), for: .touchUpInside)
        return button
    }()
    
    @objc func handleBackward() {
        if let currentTime = player?.currentTime() {
            var newTime = CMTimeGetSeconds(currentTime) - 10.0
            if newTime <= 0 {
                newTime = 0
            }
            
            player?.seek(to: CMTime(value: CMTimeValue(newTime * 1000), timescale: 1000))
        }
    }
    
    lazy var forwardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(systemName: "goforward.10", size: 30)
        button.tintColor = .white
        button.isHidden = true
        button.contentMode = .scaleToFill

        button.addTarget(self, action: #selector(handleForward), for: .touchUpInside)
        return button
    }()
    
    @objc func handleForward() {
        if let currentTime = player?.currentTime(),
           let duration = player?.currentItem?.duration {
            var newTime = CMTimeGetSeconds(currentTime) + 10.0
            let durationSeconds = CMTimeGetSeconds(duration)
            if newTime >= durationSeconds {
                newTime = durationSeconds
            }
            
            player?.seek(to: CMTime(value: CMTimeValue(newTime * 1000), timescale: 1000))
        }
    }
    
    lazy var fullScreenButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(systemName: "arrow.up.left.an d.arrow.down.right", size: 18)
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
    
    lazy var speedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("1.0x", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(handleSpeed), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handleSpeed() {
        let actionSheet = UIAlertController(title: "재생 속도", message: "", preferredStyle: .actionSheet)
        
        let action05 = configureAlertAction(with: .speed05)
        let action075 = configureAlertAction(with: .speed075)
        let actionOriginal = configureAlertAction(with: .originalSpeed)
        let action15 = configureAlertAction(with: .speed15)
        let action2 = configureAlertAction(with: .speed2)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        [
            action05,
            action075,
            actionOriginal,
            action15,
            action2,
            cancelAction
        ]
            .forEach { actionSheet.addAction($0) }
        
        if let vc = self.parentViewController as? PlayerVC {
            vc.present(actionSheet, animated: true)
        }
    }
    
    lazy var menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(systemName: "applelogo", size: 18)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleMenu), for: .touchUpInside)
        return button
    }()
    
    @objc func handleMenu() {
        let menuView = MenuView()
        menuView.modalPresentationStyle = .custom
        
        if let vc = self.parentViewController as? PlayerVC {
            menuView.transitioningDelegate = vc
            vc.present(menuView, animated: true)
        }
    }
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(systemName: "chevron.backward", size: 20)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handleBack() {
        if let vc = self.parentViewController as? PlayerVC {
            vc.navigationController?.popViewController(animated: true)
        }
    }
    
    lazy var replayButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "replay"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleReplay), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    @objc func handleReplay() {
        replayButton.isHidden = true
        isPlayToTheEnd = false
        
        player?.seek(to: CMTime.zero)
        player?.play()
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
            })
        }
    }
    
    // MARK: - init
    required init(_ urlString: String) {
        super.init(frame: .zero)
        setupPlayerView(urlString)
        setupGradientLayer()
        setupOrientationObserver()
        setupLayout()
        setupTapGesture()
        autoDisappearControlView()
        
        backgroundColor = .black
    }
    
    deinit {
        if isPlaying == true {
            player?.pause()
        }
        
        player?.removeObserver(self, forKeyPath: "currentItem.loadedTimeRanges")
        player?.removeObserver(self, forKeyPath: "rate")
        self.player = nil
        
        playerLayer?.removeFromSuperlayer()
        controlsContainerView.removeFromSuperview()
        
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
        
        if let keyPath = keyPath {
            switch keyPath {
            case "currentItem.loadedTimeRanges":
                activityIndicatorView.stopAnimating()
                
                [pausePlayButton, backwardButton, forwardButton]
                    .forEach { $0.isHidden = false }
                
                if let duration = player?.currentItem?.duration {
                    let seconds = CMTimeGetSeconds(duration)
                    
                    guard !(seconds.isNaN || seconds.isInfinite) else { return }
                    
                    let secondsText = Int(seconds.truncatingRemainder(dividingBy: 60))
                    let minutesText = String(format: "%02d", Int(seconds) / 60)
                    videoLengthLabel.text = "\(minutesText):\(secondsText)"
                }
                
            case "rate":
                if let player = player {
                    if player.rate == 0.0,
                        let currentItem = player.currentItem {
                        if player.currentTime() >= currentItem.duration {
                            isPlayToTheEnd = true
                            replayButton.isHidden = false
                            [pausePlayButton, backwardButton, forwardButton]
                                .forEach { $0.isHidden = true }
                            controlViewAnimation(isVisible: true)
                        }
                    }
                }
            default:
                break
            }
        }
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods
private extension PlayerView {
    func setupPlayerView(_ urlString: String) {
        if let url = URL(string: urlString) {
            player = AVPlayer(url: url)
            player?.actionAtItemEnd = .pause
            player?.currentItem?.audioTimePitchAlgorithm = .timeDomain

            self.playerLayer = AVPlayerLayer(player: player)
            self.layer.addSublayer(playerLayer!)
            self.playerLayer?.frame = frame
            self.playerLayer?.videoGravity = .resizeAspect
            
            player?.play()
            
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
            player?.addObserver(self, forKeyPath: "rate", options: .new, context: nil)
            
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
            $0.edges.equalToSuperview()
        }
        
        let videoTimeStackView = UIStackView(arrangedSubviews: [currentTimeLabel, separotorLabel, videoLengthLabel])
        videoTimeStackView.alignment = .fill
        videoTimeStackView.distribution = .fillProportionally
        videoTimeStackView.spacing = 4.0
        
        let centerControlStackView = UIStackView(arrangedSubviews: [backwardButton, pausePlayButton, forwardButton])
        centerControlStackView.alignment = .fill
        centerControlStackView.distribution = .fillEqually
        centerControlStackView.spacing = 50.0
        
        [
            activityIndicatorView,
            centerControlStackView,
            videoSlider,
            videoTimeStackView,
            fullScreenButton,
            speedButton,
            menuButton,
            backButton,
            replayButton
        ]
            .forEach { controlsContainerView.addSubview($0) }
        
        activityIndicatorView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        centerControlStackView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        replayButton.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
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
            $0.width.height.equalTo(20)
        }
        
        menuButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(10)
            $0.width.height.equalTo(30)
        }
        
        speedButton.snp.makeConstraints {
            $0.top.equalTo(menuButton)
            $0.trailing.equalTo(menuButton.snp.leading).offset(-10)
            $0.width.height.equalTo(30)
        }
        
        backButton.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(10)
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
    
    func setupTapGesture() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapGestureTapped(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    @objc func onTapGestureTapped(_ gesture: UITapGestureRecognizer) {
        guard !isPlayToTheEnd else { return }
        if self.isPlaying {
            controlViewAnimation(isVisible: !isControlVisible)
        } else {
            controlViewAnimation(isVisible: true)
        }
    }
    
    func autoDisappearControlView() {
        if self.isControlVisible {
            delayItem?.cancel()
            delayItem = DispatchWorkItem { [weak self] in
                if self?.isPlayToTheEnd == false &&
                    self?.isPlaying == true
                {
                    self?.controlViewAnimation(isVisible: false)
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: delayItem!)
        }
    }
    
    func controlViewAnimation(isVisible: Bool) {
            let alpha: CGFloat = isVisible ? 1.0 : 0.0
            self.isControlVisible = isVisible
            
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.controlsContainerView.alpha = alpha
                self?.layoutIfNeeded()
            } completion: { [weak self] _ in
                self?.autoDisappearControlView()
            }
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
            // landscape 전환
            fullScreenButton.setImage(systemName: "arrow.down.right.and.arrow.up.left", size: 15)

            videoSlider.snp.remakeConstraints {
                $0.leading.trailing.equalToSuperview().inset(5)
                $0.bottom.equalToSuperview().inset(25)
                $0.height.equalTo(30)
            }
        } else {
            // portrait 전환
            fullScreenButton.setImage(systemName: "arrow.up.left.and.arrow.down.right", size: 15)

            videoSlider.snp.remakeConstraints {
                $0.leading.trailing.equalToSuperview().inset(5)
                $0.bottom.equalToSuperview()
                $0.height.equalTo(30)
            }
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
    
    func configureAlertAction(with speedRate: SpeedRate) -> UIAlertAction {
        return UIAlertAction(title: speedRate.title, style: .default) { [weak self] _ in
            self?.currentSpeed = speedRate
            if self?.isPlaying == true {
                self?.player?.rate = speedRate.value
            }
        }
    }
}

extension PlayerView: PlayerDelegate {
    func didSelectSpeed(with speed: SpeedRate) {
        switch speed {
        case .speed05:
            self.player?.rate = 0.5
        case .speed075:
            self.player?.rate = 0.75
        case .originalSpeed:
            self.player?.rate = 1.0
        case .speed15:
            self.player?.rate = 1.5
        case .speed2:
            self.player?.rate = 2.0
        }
    }
}
