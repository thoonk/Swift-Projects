//
//  ViewController.swift
//  Stopwatch
//
//  Created by 김태훈 on 2020/10/19.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    
    //MARK: - Property
    fileprivate let mainStopwatch: Stopwatch = Stopwatch()
    fileprivate let lapStopwatch: Stopwatch = Stopwatch()
    fileprivate let cellIdentifier: String = "historyCell"
    fileprivate var isStart: Bool = false
    fileprivate var laps: [String] = []
    
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
    @IBAction func startStopAction(_ sender: AnyObject){
        // 랩 버튼 활성화
        lapResetBtn.isEnabled = true
        changeBtnStatus(lapResetBtn, title: "Lap", titleColor: UIColor.black)
        
        if !isStart {
            unowned let weakSelf = self
            mainStopwatch.timer = Timer.scheduledTimer(timeInterval: 0.035, target: weakSelf, selector: #selector(updateMainTimer), userInfo: nil, repeats: true)
            lapStopwatch.timer = Timer.scheduledTimer(timeInterval: 0.035, target: weakSelf, selector: #selector(updateLapTimer), userInfo: nil, repeats: true)
            
            RunLoop.current.add(mainStopwatch.timer, forMode: RunLoop.Mode.common)
            RunLoop.current.add(lapStopwatch.timer, forMode: RunLoop.Mode.common)
            
            isStart = true
            changeBtnStatus(startStopBtn, title: "Stop", titleColor: UIColor.red)
        } else {
            mainStopwatch.timer.invalidate()
            lapStopwatch.timer.invalidate()
            isStart = false
            changeBtnStatus(startStopBtn, title: "Start", titleColor: UIColor.green)
            changeBtnStatus(lapResetBtn, title: "Reset", titleColor: UIColor.black)
        }
    }
    
    /// 랩/재설정 버튼 누를 경우 액션 메서드
    @IBAction func lapResetAction(_ sender: AnyObject){
        // 재설정 버튼 누를 경우
        if !isStart {
            resetMainTimer()
            resetLapTimer()
            changeBtnStatus(lapResetBtn, title: "Lap", titleColor: UIColor.lightGray)
            lapResetBtn.isEnabled = false;
            
        // 랩 버튼 누를 경우
        } else {
            if let timerText = timerLabel.text {
                laps.append(timerText)
            }
            lapsTableView.reloadData()
            resetLapTimer()
            unowned let weakSelf = self
            lapStopwatch.timer = Timer.scheduledTimer(timeInterval: 0.035, target: weakSelf, selector: #selector(updateLapTimer), userInfo: nil, repeats: true)
            RunLoop.current.add(lapStopwatch.timer, forMode: RunLoop.Mode.common)

        }
    }
    
    //MARK: - Custom Methods
    /// 버튼 상태 변경
    fileprivate func changeBtnStatus(_ button: UIButton, title: String, titleColor: UIColor){
        button.setTitle(title, for: UIControl.State())
        button.setTitleColor(titleColor, for: UIControl.State())
    }
    /// 메인 스탑워치 타이머 리셋
    fileprivate func resetMainTimer(){
        resetTimer(mainStopwatch)
        laps.removeAll()
        lapsTableView.reloadData()
        timerLabel.text = "00:00.00"
    }
    /// 랩 스탑워치 타이머 리셋
    fileprivate func resetLapTimer() {
        resetTimer(lapStopwatch)
    }
    /// 스탑워치 타이머 리셋
    fileprivate func resetTimer(_ stopwatch: Stopwatch){
        stopwatch.timer.invalidate()
        stopwatch.counter = 0.0
    }
    
    /// 스탑워치 타이머 업데이트
    func updateTimer(_ stopwatch: Stopwatch){
        stopwatch.counter = stopwatch.counter + 0.035
        
        var minutes: String = "\((Int)(stopwatch.counter / 60))"
        // 1의 자리의 경우
        if (Int)(stopwatch.counter / 60) < 10 {
            minutes = "0\((Int)(stopwatch.counter / 60))"
        }
        
        var seconds: String = String(format: "%2.f", (stopwatch.counter.truncatingRemainder(dividingBy: 60)))
        // 1의 자리의 경우
        if stopwatch.counter.truncatingRemainder(dividingBy: 60) < 10 {
            seconds = "0" + seconds
        }
        timerLabel.text = minutes + ":" + seconds
    }
    /// 메인 스탑워치 업데이트
    @objc func updateMainTimer(){
        updateTimer(mainStopwatch)
    }
    /// 랩 스탑워치 업데이트
    @objc func updateLapTimer(){
        updateTimer(lapStopwatch)
    }
}

//MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return laps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: HistoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? HistoryTableViewCell else {
            return UITableViewCell()
        }
        
        cell.lapLabel.text = "Lap \(laps.count - (indexPath as NSIndexPath).row)"
        cell.lapTimerLabel.text = laps[laps.count - (indexPath as NSIndexPath).row - 1]
        
        return cell
    }
}
