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
            let playerVC = PlayerVC()
            navigationController?.pushViewController(playerVC, animated: true)
        case 1:
            let bmPlayerVC = BMPlayerVC()
            navigationController?.pushViewController(bmPlayerVC, animated: true)
        default:
            print("??")
        }
    }
}
