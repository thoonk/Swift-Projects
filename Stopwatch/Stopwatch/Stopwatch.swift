//
//  Stopwatch.swift
//  Stopwatch
//
//  Created by 김태훈 on 2020/10/19.
//

import Foundation

class Stopwatch: NSObject{
    var counter: Double
    var timer: Timer
    
    override init() {
        counter = 0.0
        timer = Timer()
    }
}
