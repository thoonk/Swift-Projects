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
    var player: AVPlayer?
    var pipController: AVPictureInPictureController?
    var playerView: PlayerView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerView = PlayerView(frame: CGRect.zero)
        if let videoPlayerView = playerView {
            view.addSubview(videoPlayerView)
            
            setupPlayerOrientation()
        }

        DispatchQueue.main.async { [weak self] in
            self?.setupPIP()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationController?.navigationBar.tintColor = .white
//        UIApplication.shared.statusBarUIView?.backgroundColor = .black
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
        guard let videoPlayerView = playerView else {
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
                $0.top.equalTo(view.safeAreaLayoutGuide)
                $0.height.equalTo(videoPlayerView.snp.width).multipliedBy(9.0/16.0).priority(750)
            }
        }
    }
    
    func setupPIP() {
        if let playerLayer = playerView?.playerLayer,
           AVPictureInPictureController.isPictureInPictureSupported() {
            pipController = AVPictureInPictureController(playerLayer: playerLayer)
            pipController?.delegate = self
        } else {
            print("PIP isn't supproted by the current device.")
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

extension UIApplication {
var statusBarUIView: UIView? {

    if #available(iOS 13.0, *) {
        let tag = 3848245

        let keyWindow = UIApplication.shared.connectedScenes
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows.first

        if let statusBar = keyWindow?.viewWithTag(tag) {
            return statusBar
        } else {
            let height = keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? .zero
            let statusBarView = UIView(frame: height)
            statusBarView.tag = tag
            statusBarView.layer.zPosition = 999999

            keyWindow?.addSubview(statusBarView)
            return statusBarView
        }

    } else {

        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
    }
    return nil
  }
}
