//
//  TimeEntry.swift
//  Time
//
//  Created by Benjamin Heutmaker on 8/7/15.
//  Copyright © 2015 Benjamin Heutmaker. All rights reserved.
//

import UIKit

class Entry: NSObject {
    
    var startDate: NSDate?
    var endDate: NSDate?
    
    var totalEarnings: Double?
    var totalTime: Double?
    
    var timer: NSTimer?
    var counter: Int = 0
    
    init(start: NSDate) {
        self.startDate = start
    }
    
    init(startDate: NSDate, endDate: NSDate, totalTime: Double, totalEarnings: Double) {
        self.startDate = startDate
        self.endDate = endDate
        self.totalTime = totalTime
        self.totalEarnings = totalEarnings
    }
    
    func totalInterval() -> NSTimeInterval? {
        
        guard
            let start = startDate,
            let end = endDate
            
            else {
                return nil
        }
        
        let interval = round(end.timeIntervalSinceDate(start))
        
        return interval
    }
    
    func findTotalTime() -> Double {
        let interval = totalInterval()!
        let hours = interval / 3600
        
        let totalHours = round(100.0 * hours) / 100.0
        
        return totalHours
    }
    
    func totalTiimeString() -> String {
        
        let interval = totalInterval()!
        let hours = interval / 3600
        
        let hoursString = "\(round(100.0 * hours) / 100.0)"
        
        return hoursString
    }
    
    func findTotalEarnings(rate: Double) -> Double {
        
        let interval = totalInterval()!
        let perSecond = rate / 3600
        let total = perSecond * interval
        
        return round(100.0 * total) / 100.0
    }
    
    func timerString() -> String {
        
        let hours = counter / 3600
        let minutes = (counter % 3600) / 60
        let seconds = (counter % 3600) % 60
        
        let counterText = String(format: "%02dh %02dm %02ds", hours, minutes, seconds)
        
        return counterText
    }
}

