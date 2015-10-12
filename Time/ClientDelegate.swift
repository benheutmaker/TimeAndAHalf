//
//  ClientDelegate.swift
//  Time and a Half
//
//  Created by Benjamin Heutmaker on 10/8/15.
//  Copyright © 2015 Benjamin Heutmaker. All rights reserved.
//

import UIKit

protocol ClientDelegate {
    
    func clientViewController(didSelectClientAtIndexPath client: Client, indexPath: NSIndexPath)
    func clientViewController(didDeleteClientAtIndexPath client: Client, indexPath: NSIndexPath, completion: () -> Void)
    func clientViewcontroller(didSaveNewClient newClient: Client)
}
