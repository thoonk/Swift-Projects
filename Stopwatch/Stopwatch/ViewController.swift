//
//  ViewController.swift
//  Stopwatch
//
//  Created by 김태훈 on 2020/10/19.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    
    //MARK: - Property
    private let mainStopwatch: Stopwatch = Stopwatch()
    private let lapStopwatch: Stopwatch = Stopwatch()
    private let cellIdentifier: String = "historyCell"
    private var isStart: Bool = false
    private var laps: [String] = []
    
    //MARK: - UI Components
    @IBOutlet weak var mainTimerLabel: UILabel!
    @IBOutlet weak var lapTimerLabel: UILabel!
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
            if let timerText = lapTimerLabel.text {
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
    private func changeBtnStatus(_ button: UIButton, title: String, titleColor: UIColor){
        button.setTitle(title, for: UIControl.State())
        button.setTitleColor(titleColor, for: UIControl.State())
    }
    /// 메인 스탑워치 타이머 리셋
    private func resetMainTimer(){
        resetTimer(mainStopwatch, label: mainTimerLabel)
        laps.removeAll()
        lapsTableView.reloadData()
    }
    /// 랩 스탑워치 타이머 리셋
    private func resetLapTimer() {
        resetTimer(lapStopwatch, label: lapTimerLabel)
    }
    /// 스탑워치 타이머 리셋
    private func resetTimer(_ stopwatch: Stopwatch, label: UILabel){
        stopwatch.timer.invalidate()
        stopwatch.counter = 0.0
        label.text = "00:00.00"
    }
    
    /// 스탑워치 타이머 업데이트
    func updateTimer(_ stopwatch: Stopwatch, label: UILabel){
        stopwatch.counter = stopwatch.counter + 0.035
        
        var minutes: String = "\((Int)(stopwatch.counter / 60))"
        if (Int)(stopwatch.counter / 60) < 10 {
          minutes = "0\((Int)(stopwatch.counter / 60))"
        }
        
        var seconds: String = String(format: "%.2f", (stopwatch.counter.truncatingRemainder(dividingBy: 60)))
        if stopwatch.counter.truncatingRemainder(dividingBy: 60) < 10 {
          seconds = "0" + seconds
        }
        label.text = minutes + ":" + seconds
    }
    /// 메인 스탑워치 업데이트
    @objc func updateMainTimer(){
        updateTimer(mainStopwatch, label: mainTimerLabel)
    }
    /// 랩 스탑워치 업데이트
    @objc func updateLapTimer(){
        updateTimer(lapStopwatch, label: lapTimerLabel)
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
