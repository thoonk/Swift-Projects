//
//  MainVC.swift
//  VideoPlayerTest
//
//  Created by MA2103 on 2021/12/30.
//

import UIKit

final class MainVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Player"
        case 1:
            cell.textLabel?.text = "BMPlayer"
        default:
            cell.textLabel?.text = ""
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            if NetworkMonitor.shared.isConnected {
                if NetworkMonitor.shared.connectionType == .cellular {
                    self.setupConfirmView(with: "Wifi가 연결이 되어 있지 않아 셀룰러 데이터를 사용합니다.") { [weak self] _ in
                        let playerVC = PlayerVC()
                        self?.navigationController?.pushViewController(playerVC, animated: true)
                    }
                }
            } else {
                self.setupAlertView(with: "네트워크에 연결해주세요.")
            }
            
        case 1:
            let bmPlayerVC = BMPlayerVC()
            navigationController?.pushViewController(bmPlayerVC, animated: true)
            
        default:
            print("??")
        }
    }
}

private extension MainVC {
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
