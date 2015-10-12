//
//  ClientTableViewDelegate.swift
//  Time and a Half
//
//  Created by Benjamin Heutmaker on 10/8/15.
//  Copyright © 2015 Benjamin Heutmaker. All rights reserved.
//

import UIKit

class ClientTableViewDelegate: NSObject, UITableViewDelegate {
    
    var clients: [Client]!
    
    var delegate: ClientDelegate!
    
    init(withClients clients: [Client], delegate: ClientDelegate) {
        super.init()
        
        self.clients = clients
        self.delegate = delegate
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let selectedClient = clients[indexPath.row]
        delegate.clientViewController(didSelectClientAtIndexPath: selectedClient, indexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .Destructive, title: "Delete") { (action, _indexPath) -> Void in
            
            self.delegate.clientViewController(didDeleteClientAtIndexPath: self.clients[indexPath.row], indexPath: indexPath, completion: { () -> Void in
                self.clients.removeAtIndex(indexPath.row)
                tableView.dataSource?.tableView!(tableView, commitEditingStyle: UITableViewCellEditingStyle.Delete, forRowAtIndexPath: indexPath)
            })
        }
        
        let editAction = UITableViewRowAction(style: .Normal, title: "Edit") { (action, idx) -> Void in
            
        }
        
        return [deleteAction, editAction]
    }
}
