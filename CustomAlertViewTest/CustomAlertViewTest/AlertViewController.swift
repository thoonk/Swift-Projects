//
//  AlertViewController.swift
//  CustomAlertViewTest
//
//  Created by 김태훈 on 2021/03/22.
//

import UIKit

class AlertViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    var alertTitle = ""
    var alertSubTitle = ""
    var actionBtnTitle = ""
    var afterBtnAction: (() -> Void)?
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        afterBtnAction?()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    func setUI() {
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        
        titleLabel.text = alertTitle
        subTitleLabel.text = alertSubTitle
        actionButton.setTitle(actionBtnTitle, for: .normal)
    }
}
