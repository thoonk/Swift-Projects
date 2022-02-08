//
//  PlayerVC.swift
//  VideoPlayerTest
//
//  Created by thoonk on 2021/12/30.
//

import UIKit
import AVKit
import SnapKit

final class PlayerVC: UIViewController {
    // MARK: - Properties
    var pipController: AVPictureInPictureController?
    var playerView: PlayerView?
    
    let timeLines: [TimeLine] = [
        TimeLine(title: "시작", timeStamp: 0),
        TimeLine(title: "토끼가 나무를 봄", timeStamp: 90),
        TimeLine(title: "전쟁의 시작", timeStamp: 165),
        TimeLine(title: "토끼의 위기", timeStamp: 202),
        TimeLine(title: "쿠쿠", timeStamp: 400),
        TimeLine(title: "끝", timeStamp: 596)
    ]
    
    lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = 120
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(PlayerTimeLineCell.self, forCellReuseIdentifier: PlayerTimeLineCell.identifier)
        return tableView
    }()
    
    var statusBarStyle: UIStatusBarStyle = .default {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
    // MARK: - init
    init(_ urlString: String) {
        super.init(nibName: nil, bundle: nil)
        
        playerView = PlayerView(urlString)
        setupLayout()

        DispatchQueue.main.async { [weak self] in
            self?.setupPIP()
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationController?.navigationBar.tintColor = .white
        
        switch traitCollection.userInterfaceStyle {
        case .light, .unspecified:
            self.statusBarStyle = .darkContent
        case .dark:
            self.statusBarStyle = .lightContent
        @unknown default:
            fatalError()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        navigationController?.navigationBar.tintColor = .label
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {

        setupLayout()
    }
    
    deinit {
        debugPrint("#PlayerVC Deinit")
    }
}

// MARK: - Private Methods
private extension PlayerVC {
    func setupLayout() {
        guard let videoPlayerView = playerView else {
            return
        }
        
        [videoPlayerView, tableView]
            .forEach { view.addSubview($0) }
        
        if UIDevice.current.orientation.isLandscape {
            view.backgroundColor = .black
            
            tableView.snp.removeConstraints()
            tableView.removeFromSuperview()
            
            videoPlayerView.snp.remakeConstraints {
                $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
                $0.top.bottom.equalToSuperview()
            }
        } else {
            view.backgroundColor = .systemBackground
            videoPlayerView.snp.remakeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.top.equalTo(view.safeAreaLayoutGuide)
                $0.height.equalTo(videoPlayerView.snp.width).multipliedBy(9.0 / 16.0).priority(750)
            }
            
            tableView.snp.makeConstraints {
                $0.top.equalTo(videoPlayerView.snp.bottom).offset(10)
                $0.leading.trailing.bottom.equalToSuperview()
            }
        }
    }
    
    func setupPIP() {
        if let playerLayer = playerView?.playerLayer,
           AVPictureInPictureController.isPictureInPictureSupported() {
            pipController = AVPictureInPictureController(playerLayer: playerLayer)
        } else {
            print("PIP isn't supproted by the current device.")
        }
    }
}

// MARK: - UITableViewDataSource
extension PlayerVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        timeLines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlayerTimeLineCell.identifier, for: indexPath) as? PlayerTimeLineCell
        else { return UITableViewCell() }
        
        cell.configure(with: self.timeLines[indexPath.row])
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension PlayerVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let seekTime = CMTime(value: CMTimeValue(self.timeLines[indexPath.row].timeStamp), timescale: 1)
        self.playerView?.player?.seek(to: seekTime)
    }
}

extension PlayerVC: AVPictureInPictureControllerDelegate {
    func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("PIP will start")
    }
    
    func pictureInPictureControllerDidStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("PIP did started")
    }
    
    func pictureInPictureControllerWillStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("PIP will stop")
        
    }
    
    func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("PIP did stopped")
    }
    
    func pictureInPictureController(
        _ pictureInPictureController: AVPictureInPictureController,
        failedToStartPictureInPictureWithError error: Error
    ) {
        
        print("PIP did failed")
    }
}

extension PlayerVC: UIViewControllerTransitioningDelegate {
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}
