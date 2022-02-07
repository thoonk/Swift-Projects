//
//  PlayerControlView.swift
//  VideoPlayerTest
//
//  Created by thoonk on 2022/01/03.
//

import UIKit
import CoreMedia

protocol PlayerControlViewDelegate: AnyObject {
    func controlView(_ controlView: PlayerControlView, didButtonTapped button: UIButton)
    func controlView(_ controlView: PlayerControlView, slider: UISlider, onSliderEvent event: UIControl.Event)
    func controlView(_ controlView: PlayerControlView, seekTo time: CMTime)
}

enum ButtonType: Int {
    case pausePlay = 100
    case backward = 101
    case forward = 102
    case back = 103
    case fullScreen = 104
    case speed = 105
    case replay = 106
    case menu = 107
    case lock = 108
}

final class PlayerControlView: UIView {
    // MARK: - Properties
    weak var playerView: PlayerView? {
        didSet {
            if playerView != nil {
                playerView?.delegate = self
            }
        }
    }
    weak var delegate: PlayerControlViewDelegate?
    
    var timeLineWindow: UIWindow?
    
    var isFullScreen: Bool {
        get {
            guard let interfaceOrientation =  UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.windowScene?.interfaceOrientation else { return false }
            return interfaceOrientation.isLandscape
        }
    }
    
    var isSubtitleVisible = false
    
    var subtitles: Subtitles?
    
    // MARK: - UI Components
    lazy var containerView: UIView = {
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
        button.tag = ButtonType.pausePlay.rawValue

        button.addTarget(self, action: #selector(handleButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var backwardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(systemName: "gobackward.10", size: 30)
        button.tintColor = .white
        button.isHidden = true
        button.contentMode = .scaleToFill
        button.tag = ButtonType.backward.rawValue

        button.addTarget(self, action: #selector(handleButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var forwardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(systemName: "goforward.10", size: 30)
        button.tintColor = .white
        button.isHidden = true
        button.contentMode = .scaleToFill
        button.tag = ButtonType.forward.rawValue

        button.addTarget(self, action: #selector(handleButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(systemName: "chevron.backward", size: 20)
        button.tintColor = .white
        button.tag = ButtonType.back.rawValue
        button.addTarget(self, action: #selector(handleButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }()

    lazy var fullScreenButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(systemName: "arrow.up.left.an d.arrow.down.right", size: 20)
        button.tintColor = .white
        button.backgroundColor = .clear
        button.tag = ButtonType.fullScreen.rawValue
        button.addTarget(self, action: #selector(handleButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var speedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("1.0x", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.tag = ButtonType.speed.rawValue
        button.addTarget(self, action: #selector(handleButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var subtitleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "subtitles"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleSubtitle), for: .touchUpInside)
        
        return button
    }()
    
    lazy var replayButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "replay"), for: .normal)
        button.tintColor = .white
        button.tag = ButtonType.replay.rawValue
        button.addTarget(self, action: #selector(handleButtonTapped(_:)), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    lazy var menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(systemName: "applelogo", size: 18)
        button.tintColor = .white
        button.tag = ButtonType.menu.rawValue
        button.addTarget(self, action: #selector(handleButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var lockButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(systemName: "lock.open.fill", size: 18)
        button.tintColor = .white
        button.tag = ButtonType.lock.rawValue
        button.addTarget(self, action: #selector(handleButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

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
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    lazy var subtitleBackView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 2
        view.backgroundColor = .black.withAlphaComponent(0.4)
        view.addSubview(subtitleLabel)
        view.isHidden = true
        return view
    }()
    
    lazy var timeLineLabel: UILabel = {
        let label = UILabel()
        label.text = "타임라인 보기 ⬆"
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 13)
        label.sizeToFit()
        label.isHidden = true
        return label
    }()
    
//    lazy var timeLineView: TimeLineView = {
//        let view = TimeLineView(frame: UIScreen.main.bounds)
//        view.backgroundColor = .clear
//        view.delegate = self
//        return view
//    }()
    
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
        delegate?.controlView(self, slider: videoSlider, onSliderEvent: .valueChanged)
    }
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.subtitles = Subtitles()
        
        setupLayout()
        setupOrientationObserver()
        setupSwipeGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
        
        delegate = nil
    }
}

// MARK: - PlayerDelegate
extension PlayerControlView: PlayerDelegate {
//    func player(_ playerView: PlayerView, didPlayerStarted state: PlayerState) {
//        switch state {
//
//        default:
//            //
//            break
//        }
//    }
    
    /// 영상 로딩 완료 후 처리
    func player(_ playerView: PlayerView, didLoadedTimeChanged duration: TimeInterval) {
        activityIndicatorView.stopAnimating()
        [pausePlayButton, backwardButton, forwardButton]
            .forEach { $0.isHidden = false }
        
        guard !(duration.isNaN || duration.isInfinite) else { return }
        
        let secondsText = Int(duration.truncatingRemainder(dividingBy: 60))
        let minutesText = String(format: "%02d", Int(duration) / 60)
        videoLengthLabel.text = "\(minutesText):\(secondsText)"
    }
    
    /// Player 시간 흐름에 따른 뷰 업데이트
    func player(_ playerView: PlayerView, didPlayTimeChanged currentTime: TimeInterval, totalTime: TimeInterval) {
        guard !(totalTime.isNaN || totalTime.isInfinite) else {
            return
        }
        self.currentTimeLabel.text = formatTime(Int(currentTime))
        self.videoLengthLabel.text = formatTime(Int(totalTime))
        self.videoSlider.value = Float(currentTime / totalTime)

        if let subtitles = subtitles,
            isSubtitleVisible == true
        {
            if let line = subtitles.search(for: currentTime) {
                subtitleBackView.isHidden = false
                subtitleLabel.text = line.text
            } else {
                subtitleBackView.isHidden = true
            }
        } else {
            subtitleBackView.isHidden = true
        }
        
        var isPlayToTheEnd = false
        
        // PlayToTheEnd
        if currentTime >= totalTime {
            isPlayToTheEnd = true
        }
        
        replayButton.isHidden = !isPlayToTheEnd
        [pausePlayButton, backwardButton, forwardButton]
            .forEach { $0.isHidden = isPlayToTheEnd }
    }
    
    func player(_ playerView: PlayerView, isPlayerPlaying isPlaying: Bool) {
        if isPlaying {
            self.pausePlayButton.setImage(systemName: "pause", size: 30)
        } else {
            self.pausePlayButton.setImage(systemName: "play", size: 30)
        }
    }
    
    func player(_ playerView: PlayerView, didChangePlayBackRate rate: SpeedRate) {
        speedButton.setTitle(rate.title, for: .normal)
    }
    
    func player(_ playerView: PlayerView, didLockScreen isLockScreen: Bool) {
        if isLockScreen {
            self.lockButton.setImage(systemName: "lock.fill", size: 18)
        } else {
            self.lockButton.setImage(systemName: "lock.open.fill", size: 18)
        }
        
        [
         backwardButton,
         pausePlayButton,
         forwardButton,
         videoSlider,
         fullScreenButton,
         speedButton,
         menuButton,
         backButton,
         subtitleButton,
        ]
            .forEach { $0.isUserInteractionEnabled = !isLockScreen }
    }
}

// MARK: - Private Methods
private extension PlayerControlView {
    func setupLayout() {
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
            replayButton,
            subtitleButton,
            lockButton,
            timeLineLabel
        ]
            .forEach { containerView.addSubview($0) }
        
        [
            containerView,
            subtitleBackView
        ]
            .forEach { self.addSubview($0) }
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
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
            $0.bottom.equalToSuperview().inset(5)
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
            $0.width.height.equalTo(30)
        }
        
        subtitleButton.snp.makeConstraints {
            $0.top.equalTo(menuButton)
            $0.trailing.equalTo(speedButton.snp.leading).offset(-10)
            $0.width.height.equalTo(30)
        }
        
        lockButton.snp.makeConstraints {
            $0.top.equalTo(menuButton)
            $0.trailing.equalTo(subtitleButton.snp.leading).offset(-10)
            $0.width.height.equalTo(30)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(5)
        }
        
        subtitleBackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(5)
            $0.centerX.equalToSuperview()
            $0.width.greaterThanOrEqualTo(10)
        }
    }
    
    @objc func handleButtonTapped(_ button: UIButton) {
        delegate?.controlView(self, didButtonTapped: button)
    }
    
    @objc func handleSubtitle() {
        self.isSubtitleVisible = !isSubtitleVisible
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
            
            timeLineLabel.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview().inset(30)
                $0.top.equalTo(videoSlider.snp.bottom)
                $0.bottom.equalToSuperview()
            }
            timeLineLabel.isHidden = false
        } else {
            // portrait 전환
            fullScreenButton.setImage(systemName: "arrow.up.left.and.arrow.down.right", size: 15)

            videoSlider.snp.remakeConstraints {
                $0.leading.trailing.equalToSuperview().inset(5)
                $0.bottom.equalToSuperview()
                $0.height.equalTo(30)
            }
            
            timeLineLabel.snp.removeConstraints()
            timeLineLabel.isHidden = true
            
            didCloseButtonTapped()
        }
    }
    
    func setupSwipeGesture() {
        let swipeGesutre = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureAction))
        swipeGesutre.direction = .up
        self.addGestureRecognizer(swipeGesutre)
    }
    
    @objc
    func swipeGestureAction() {
        // timeLine Mask View
        
        if isFullScreen {
            setupTimeLineWindow()
        }
    }
    
    func setupTimeLineWindow() {
        
//        containerView.addSubview(timeLineView)
//
//        timeLineView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
        didCloseButtonTapped()
        print(UIScreen.main.bounds)
        let screenSize = UIScreen.main.bounds
        let widthToUse: CGFloat = (screenSize.width > screenSize.height) ? screenSize.width : screenSize.height
        let heightToUse: CGFloat = (widthToUse == screenSize.width) ? screenSize.height : screenSize.width

        let frame = CGRect(x: 0, y: 0, width: widthToUse, height: heightToUse)
        var timeLineWindow = UIWindow(frame: frame)
        let windowScene = UIApplication.shared.connectedScenes.first {
            $0.activationState == .foregroundActive
        }

        if let windowScene = windowScene as? UIWindowScene {
            timeLineWindow = UIWindow(windowScene: windowScene)
        }

        timeLineWindow.frame = frame
        timeLineWindow.backgroundColor = .clear
        timeLineWindow.windowLevel = UIWindow.Level.statusBar + 1


        let newTransform = CGAffineTransform(rotationAngle: -Double.pi / 2)

        timeLineWindow.transform = newTransform

        timeLineWindow.frame.origin.x = 0
        timeLineWindow.frame.origin.y = 0

        let timeLineView = TimeLineView(frame: frame)
        timeLineView.delegate = self

        timeLineWindow.addSubview(timeLineView)
        timeLineView.snp.makeConstraints {
            $0.edges.equalToSuperview()
//            $0.centerX.centerY.equalToSuperview()
        }


        self.timeLineWindow = timeLineWindow
        self.timeLineWindow?.makeKeyAndVisible()
    }
}

extension PlayerControlView: TimeLineViewDelegate {
    func didTimeLineTapped(with value: CMTime) {
        delegate?.controlView(self, seekTo: value)
        didCloseButtonTapped()
    }
    
    func didCloseButtonTapped() {
//        self.timeLineView.removeFromSuperview()
        self.timeLineWindow?.removeFromSuperview()
        self.timeLineWindow = nil
    }
}
