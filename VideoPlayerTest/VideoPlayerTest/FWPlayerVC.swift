//
//  FWPlayerVC.swift
//  VideoPlayerTest
//
//  Created by MA2103 on 2021/12/30.
//

import UIKit
import SnapKit
import AVFoundation
import FWPlayerCore

final class FWPlayerVC: UIViewController {
    private let kVideoCover = "https://github.com/FoksWang/FWPlayer/blob/master/Example/FWPlayer/Images.xcassets/Common/cover_image_placeholder.imageset/cover_image_placeholder.jpg?raw=true"
    private var player: FWPlayerController?
    private lazy var containerView: UIImageView = {
        let imageView = UIImageView()
        let color = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1)
        let placeholderImage = FWUtilities.image(with: color, size: CGSize(width: 1, height: 1))
        imageView.setImageWithURLString(kVideoCover, placeholder: placeholderImage)
        return imageView
    }()
    
    private lazy var controlView: FWPlayerControlView = {
        let view = FWPlayerControlView()
        view.fastViewAnimated = true
        view.autoHiddenTimeInterval = 5.0
        view.autoFadeTimeInterval = 0.5
        view.prepareShowLoading = true
        view.prepareShowControlView = true
        return view
    }()
    
    private lazy var playButton: UIButton = {
        var button = UIButton(type: .custom)
        button.setImage(FWUtilities.imageNamed("FWPlayer_all_play"), for: .normal)
        button.addTarget(self, action: #selector(playButtonClick), for: .touchUpInside)
        return button
    }()
    
    @objc private func playButtonClick() {
        print("playButtonClick")
        self.player!.playTheIndex(assetIndex)
        self.controlView.showTitle("Video title 1", coverURLString: kVideoCover, fullScreenMode: .automatic)
    }
    
    private var assetIndex = 0
    private lazy var assetURLs: Array<URL> = {
        var assetList = [
            URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!,
            URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4")!,
            URL(string: "http://commondatastorage.googleapis.com/wvmedia/sintel_main_720p_4br_tp.wvm")!
        ]
        return assetList
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.containerView)
        self.containerView.addSubview(self.playButton)
        
        let playerManager = FWAVPlayerManager()
        // Playback speed,0.5...2
        playerManager.rate = 1.0
        
        // Enable media cache for assets
        playerManager.isEnableMediaCache = true
        
        // Setup player
        self.player = FWPlayerController(playerManager: playerManager, containerView: self.containerView)
        self.player!.controlView = self.controlView
        // Setup continue playing in the background
        self.player!.pauseWhenAppResignActive = true
        
        self.player!.orientationWillChange = { [weak self] (player, isFullScreen) in
            guard let self = self else { return }
            self.setNeedsStatusBarAppearanceUpdate()
        }
        //        playerManager.isMuted = true
        
        // Finished playing
        self.player!.playerDidToEnd = { [weak self] (asset) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.player!.currentPlayerManager.replay!()
            strongSelf.player!.playTheNext()
            if strongSelf.player!.isLastAssetURL == false {
                strongSelf.controlView.showTitle("Video Title", coverURLString: strongSelf.kVideoCover, fullScreenMode: .landscape)
            } else {
                strongSelf.player!.stop()
            }
        }
        self.player!.assetURLs = self.assetURLs
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.player?.isViewControllerDisappear = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.player?.isViewControllerDisappear = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        var w: CGFloat = UIScreen.main.bounds.size.width
        var h = w * 9 / 16
        var x: CGFloat = 0
        var y: CGFloat = (UIScreen.main.bounds.size.height - h) / CGFloat(2.0)
        self.containerView.frame = CGRect(x: x, y: y, width: w, height: h)
        
        w = 44
        h = w
        x = (self.containerView.frame.width - w) / 2
        y = (self.containerView.frame.height - h) / 2
        self.playButton.frame = CGRect(x: x, y: y, width: w, height: h)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if self.player != nil && self.player!.isFullScreen {
            return .lightContent
        } else {
            return .default
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        // Support only iOS 9 and later, so return false.
        return false
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var shouldAutorotate: Bool {
        return self.player?.shouldAutorotate ?? false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if self.player != nil && self.player!.isFullScreen {
            return .landscape
        }
        return .portrait
    }
}
