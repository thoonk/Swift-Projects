//
//  TabBarController.swift
//  Outstagram
//
//  Created by MA2103 on 2021/12/15.
//

import UIKit
import SnapKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let feedVC = UINavigationController(rootViewController: FeedViewController())
        feedVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        profileVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))

        viewControllers = [feedVC, profileVC]
    }
}
