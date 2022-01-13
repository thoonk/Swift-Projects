//
//  PlayerView.swift
//  VideoPlayerTest
//
//  Created by MA2103 on 2022/01/03.
//

import UIKit
import AVFoundation
import AVKit 
import SnapKit

protocol PlayerDelegate: AnyObject {
//    func player(_ playerView: PlayerView, didPlayerStarted state: PlayerState)
    func player(_ playerView: PlayerView, didLoadedTimeChanged duration: TimeInterval)
    func player(_ playerView: PlayerView, didPlayTimeChanged currentTime: TimeInterval, totalTime: TimeInterval)
    func player(_ playerView: PlayerView, isPlayerPlaying isPlaying: Bool)
    func player(_ playerView: PlayerView, didChangePlayBackRate rate: SpeedRate)
}

//enum PlayerState {
//    case prepare
//    case readyToPlay
//    case beginToPlay
//    case playToTheEnd
//    case error
//}

final class PlayerView: UIView {
    // MARK: - Properties
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var controlView: PlayerControlView!
    
    weak var delegate: PlayerDelegate?
    
//    var playerState: PlayerState = .prepare {
//        didSet {
//            if playerState != oldValue {
//                delegate?.player(self, didPlayerStarted: playerState)
//            }
//        }
//    }
    
    var isPlaying: Bool {
        player?.rate != 0 && player?.error == nil
    }
        
    var isFullScreen: Bool {
        get {
            guard let interfaceOrientation =  UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.windowScene?.interfaceOrientation else { return false }
            return interfaceOrientation.isLandscape
        }
    }
    
    var currentSpeed: SpeedRate = .originalSpeed
    
    var delayItem: DispatchWorkItem?
    var isControlVisible = true
    var isPlayToTheEnd = false
    var tapGesture: UITapGestureRecognizer!
    
    // MARK: - init
    required init(_ urlString: String) {
        super.init(frame: .zero)
        
        setupPlayerView(urlString)
        controlView = PlayerControlView()
        controlView.delegate = self
        controlView.playerView = self
        
        setupGradientLayer()
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
        player = nil
        controlView = nil
        delegate = nil
        
        playerLayer?.removeFromSuperlayer()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playerLayer?.frame = self.bounds
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let keyPath = keyPath {
            switch keyPath {
            case "currentItem.loadedTimeRanges":
                if let duration = player?.currentItem?.duration {
                    let seconds = CMTimeGetSeconds(duration)
                    delegate?.player(self, didLoadedTimeChanged: seconds)
                }
                
            case "rate":
                if let player = player {
                    if player.rate == 0.0,
                        let currentItem = player.currentItem {
                        if player.currentTime() >= currentItem.duration {
//                            self.playerState = .playToTheEnd
                            isPlayToTheEnd = true
                            controlViewAnimation(isVisible: true)
                        }
                    }
                    // PIP모드에서 foreground로 돌아왔을 때 버튼 업데이트 처리
                    delegate?.player(self, isPlayerPlaying: self.isPlaying)
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
                    let currentTime = CMTimeGetSeconds(time)
                    
                    if let duration = self.player?.currentItem?.duration {
                        let totalTime = CMTimeGetSeconds(duration)
                        
                        self.delegate?.player(self, didPlayTimeChanged: currentTime, totalTime: totalTime)
                    }
                }
            )
        }
    }
    
    func setupLayout() {
        self.addSubview(controlView)
        
        controlView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.clear, UIColor.black]
        gradientLayer.locations = [0.7, 1.2]
//        controlsContainerView.layer.addSublayer(gradientLayer)
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
                self?.controlView.alpha = alpha
                self?.layoutIfNeeded()
            } completion: { [weak self] _ in
                self?.autoDisappearControlView()
            }
    }
    
    func configureAlertAction(with speedRate: SpeedRate) -> UIAlertAction {
        return UIAlertAction(title: speedRate.title, style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.currentSpeed = speedRate
            self.delegate?.player(self, didChangePlayBackRate: speedRate)
            if self.isPlaying == true {
                self.player?.rate = speedRate.value
                self.autoDisappearControlView()
            }
        }
    }
}

extension PlayerView: PlayerControlViewDelegate {
    func controlView(_ controlView: PlayerControlView, didButtonTapped button: UIButton) {
        if let type = ButtonType(rawValue: button.tag) {
            switch type {
            case .pausePlay:
                if isPlaying {
                    player?.pause()
                    delegate?.player(self, isPlayerPlaying: false)
                } else {
                    player?.rate = self.currentSpeed.value
                    delegate?.player(self, isPlayerPlaying: true)
                    autoDisappearControlView()
                }
                
            case .backward:
                if let currentTime = player?.currentTime() {
                    var newTime = CMTimeGetSeconds(currentTime) - 10.0
                    if newTime <= 0 {
                        newTime = 0
                    }
                    
                    player?.seek(to: CMTime(value: CMTimeValue(newTime * 1000), timescale: 1000))
                }
                
            case .forward:
                if let currentTime = player?.currentTime(),
                   let duration = player?.currentItem?.duration {
                    var newTime = CMTimeGetSeconds(currentTime) + 10.0
                    let durationSeconds = CMTimeGetSeconds(duration)
                    if newTime >= durationSeconds {
                        newTime = durationSeconds
                    }
                    
                    player?.seek(to: CMTime(value: CMTimeValue(newTime * 1000), timescale: 1000))
                }
                
            case .back:
                if let vc = self.parentViewController as? PlayerVC {
                    vc.navigationController?.popViewController(animated: true)
                }
                
            case .fullScreen:
                if isFullScreen {
                    // portrait 전환
                    UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                } else {
                    // landscape 전환
                    UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
                }
                
            case .speed:
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
                
            case .replay:
                isPlayToTheEnd = false
//                playerState = .beginToPlay
                
                player?.seek(to: CMTime.zero)
                player?.play()
                
            case .menu:
                let menuView = MenuView()
                menuView.modalPresentationStyle = .custom
                
                if let vc = self.parentViewController as? PlayerVC {
                    menuView.transitioningDelegate = vc
                    vc.present(menuView, animated: true)
                }
            }
        }
    }
    
    func controlView(_ controlView: PlayerControlView, slider: UISlider, onSliderEvent event: UIControl.Event) {
        if event == .valueChanged {
            if let duration = player?.currentItem?.duration {
                let totalSeconds = CMTimeGetSeconds(duration)
                let value = Float64(slider.value) * totalSeconds
                let seekTime = CMTime(value: Int64(value), timescale: 1)
                
                player?.seek(to: seekTime, completionHandler: { _ in })
            }
        }
    }
}
