//
//  UIImageView+imageFromURL.swift
//  Time and a Half
//
//  Created by Benjamin Heutmaker on 10/16/15.
//  Copyright © 2015 Benjamin Heutmaker. All rights reserved.
//

import UIKit

extension UIImageView {
    public func imageFromUrl(urlString: String) {
        if let url = NSURL(string: urlString) {
            let request = NSURLRequest(URL: url)
            let session = NSURLSession.sharedSession()
            session.dataTaskWithRequest(request, completionHandler: { (image: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                self.image = UIImage(data: image!)
            })
        }
    }
}