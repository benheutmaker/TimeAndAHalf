//
//  MasterViewController.swift
//  Time
//
//  Created by Benjamin Heutmaker on 8/7/15.
//  Copyright © 2015 Benjamin Heutmaker. All rights reserved.
//

import UIKit

class ClientViewController: UIViewController, ClientDelegate {
    
    //Singleton instance of NetworkingEngine reference
    let network = AppDelegate.sharedAppDelegate().engine
    
    //Array of all clients shown in self.tableView
    var clients: [Client] = []
    
    
    //MARK: - UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableViewResources()
        loadDataFromNetwork()
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
    
    
    //MARK: - TableView Set Up
    
    @IBOutlet var tableView: ClientTableView!
    @IBOutlet var emptyLabel: UILabel!
    
    var clientTableViewDelegate: ClientTableViewDelegate!
    var clientTableViewDatasource: ClientTableViewDatasource!
    
    func setTableViewResources() {
        //Initialize with all Clients data, or update clients array if not nil
        if clientTableViewDelegate == nil {
            clientTableViewDelegate = ClientTableViewDelegate(withClients: self.clients, delegate: self)
        } else {
            clientTableViewDelegate.clients = self.clients
        }
        
        if clientTableViewDatasource == nil {
            clientTableViewDatasource = ClientTableViewDatasource(withClients: self.clients)
        } else {
            clientTableViewDatasource.clients = self.clients
        }
        
        //Set tableView's dataSource/delegate
        tableView.dataSource = clientTableViewDatasource
        tableView.delegate = clientTableViewDelegate
        
        if clientTableViewDatasource.clients.count == 0 {
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
    
    
    //MARK: - Network calls
    
    func loadDataFromNetwork() {
        
        network.retrieveAllData { (clients) -> Void in
            
            for newClient in clients {
                self.clients.insert(newClient, atIndex: 0)
            }
            
            //Reload all data
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.setTableViewResources()
            })
        }
    }
    
    
    //MARK: - ClientDelegate
    
    func clientViewController(didSelectClientAtIndexPath client: Client, indexPath: NSIndexPath) {
        performSegueWithIdentifier("DetailSegue", sender: indexPath)
    }
    
    func clientViewcontroller(didSaveNewClient newClient: Client) {
        
        //Save object to Parse -> Asynchronously retrieve from server, then display on tableView
        network.saveClient(newClient) { (client) -> Void in
            if client != nil {
                
                //Add client to tableView
                self.loadDataFromNetwork()
                
            } else {
                print("client returned nil in saveNewClient")
            }
        }
    }
    
    func clientViewController(didDeleteClientAtIndexPath client: Client, indexPath: NSIndexPath, completion: () -> Void) {
        network.deleteClient(client) { () -> Void in
            self.clients.removeAtIndex(indexPath.row)
            self.loadDataFromNetwork()
            
            completion()
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DetailSegue" {
            let entryVC = segue.destinationViewController as! EntryViewController
            
            //Reference the correct client
            let selectedIndex = sender as! NSIndexPath
            let client = clients[selectedIndex.row]
            
            //set the data on the detail view (title, and client)
            entryVC.title = client.title
            entryVC.client = client
        
        } else if segue.identifier == "AddClient" {
            let addClientNavVC = segue.destinationViewController as! UINavigationController
            let addClientVC = addClientNavVC.childViewControllers[0] as! AddClientTableViewController
            
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
