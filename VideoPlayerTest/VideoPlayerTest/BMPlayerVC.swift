//
//  BMPlayerVC.swift
//  VideoPlayerTest
//
//  Created by MA2103 on 2021/12/07.
//

import UIKit
import AVKit
import AVFoundation
import BMPlayer

class BMPlayerVC: UIViewController {

    let videoURLString =  "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        BMPlayerConf.shouldAutoPlay = false
        BMPlayerConf.enablePlaytimeGestures = false
        let player = BMPlayer()
        
        view.addSubview(player)
        
        player.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(player.snp.width).multipliedBy(9.0/16.0).priority(750)
        }
        
        player.backBlock = { [unowned self] isFullScreen in
            if isFullScreen == true { return }
            self.navigationController?.popViewController(animated: true)
        }
        
        let asset = BMPlayerResource(url: URL(string: self.videoURLString)!, name: "What")
        player.setVideo(resource: asset)
    }
    
//    @IBAction func playBtnTapped(_ sender: UIButton) {
//        guard let videoURL = URL(string: self.videoURLString) else { return }
//        let player = AVPlayer(url: videoURL)
//        let playerVC = AVPlayerViewController()
//        playerVC.player = player
//
//        self.present(playerVC, animated: true) {
//            playerVC.player?.play()
//        }
//    }
    
}

extension BMPlayerVC: BMPlayerDelegate {
    func bmPlayer(player: BMPlayer, playerIsPlaying playing: Bool) {
        print("| BMPlayerDelegate | playerIsPlaying | playing - \(playing)")
    }
    
    func bmPlayer(player: BMPlayer, playerOrientChanged isFullscreen: Bool) {
        player.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            if isFullscreen {
                $0.bottom.equalTo(view.safeAreaLayoutGuide)
            } else {
                $0.height.equalTo(view.snp.width).multipliedBy(9.0/16.0).priority(500)
            }
        }
    }
    
    func bmPlayer(player: BMPlayer, playerStateDidChange state: BMPlayerState) {
        print("| BMPlayerDelegate | playerStateDidChange | state - \(state)")
    }
    
    func bmPlayer(player: BMPlayer, loadedTimeDidChange loadedDuration: TimeInterval, totalDuration: TimeInterval) {
        //        print("| BMPlayerDelegate | loadedTimeDidChange | \(loadedDuration) of \(totalDuration)")

    }
    
    func bmPlayer(player: BMPlayer, playTimeDidChange currentTime: TimeInterval, totalTime: TimeInterval) {
        //        print("| BMPlayerDelegate | playTimeDidChange | \(currentTime) of \(totalTime)")
    }
}
