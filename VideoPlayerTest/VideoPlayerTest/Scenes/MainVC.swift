//
//  MainVC.swift
//  VideoPlayerTest
//
//  Created by MA2103 on 2021/12/30.
//

import UIKit

final class MainVC: UITableViewController {
    var videos = [VideoModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getVideoInfo()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        videos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = videos[indexPath.row].title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if NetworkMonitor.shared.isConnected {
            if NetworkMonitor.shared.connectionType == .cellular {
                self.setupConfirmView(with: "Wifi가 연결이 되어 있지 않아 셀룰러 데이터를 사용합니다.") { [weak self] _ in
                    let playerVC = PlayerVC(self?.videos[indexPath.row].sources.first ?? "")
                    self?.navigationController?.pushViewController(playerVC, animated: true)
                }
            } else {
                let playerVC = PlayerVC(self.videos[indexPath.row].sources.first ?? "")
                self.navigationController?.pushViewController(playerVC, animated: true)
            }
        } else {
            self.setupAlertView(with: "네트워크에 연결해주세요.")
        }
    }
}

private extension MainVC {
    func getVideoInfo() {
        guard let path = Bundle.main.path(forResource: "videoInfo", ofType: "json") else { return }
        
        guard let jsonString = try? String(contentsOfFile: path) else { return }
        
        let data = jsonString.data(using: .utf8)
        if let data = data,
           let videos = try? JSONDecoder().decode([VideoModel].self, from: data) {
            self.videos = videos
        }
        
        self.tableView.reloadData()
    }
    
    func setupAlertView(with msg: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: "알림", message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: handler)
        
        alertController.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
    
    func setupConfirmView(with msg: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: "알림", message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: handler)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
}
