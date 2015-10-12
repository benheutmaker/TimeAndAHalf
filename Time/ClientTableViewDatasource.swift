//
//  ClientTableViewDatasource.swift
//  Time and a Half
//
//  Created by Benjamin Heutmaker on 10/8/15.
//  Copyright © 2015 Benjamin Heutmaker. All rights reserved.
//

import UIKit

class ClientTableViewDatasource: NSObject, UITableViewDataSource {
    
    var clients: [Client]!
    
    init(withClients clients: [Client]) {
        super.init()
        
        //Set values
        self.clients = clients
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if clients.count == 0 {
            return ""
        
        } else {
            return nil
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clients.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ClientCell")!
        
        cell.textLabel?.text = clients[indexPath.row].title
        cell.detailTextLabel?.text = "$\(clients[indexPath.row].rate)/hr"
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            clients.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
        }
    }
}
