//
//  NetworkingEngine.swift
//  Time and a Half
//
//  Created by Benjamin Heutmaker on 8/8/15.
//  Copyright © 2015 Benjamin Heutmaker. All rights reserved.
//

import UIKit
import Parse

class NetworkingEngine: NSObject {
    
    let clientQuery = PFQuery(className: "Client")
    let entryQuery = PFQuery(className: "Entry")
    
    override init() {
        super.init()
        
        clientQuery.cachePolicy = .CacheElseNetwork
        entryQuery.cachePolicy = .CacheElseNetwork
    }
    
    //Used to save data into Parse. This func will save all data into the local datastore before uploading it to the cloud, using .saveEventually()
    
    func saveClient(client: Client, response: (Client?) -> Void) {
        let body = serializeClient(client)
        
        let newPFClient = PFObject(className: "Client", dictionary: body)
        
        //Save to Local Datastore
        newPFClient.pinInBackground()
        
        //Save to server api.parse.com (eventually)
        newPFClient.saveEventually { (success, error) -> Void in
            
            guard let objectId = newPFClient.objectId else {
                print("The newPFClient has no objectID Parameter")
                return
            }
            
            if success {
                self.clientQuery.getObjectInBackgroundWithId(objectId, block: { (pfClient, error) -> Void in
                    
                    guard let client = pfClient else {
                        print("pfClient was found to be nil in saveClient(client: Client, response: (Client?) -> Void)")
                        return
                    }
                    
                    guard let newClient = self.parsedClient(client) else {
                        print("Failed to parse Client object, returned nil in saveClient(client: Client, response: (Client?) -> Void)")
                        return
                    }
                    
                    response(newClient)
                })
                
                
            } else {
                print("The new thread failed to save")
                response(nil)
            }
        }
    }
    
    func saveNewEntryToClient(client: Client, entry: Entry, response: (updatedEntries: [Entry]) -> Void) {
        let entryDict = serializedSingleEntry(entry, forClient: client)
        
        clientQuery.getObjectInBackgroundWithId(client.id!) { (pfClient, error) -> Void in
            pfClient!.addObjectsFromArray([entryDict], forKey: "entries")
            
            pfClient!.saveInBackgroundWithBlock({ (success, error) -> Void in
                if success {
                    let unparsedEntries = pfClient!["entries"] as! [[String : AnyObject]]
                    let entries = self.parseEntries(unparsedEntries)
                    
                    response(updatedEntries: entries!)
                }
            })
        }
    }
    
    func deleteEntryFromClient(client: Client, entry: Entry, completion: () -> Void) {
        let entryDict = serializedSingleEntry(entry, forClient: client)
        
        clientQuery.getObjectInBackgroundWithId(client.id!) { (pfClient, error) -> Void in
            pfClient!.removeObjectsInArray([entryDict], forKey: "entries")
            
            pfClient!.saveInBackgroundWithBlock({ (success, error) -> Void in
                if success {
                    completion()
                }
            })
        }
    }
    
    
    //Delete client from Server
    func deleteClient(client: Client, completion: () -> Void) {
        client.pfObject!.deleteInBackgroundWithBlock({ (success, error) -> Void in
            if error != nil {
                print(error)
            } else {
                if success {
                    completion()
                }
            }
        })
    }
    
    func retrieveAllData(handler: (clients: [Client]) -> Void) {
        
        clientQuery.findObjectsInBackgroundWithBlock { (clients, error) -> Void in
            //Make sure clients downloads with a value
            guard let clients = clients else {
                print("Error: 'clients returned nil'")
                return
            }
            
            //Create array to send to handler
            var parsedClients: [Client] = []
            
            
            //Loop through all clients in downloaded clients array and turn them into Client objects
            for client in clients {
                
                guard let newClient = self.parsedClient(client) else {
                    print("Failed to parse Client object, returned nil in retrieveAllData(handler: (clients: [Client]) -> Void)")
                    return
                }
                
                parsedClients.append(newClient)
            }
            
            //Send array to handler
            handler(clients: parsedClients)
        }
        
    }
    
    func serializedSingleEntry(entry: Entry, forClient client: Client) -> [String : AnyObject] {
        let entryDict = [
            "start" : entry.startDate!,
            "end" : entry.endDate!,
            "totalTime" : entry.findTotalTime(),
            "totalEarnings" : entry.findTotalEarnings(client.rate)
        ]
        
        return entryDict
    }
    
    //This func is set up to serialize the Entry object into a format that is safe to upload to Parse
    func serializedEntriesFromClient(client: Client) -> [[String : AnyObject]] {
        var entriesArray: [[String : AnyObject]] = []
        
        for entry in client.entries {
            let entryDict = [
                "start" : entry.startDate!,
                "end" : entry.endDate!,
                "totalTime" : entry.findTotalTime(),
                "totalEarnings" : entry.findTotalEarnings(client.rate)
            ]
            
            entriesArray.append(entryDict)
        }
        
        return entriesArray
    }
    
    //This func is meant to parse all entries out of a serialized array of entries, into a local class form of [Entry]
    func parseEntries(unparsedEntriesArray: [[String : AnyObject]]) -> [Entry]? {
        
        var entriesArray: [Entry] = []
        
        for entry in unparsedEntriesArray {
            let start = entry["start"] as! NSDate
            let end = entry["end"] as! NSDate
            let totalTime = entry["totalTime"] as! Double
            let totalEarnings = entry["totalEarnings"] as! Double
            
            let newEntry = Entry(startDate: start, endDate: end, totalTime: totalTime, totalEarnings: totalEarnings)
            
            entriesArray.append(newEntry)
        }
        
        return entriesArray
    }
    
    func serializeClient(client: Client) -> [String : AnyObject] {
        let body: [String : AnyObject] = [
            "title" : client.title,
            "rate" : client.rate,
            "id" : "",
            "entries" : serializedEntriesFromClient(client)
        ]
        
        return body
    }

    //Parse client object
    func parsedClient(unparsedClient: AnyObject?) -> Client? {
        
        guard let unparsedClient = unparsedClient as? PFObject else {
            print("unparsedClient did not return from Parse as PFObject")
            return nil
        }
        
        guard let title = unparsedClient["title"] as? String else {
            print("Error: 'Title in parsed client returned nil'")
            return nil
        }
        
        guard let rate = unparsedClient["rate"] as? Double else {
            print("Error: 'Rate in parsed client returned nil'")
            return nil
        }
        
        guard let id = unparsedClient.objectId else {
            print("Error: 'id in parsed client returned nil'")
            return nil
        }
        
        guard let unparsedEntries = unparsedClient["entries"] as? [[String : AnyObject]] else {
            print("rate is nil while saving PFClient in saveClient()")
            return nil
        }
        
        guard let entries = parseEntries(unparsedEntries) else {
            print("Failed to parse Entries while saving PFClient in saveClient()")
            return nil
        }
        
        //Create client object and append it to array
        let client = Client(title: title, rate: rate, id: id)
        client.pfObject = unparsedClient
        
        for entry in entries {
            client.entries.insert(entry, atIndex: 0)
        }
        
        return client
    }
    
}











