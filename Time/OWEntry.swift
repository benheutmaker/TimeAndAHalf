//
//  OWEntry.swift
//  Time
//
//  Created by Benjamin Heutmaker on 8/7/15.
//  Copyright © 2015 Benjamin Heutmaker. All rights reserved.
//

import UIKit
import CoreData

class OWEntry: NSManagedObject {
    
    struct Keys {
        static let EntityName = "Entry"
        static let StartDate = "start_date"
        static let EndDate = "end_date"
        static let TotalEarnings = "total_earnings"
        static let TotalTime = "total_time"
    }
    
    @NSManaged var end_date: NSDate?
    @NSManaged var start_date: NSDate?
    @NSManaged var total_earnings: NSNumber?
    @NSManaged var total_time: NSNumber?
    @NSManaged var owner: OWClient?
    
    var timer: NSTimer?
    var counter: Int = 0
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(startDate: NSDate, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName(Keys.EntityName, inManagedObjectContext: context)!

        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        setStartData(startDate)
    }
    
    func setStartData(startDate: NSDate) {
        self.start_date = startDate
    }
    
    func setEndData(endDate: NSDate, rate: Double) {
        self.end_date = endDate
        self.total_time = findTotalTime()
        self.total_earnings = findTotalEarnings(rate)
    }
    
    func totalInterval() -> NSTimeInterval? {
        
        guard
            let start = start_date,
            let end = end_date
            
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

