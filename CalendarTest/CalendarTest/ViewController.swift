//
//  ViewController.swift
//  CalendarTest
//
//  Created by 김태훈 on 2021/02/06.
//

import UIKit
import FSCalendar

class ViewController: UIViewController {
    
    var currentPage: Date?
    var events: [Date?] = []
    
    lazy var today: Date = {
        return Date()
    }()
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCalendar()
        setEvents()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    @IBAction func prevButtonTapped(_ sender: UIButton) {
        print("prev")
        scrollCurrentPage(isPrev: true)
    }
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        print("next")
        scrollCurrentPage(isPrev: false)
    }
    
    func setCalendar() {
        calendarView.delegate = self
        calendarView.dataSource = self
        
        calendarView.locale = Locale(identifier: "ko_KR")
        calendarView.headerHeight = 0
        calendarView.scope = .month
        
        headerLabel.adjustsFontSizeToFitWidth = true
        
//        calendarView.appearance.headerMinimumDissolvedAlpha = 0
//        calendarView.appearance.headerDateFormat = "yyyy년 M월"
//        calendarView.appearance.headerTitleColor = .black
//        calendarView.appearance.headerTitleFont = UIFont.systemFont(ofSize: 20)
        calendarView.appearance.weekdayTextColor = .systemIndigo
        calendarView.appearance.todayColor = .cyan
    }
    
    func setEvents() {
        let today = formatter.date(from: "2021-02-06")
        events.append(today)
    }
    
    func scrollCurrentPage(isPrev: Bool) {
        let cal = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = isPrev ? -1 : 1
        
        self.currentPage = cal.date(byAdding: dateComponents, to: self.currentPage ?? self.today)
        self.calendarView.setCurrentPage(self.currentPage!, animated: true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as? TableViewCell,
              let event = self.events[indexPath.row]
        else { return UITableViewCell() }
        
        
        
        return cell
    }
}

extension ViewController: FSCalendarDataSource, FSCalendarDelegate {
    // 캘린더 이벤트 등록
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if self.events.contains(date) {
            return 1
        } else {
            return 0
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy년 M월"
        self.headerLabel.text = dateFormatter.string(from: calendar.currentPage)
    }
}
