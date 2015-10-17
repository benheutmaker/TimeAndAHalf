//
//  NetworkingEngine.swift
//  Time and a Half
//
//  Created by Benjamin Heutmaker on 8/8/15.
//  Copyright © 2015 Benjamin Heutmaker. All rights reserved.
//

import UIKit

class Network: NSObject {
    
    //Provide a shared instance across the app
    class func sharedInstance() -> Network {
        struct Static {
            static let instance = Network()
        }
        
        return Static.instance
    }
    
    override init() {
        super.init()
        
    }
    
    func getURLImageData(urlString: String, handler: (imageData: NSData?) -> Void) {
        if let url = NSURL(string: "http://www.google.com/s2/favicons?domain=" + urlString) {
            let request = NSURLRequest(URL: url)
            let session = NSURLSession.sharedSession()
            
            session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                guard let imageData = data else {
                    handler(imageData: nil)
                    print("imageData failed to download from web while retrieving favicon image")
                    return
                }
                handler(imageData: imageData)
            })
        }
    }
}











