//
//  OWClientTableViewDelegate.swift
//  Time and a Half
//
//  Created by Benjamin Heutmaker on 10/8/15.
//  Copyright © 2015 Benjamin Heutmaker. All rights reserved.
//

import UIKit

class OWClientTableViewDelegate: NSObject, UITableViewDelegate {
    
    var clients: [OWClient]!
    
    var delegate: OWClientViewDelegate!
    
    init(withClients clients: [OWClient], delegate: OWClientViewDelegate) {
        super.init()
        
        self.clients = clients
        self.delegate = delegate
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let selectedClient = clients[indexPath.row]
        delegate.owClientViewController(didSelectClientAtIndexPath: selectedClient, indexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "Delete") { (action, _indexPath) -> Void in
            
            tableView.dataSource?.tableView!(tableView, commitEditingStyle: UITableViewCellEditingStyle.Delete, forRowAtIndexPath: indexPath)
            
            self.delegate.owClientViewController(
                didDeleteClientAtIndexPath: self.clients[indexPath.row],
                indexPath: indexPath,
                completion: { () -> Void in
                    
            })
            
            self.clients.removeAtIndex(indexPath.row)
        }
        
        let editAction = UITableViewRowAction(style: .Normal, title: "Edit") { (action, idx) -> Void in
            
        }
        
        return [deleteAction, editAction]
    }
}
