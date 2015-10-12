//
//  Utilities.swift
//  Time and a Half
//
//  Created by Benjamin Heutmaker on 8/7/15.
//  Copyright © 2015 Benjamin Heutmaker. All rights reserved.
//

import UIKit

class Utilities: NSObject {
    
    var dateFormatter = NSDateFormatter()
    
    override init() {
        dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
    }
    
    func dateToString(date: NSDate) -> String {
        return dateFormatter.stringFromDate(date)
    }
}
