//
//  ViewController.swift
//  WalkthroughTest
//
//  Created by 김태훈 on 2021/01/06.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func startBtnTapped(_ sender: UIButton) {
        
        UserDefaults.standard.set(true, forKey: "check")
        performSegue(withIdentifier: "toMain", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

