//
//  ViewController.swift
//  Time
//
//  Created by Benjamin Heutmaker on 8/7/15.
//  Copyright © 2015 Benjamin Heutmaker. All rights reserved.
//

import UIKit
import CoreData

class OWEntryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    lazy var sharedContext: NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
        }()
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var punchInButton: UIButton!
    @IBOutlet var punchOutButton: UIButton!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var totalEarningLabel: UILabel!
    
    @IBOutlet var rateLabel: UILabel!
    
    @IBOutlet var emptyLabel: UILabel!
    
    var client: OWClient!
    
    var isCounting = false
    
    var selectedIndex: NSIndexPath?
    
    let utilities = AppDelegate.sharedAppDelegate().utilities
    
    
    //MARK: - UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelectionDuringEditing = false
        
        punchOutButton.hidden = true
        
        let editButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: "toggleEditingTableView")
        navigationItem.rightBarButtonItem = editButton
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        timerLabel.text = "00h:00m:00s"
        rateLabel.text = client.rateString()
    }
    
    func fetchAllEntries() -> [OWEntry] {
        let fetchRequest = NSFetchRequest(entityName: "Client")
        
        
    }
    
    
    //MARK: - Entry Handler Methods
    
    var currentEntry: OWEntry?
    
    @IBAction func punchIn() {
        
        if isCounting {
            //Do nothing
            return
            
        } else {
            currentEntry = nil
            currentEntry = OWEntry(startDate: NSDate(), context: sharedContext)
            
            currentEntry?.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTimerLabel", userInfo: nil, repeats: true)
            isCounting = true
            
            punchInButton.hidden = true
            punchOutButton.hidden = false
        }
    }
    
    @IBAction func endTimer(sender: UIButton) {
        
        //Set final values and save data (to sharedContext)
        currentEntry?.setEndData(NSDate(), rate: client.rate)
        client.entries.insert(currentEntry!, atIndex: 0)
        CoreDataStackManager.sharedInstance().saveContext()
        tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Right)
        
        //Stop and reset timer
        currentEntry?.timer?.invalidate()
        
        //Reset and update UI
        timerLabel.text = "00h:00m:00s"
        punchInButton.hidden = false
        punchOutButton.hidden = true
        
        updateTotalEarningLabel()
        
        //Reset all counter parameters
        currentEntry = nil
        isCounting = false
    }
    
    func updateTimerLabel() {
        
        if let entry = currentEntry {
            entry.counter++
            timerLabel.text = entry.timerString()
        } else {
            print("the entry isn't there...")
        }
    }
    
    func updateTotalEarningLabel() {
        var total: Double = 0.0
        
        for entry in client.entries {
            total += entry.findTotalEarnings(Double(client.rate))
        }
        
        totalEarningLabel.text = "$\(total) earned"
    }
    
    
    //MARK: - tableView Editing Delegate Functions
    
    func toggleEditingTableView() {
        if tableView.editing {
            tableView.setEditing(false, animated: true)
            navigationItem.rightBarButtonItem?.title = "Edit"
        } else {
            tableView.setEditing(true, animated: true)
            navigationItem.rightBarButtonItem?.title = "Done"
        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "Delete") { (action, actionIndexPath) -> Void in
            
//            self.network.deleteEntryFromClient(self.client, entry: self.client.entries[indexPath.row], completion: { () -> Void in
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    self.client.entries.removeAtIndex(actionIndexPath.row)
//                    tableView.dataSource?.tableView!(tableView, commitEditingStyle: UITableViewCellEditingStyle.Delete, forRowAtIndexPath: indexPath)
//                })
//            })
        }
        
        return [deleteAction]
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if selectedIndex == nil || indexPath != selectedIndex {
            return false
        } else {
            return true
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
            updateTotalEarningLabel()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if client.entries.isEmpty {
            emptyLabel.hidden = false
        } else {
            emptyLabel.hidden = true
        }
        
        return client.entries.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OWEntryCell") as! OWEntryCell
        
        let entry = client.entries[indexPath.row]
        
        cell.startTimeLabel.text = utilities.dateToString(entry.start_date!)
        cell.endTimeLabel.text = utilities.dateToString(entry.end_date!)
        
        if entry.total_time == 0.0 {
            cell.totalTimeLabel.text = "0.00"
        } else {
            cell.totalTimeLabel.text = entry.totalTiimeString()
        }
        
        cell.totalEarningsLabel.text = "$\(entry.findTotalEarnings(Double(client.rate)))"
        
        return cell
    }
    
    let cellHeight = CGFloat(67)
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath == selectedIndex {
            return cellHeight * 2
        }
        
        return cellHeight
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //Case: User selects cell that has already been expanded. Collapse this cell.
        if selectedIndex == indexPath {
            selectedIndex = nil
            
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        
        //Case: Expand cell when no cell is already selected and expanded.
        else if selectedIndex == nil {
            selectedIndex = indexPath
            
            tableView.beginUpdates()
            tableView.endUpdates()
            
        //Case: One cell is already expanded. Collapse previous cell and expand newly selected cell.
        } else {
            selectedIndex = nil
            
            tableView.beginUpdates()
            tableView.endUpdates()
            
            selectedIndex = indexPath
            
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        
        
    }
    
}

