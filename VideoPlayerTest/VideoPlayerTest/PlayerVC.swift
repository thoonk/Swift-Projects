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
    var pictureInPictureController: AVPictureInPictureController?
    var pipButton = UIButton()
    var videoPlayerView: VideoPlayerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoPlayerView = VideoPlayerView(frame: CGRect.zero)
        if let videoPlayerView = videoPlayerView {
            view.addSubview(videoPlayerView)
            
            setupPlayerOrientation()
        }
        
        if AVPictureInPictureController.isPictureInPictureSupported() {
            pictureInPictureController = AVPictureInPictureController(playerLayer: playerLayer)
            pictureInPictureController?.delegate = self
        } else {
            print("PIP isn't supproted by the current device.")
        }
        
        setupPIPButton()
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
//    @objc func handleTapGestureRecognizer(_ gestureRecognizer: UITapGestureRecognizer) {
//        switch self.player.playbackState {
//        case .stopped:
//            self.player.playFromBeginning()
//            break
//        case .paused:
//            self.player.playFromCurrentTime()
//            break
//        case .playing:
//            self.player.pause()
//            break
//        case .failed:
//            self.player.pause()
//            break
//        }
//    }
    
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
    
    func setupPIPButton() {
        let startImage = AVPictureInPictureController.pictureInPictureButtonStartImage
        
        pipButton = UIButton(type: .system)
        pipButton.setImage(startImage, for: .normal)
        pipButton.frame = CGRect(x: 24, y: 48, width: 40, height: 40)
        pipButton.addTarget(self, action: #selector(pipButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc func pipButtonTapped(_ sender: UIButton) {
        guard let isActive = pictureInPictureController?.isPictureInPictureActive else { return }
        
        if isActive {
            pictureInPictureController?.stopPictureInPicture()
            
            let startImage = AVPictureInPictureController.pictureInPictureButtonStartImage
            pipButton.setImage(startImage, for: .normal)
        } else {
            pictureInPictureController?.startPictureInPicture()
            
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

//extension PlayerVC: PlayerPlaybackDelegate {
//    func playerCurrentTimeDidChange(_ player: Player) {
////        let fraction = Double(player.currentTimeInterval) / Double(player.maximumDuration)
//
//    }
//
//    func playerPlaybackWillStartFromBeginning(_ player: Player) {
//
//    }
//
//    func playerPlaybackDidEnd(_ player: Player) {
//
//    }
//
//    func playerPlaybackWillLoop(_ player: Player) {
//
//    }
//
//    func playerPlaybackDidLoop(_ player: Player) {
//
//    }
//}
