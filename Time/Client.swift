//
//  EntryThread.swift
//  Time
//
//  Created by Benjamin Heutmaker on 8/7/15.
//  Copyright © 2015 Benjamin Heutmaker. All rights reserved.
//

import UIKit
import Parse

class Client: NSObject {
    
    var title: String
    var rate: Double
    var id: String?
    var pfObject: PFObject?
    
    var entries: [Entry]
    
    init(title: String, rate: Double, id: String?) {
        self.title = title
        self.rate = rate
        self.id = id
        entries = []
    }
    
    init(title: String, rate: Double, id: String?, pfObject: PFObject?, entries: [Entry]) {
        self.title = title
        self.rate = rate
        self.id = id
        self.pfObject = pfObject
        
        self.entries = entries
    }
    
    func rateString() -> String {
        return "$\(rate)/hr"
    }
    
}
