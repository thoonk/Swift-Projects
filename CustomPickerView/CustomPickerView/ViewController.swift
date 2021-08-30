//
//  ViewController.swift
//  CustomPickerView
//
//  Created by 김태훈 on 2021/08/30.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var hourTextView: UITextView!
    @IBOutlet weak var minTextView: UITextView!
    @IBOutlet weak var secTextView: UITextView!
    @IBOutlet weak var timePickerView: UIPickerView!
    @IBOutlet weak var timePickerStackView: UIStackView!
    
    var hourArr: [String] = Array(1...24).map ({ String($0) })
    var minArr: [String] = Array(1...60).map ({ String($0) })
    var secArr: [String] = Array(1...60).map ({ String($0) })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    @IBAction func doneBtnTapped(_ sender: Any) {
        timePickerView.selectRow(0, inComponent: 0, animated: true)
        setupViewAnim(view: timePickerStackView, hidden: true)
    }
    
    func setupUI() {
        setupTapGesture()
        setupPickerView()
        
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
    }
    
    func setupPickerView() {
        timePickerView.dataSource = self
        timePickerView.delegate = self
    }
    
    func setupTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        containerView.addGestureRecognizer(tap)
    }
    
    func setupViewAnim(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve) {
            view.isHidden = hidden
        }
    }

    @objc
    func handleTap(_ sender: UITapGestureRecognizer) {
        setupViewAnim(view: timePickerStackView, hidden: false)
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return hourArr.count
        case 1:
            return minArr.count
        case 2:
            return secArr.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return hourArr[row]
        case 1:
            return minArr[row]
        case 2:
            return secArr[row]
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let hourTime = "\(hourArr[pickerView.selectedRow(inComponent: 0)]) hour"
        let minTime = "\(minArr[pickerView.selectedRow(inComponent: 1)]) min"
        let secTime = "\(secArr[pickerView.selectedRow(inComponent: 2)])  sec"
        
        hourTextView.text = hourTime
        minTextView.text = minTime
        secTextView.text = secTime
    }
}
