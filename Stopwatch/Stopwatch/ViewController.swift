//
//  ViewController.swift
//  Stopwatch
//
//  Created by 김태훈 on 2020/10/19.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Property
    private let mainStopwatch: Stopwatch = Stopwatch()
    private let lapStopwatch: Stopwatch = Stopwatch()
    private var isPlay: Bool = false
    private var laps: [String] = []
    
    //MARK: - UI Components
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var lapResetBtn: UIButton!
    @IBOutlet weak var startStopBtn: UIButton!
    @IBOutlet weak var lapsTableView: UITableView!

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 시작 전 랩 버튼 비활성화
        lapResetBtn.isEnabled = false
    }
    
    //MARK: - Button Action Methods
    /// 시작/중단 버튼 누를 경우 액션 메서드
    @IBAction func playPauseAction(_ sender: AnyObject){
        // 랩 버튼 활성화
        lapResetBtn.isEnabled = true
        changeBtnStatus(lapResetBtn, title: "Lap", titleColor: UIColor.black)
        
        if !isPlay {
            unowned let weakSelf = self
            mainStopwatch.timer = Timer.scheduledTimer(timeInterval: 0.035, target: weakSelf, selector: <#T##Selector#>, userInfo: nil, repeats: true)
            lapStopwatch.timer = Timer.scheduledTimer(timeInterval: 0.035, target: weakSelf, selector: <#T##Selector#>, userInfo: nil, repeats: true)
            
            RunLoop.current.add(mainStopwatch.timer, forMode: RunLoop.Mode.common)
            RunLoop.current.add(lapStopwatch.timer, forMode: RunLoop.Mode.common)
            
            isPlay = true
            changeBtnStatus(startStopBtn, title: "Stop", titleColor: UIColor.red)
        } else {
            mainStopwatch.timer.invalidate()
            lapStopwatch.timer.invalidate()
            isPlay = false
            changeBtnStatus(startStopBtn, title: "Start", titleColor: UIColor.green)
            changeBtnStatus(lapResetBtn, title: "Reset", titleColor: UIColor.black)
        }
    }
    
    /// 랩/재설정 버튼 누를 경우 액션 메서드
    @IBAction func lapResetAction(_ sender: AnyObject){
        // 타이머 중단 누른 상태 & 재설정 버튼
        if !isPlay {
            resetMainTimer()
            resetLapTimer()
            changeBtnStatus(lapResetBtn, title: "Lap", titleColor: UIColor.lightGray)
            lapResetBtn.isEnabled = false;
            
        // 타이머 시작 누른 상태 & 랩 버튼
        } else {
            if let timerText = timerLabel.text {
                laps.append(timerText)
            }
            lapsTableView.reloadData()
            
        }
    }
    
    //MARK: - Custom Methods
    /// 버튼 상태 변경
    private func changeBtnStatus(_ button: UIButton, title: String, titleColor: UIColor){
        button.setTitle(title, for: UIControl.State())
        button.setTitleColor(titleColor, for: UIControl.State())
    }
    /// 메인 스탑워치 타이머 리셋
    private func resetMainTimer(){
        resetTimer(mainStopwatch)
        timerLabel.text = "00:00.00"
    }
    /// 랩 스탑워치 타이머 리셋
    private func resetLapTimer() {
        resetTimer(lapStopwatch)
        laps.removeAll()
        lapsTableView.reloadData()
    }
    /// 스탑워치 타이머 리셋
    private func resetTimer(_ stopwatch: Stopwatch){
        stopwatch.timer.invalidate()
        stopwatch.counter = 0.0
    }
}

