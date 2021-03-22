//
//  ViewController.swift
//  CustomAlertViewTest
//
//  Created by 김태훈 on 2021/03/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var alertButton: UIButton!
    
    let alertManager = AlertManager()

    @IBAction func alertButtonTapped(_ sender: UIButton) {
        
        let alertVC = alertManager.alert(title: "커스텀 알림 화면", subTitle: "이 화면은 커스텀 알림 화면 테스트입니다!", actionBtnTitle: "확인") {
            print("확인 선택후 필요한 것을 설정하면 됩니다!")
        }
        present(alertVC, animated: true)
    }
}
