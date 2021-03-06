//
//  ClientDelegate.swift
//  Time and a Half
//
//  Created by Benjamin Heutmaker on 10/8/15.
//  Copyright © 2015 Benjamin Heutmaker. All rights reserved.
//

import UIKit

protocol OWClientViewDelegate {
    
    func owClientViewController(didSelectClientAtIndexPath client: OWClient, indexPath: NSIndexPath)
    func owClientViewController(didDeleteClientAtIndexPath client: OWClient, indexPath: NSIndexPath, completion: () -> Void)
    func owClientViewcontroller(didSaveNewClient newClient: OWClient)
}
