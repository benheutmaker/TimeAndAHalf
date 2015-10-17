//
//  OWClient.swift
//  Time
//
//  Created by Benjamin Heutmaker on 8/7/15.
//  Copyright © 2015 Benjamin Heutmaker. All rights reserved.
//

import UIKit
import CoreData

class OWClient: NSManagedObject {
    
    struct Keys {
        static let EntityName = "Client"
        static let Title = "title"
        static let Rate = "rate"
        static let ID = "id"
        static let Entries = "all_entries"
    }
    
    var entries: [OWEntry] = []
    
    @NSManaged var title: String
    @NSManaged var rate: Double
    @NSManaged var id: String?
    @NSManaged var urlImageData: NSData?
    @NSManaged var all_entries: OWEntry?
    
    var urlImageURLString: String? {
        didSet {
            Network.sharedInstance().getURLImageData(urlImageURLString!, handler: { (imageData) -> Void in
                self.urlImageData = imageData
                CoreDataStackManager.sharedInstance().saveContext()
            })
        }
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName(Keys.EntityName, inManagedObjectContext: context)!
        
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.title = dictionary[Keys.Title] as! String
        self.rate = dictionary[Keys.Rate] as! Double
        self.id = dictionary[Keys.ID] as? String
        self.entries = dictionary[Keys.Entries] as! [OWEntry]
    }
    
    func rateString() -> String {
        return "$\(rate)/hr"
    }
}
