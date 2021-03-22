//
//  AlertManager.swift
//  CustomAlertViewTest
//
//  Created by 김태훈 on 2021/03/22.
//

import UIKit

class AlertManager {
    func alert(title: String, subTitle: String, actionBtnTitle: String, completion: @escaping () -> Void) -> AlertViewController {
        let storyBoard = UIStoryboard(name: "AlertStoryBoard", bundle: .main)
        let alertVC = storyBoard.instantiateViewController(identifier: "AlertVC") as! AlertViewController
        
        alertVC.alertTitle = title
        alertVC.alertSubTitle = subTitle
        alertVC.actionBtnTitle = actionBtnTitle
        alertVC.afterBtnAction = completion
        return alertVC
    }
}
