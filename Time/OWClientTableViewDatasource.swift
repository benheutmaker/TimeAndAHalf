//
//  OWClientTableViewDatasource.swift
//  Time and a Half
//
//  Created by Benjamin Heutmaker on 10/8/15.
//  Copyright © 2015 Benjamin Heutmaker. All rights reserved.
//

import UIKit

class OWClientTableViewDatasource: NSObject, UITableViewDataSource {
    
    var clients: [OWClient]!
    
    init(withClients clients: [OWClient]) {
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
        let cell = tableView.dequeueReusableCellWithIdentifier("ClientCell") as! OWClientCell
        
        let client = clients[indexPath.row]
        
        if let imageData = client.urlImageData {
            cell.urlImageView.image = UIImage(data: imageData)
        }
        cell.titleLabel.text = client.title
        cell.rateLabel.text = client.rateString()
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            clients.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
        }
    }
}
