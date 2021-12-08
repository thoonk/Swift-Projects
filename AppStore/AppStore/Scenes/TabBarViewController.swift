//
//  TabBarViewController.swift
//  AppStore
//
//  Created by MA2103 on 2021/12/08.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    private lazy var todayViewController: UIViewController = {
        let vc = TodayViewController()
        let tabBarItem = UITabBarItem(
            title: "투데이",
            image: UIImage(systemName: "mail"),
            tag: 0
        )
        vc.tabBarItem = tabBarItem
        
        return vc
    }()
    
    private lazy var appViewController: UIViewController = {
        // NavigationController Embedded
        let vc = UINavigationController(rootViewController: AppViewController())
        let tabBarItem = UITabBarItem(
            title: "앱",
            image: UIImage(systemName: "square.stack.3d.up"),
            tag: 1
        )
        vc.tabBarItem = tabBarItem
        
        return vc
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [todayViewController, appViewController]
    }
}

