//
//  MasterViewController.swift
//  Time
//
//  Created by Benjamin Heutmaker on 8/7/15.
//  Copyright © 2015 Benjamin Heutmaker. All rights reserved.
//

import UIKit
import CoreData

class OWClientViewController: UIViewController, OWClientViewDelegate {
    
    lazy var sharedContext: NSManagedObjectContext = CoreDataStackManager.sharedInstance().managedObjectContext
    
    //Array of all clients shown in self.tableView
    var clients: [OWClient] = []
    
    
    //MARK: - UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clients = fetchAllClients()
        setTableViewResources()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Add Plus button on right
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "showAddClientTableViewController")
        navigationItem.rightBarButtonItem = addButton
        
        //Add Edit button on left
        let editButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: "toggleEdit")
        navigationItem.leftBarButtonItem = editButton
    }
    
    func fetchAllClients() -> [OWClient] {
        let fetchRequest = NSFetchRequest(entityName: "Client")
        do {
            return try sharedContext.executeFetchRequest(fetchRequest) as! [OWClient]
        } catch let error as NSError {
            print(error)
            return [OWClient]()
        }
    }
    
    //MARK: - TableView Set Up
    
    @IBOutlet var tableView: OWClientTableView!
    @IBOutlet var emptyLabel: UILabel!
    
    var clientTableViewDelegate: OWClientTableViewDelegate!
    var clientTableViewDatasource: OWClientTableViewDatasource!
    
    func setTableViewResources() {
        //Initialize datasource and delegate with all Clients data, or update clients array if not nil
        if clientTableViewDelegate == nil {
            clientTableViewDelegate = OWClientTableViewDelegate(withClients: self.clients, delegate: self)
        } else {
            clientTableViewDelegate.clients = self.clients
        }
        
        if clientTableViewDatasource == nil {
            clientTableViewDatasource = OWClientTableViewDatasource(withClients: self.clients)
        } else {
            clientTableViewDatasource.clients = self.clients
        }
        
        //Set tableView's dataSource/delegate
        tableView.dataSource = clientTableViewDatasource
        tableView.delegate = clientTableViewDelegate
        
        if clientTableViewDatasource.clients.isEmpty {
            emptyLabel.hidden = false
        } else {
            emptyLabel.hidden = true
        }
        
        tableView.reloadData()
    }
    
    //Toggle edit on tableView
    func toggleEdit() {
        if tableView.editing {
            tableView.setEditing(false, animated: true)
            navigationItem.leftBarButtonItem?.title = "Edit"
            
        } else {
            tableView.setEditing(true, animated: true)
            navigationItem.leftBarButtonItem?.title = "Done"
        }
    }
    
    
    //MARK: - OWClientViewDelegate
    
    func owClientViewController(didSelectClientAtIndexPath client: OWClient, indexPath: NSIndexPath) {
        performSegueWithIdentifier("DetailSegue", sender: indexPath)
    }
    
    func owClientViewcontroller(didSaveNewClient newClient: OWClient) {
        
        clients = fetchAllClients()
        setTableViewResources()
        
        print(clients)
    }
    
    func owClientViewController(didDeleteClientAtIndexPath client: OWClient, indexPath: NSIndexPath, completion: () -> Void) {
        CoreDataStackManager.sharedInstance().managedObjectContext.deleteObject(client)
        CoreDataStackManager.sharedInstance().saveContext()
        setTableViewResources()
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DetailSegue" {
            let entryVC = segue.destinationViewController as! OWEntryViewController
            
            //Reference the correct client
            let selectedIndex = sender as! NSIndexPath
            let client = clients[selectedIndex.row]
            
            //set the data on the detail view (title, and client)
            entryVC.title = client.title
            entryVC.client = client
        
        } else if segue.identifier == "AddClient" {
            let addClientNavVC = segue.destinationViewController as! UINavigationController
            let addClientVC = addClientNavVC.childViewControllers[0] as! NewClientTableViewController
            
            addClientVC.delegate = self
        }
    }
    
    //Called from selector on addButton (rightBarButtonItem in navigation item)
    func showAddClientTableViewController() {
        performSegueWithIdentifier("AddClient", sender: self)
    }
    
    //Unwind segue
    @IBAction func unwindToMasterClientViewController(segue: UIStoryboardSegue) {}
    
}
