//
//  PlayerVC.swift
//  VideoPlayerTest
//
//  Created by MA2103 on 2021/12/30.
//

import UIKit
import AVKit
import SnapKit

final class PlayerVC: UIViewController {
//    fileprivate var player = Player()
    var playerLayer: AVPlayerLayer = AVPlayerLayer()
    var player: AVPlayer?
    var pipController: AVPictureInPictureController?
    var pipButton = UIButton()
    var videoPlayerView: VideoPlayerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoPlayerView = VideoPlayerView(frame: CGRect.zero)
        if let videoPlayerView = videoPlayerView {
            view.addSubview(videoPlayerView)
            
            setupPlayerOrientation()
        }
        
        
        setupPIP()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        navigationController?.navigationBar.tintColor = .label
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {

        setupPlayerOrientation()
    }
    
    deinit {
        debugPrint("#PlayerVC Deinit")
    }
}

private extension PlayerVC {
    func setupPlayerOrientation() {
        guard let videoPlayerView = videoPlayerView else {
            return
        }
        
        if UIDevice.current.orientation.isLandscape {
            view.backgroundColor = .black
            videoPlayerView.snp.remakeConstraints {
                $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
                $0.top.bottom.equalToSuperview()
            }
        } else {
            view.backgroundColor = .systemBackground
            videoPlayerView.snp.remakeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.top.equalToSuperview().inset(50)
                $0.height.equalTo(videoPlayerView.snp.width).multipliedBy(9.0/16.0).priority(750)
            }
        }
    }
    
    func setupPIP() {
        if let playerLayer = videoPlayerView?.playerLayer,
           AVPictureInPictureController.isPictureInPictureSupported() {
            pipController = AVPictureInPictureController(playerLayer: playerLayer)
            pipController?.delegate = self
        } else {
            print("PIP isn't supproted by the current device.")
        }
    }
    
    @objc func pipButtonTapped(_ sender: UIButton) {
        guard let isActive = pipController?.isPictureInPictureActive else { return }
        
        if isActive {
            pipController?.stopPictureInPicture()
            
            let startImage = AVPictureInPictureController.pictureInPictureButtonStartImage
            pipButton.setImage(startImage, for: .normal)
        } else {
            pipController?.startPictureInPicture()
            
            let stopImage = AVPictureInPictureController.pictureInPictureButtonStopImage
            pipButton.setImage(stopImage, for: .normal)
        }
    }
}

extension PlayerVC: AVPictureInPictureControllerDelegate {
    func pictureInPictureControllerWillStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("PIP will stop")
        
    }
    
    func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("PIP did stopped")
    }
}
