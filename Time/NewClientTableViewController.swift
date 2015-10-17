//
//  AddClientTableViewController.swift
//  Time and a Half
//
//  Created by Benjamin Heutmaker on 10/11/15.
//  Copyright © 2015 Benjamin Heutmaker. All rights reserved.
//

import UIKit
import CoreData

class NewClientTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet var clientNameTextField: OWTextField!
    @IBOutlet var rateTextField: OWTextField!
    @IBOutlet var urlTextField: OWTextField!
    
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var cancelButton: UIBarButtonItem!
    
    var delegate: OWClientViewDelegate!
    
    var alert: UIAlertController!
    
    lazy var sharedContext: NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        clientNameTextField.delegate = self
        rateTextField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        clientNameTextField.becomeFirstResponder()
    }

    @IBAction func saveButtonAction(sender: UIBarButtonItem) {
        
        if clientNameTextField.text == "" && rateTextField.text == "$" {
            
            alert = UIAlertController(title: "Missing fields", message: "Looks like both fields are blank. Please enter both the Client's name and the hourly rate at which you charge.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Got it", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        
        } else if clientNameTextField.text == "" {
            
            alert = UIAlertController(title: "Client must have a name!", message: "Please give the client a name!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Got it", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        
        } else if rateTextField.text == "" {
            
            alert = UIAlertController(title: "You must include a rate", message: "Please specify the rate you charge the client hourly", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Got it", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
            
        }
        
        guard let rateDoubleValue = Double(rateTextField.text!) else {
            
            alert = UIAlertController(title: "Invalid rate format", message: "The rate field must be in a decimal format such as: 10.55", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Got it", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        let clientDictionary: [String : AnyObject] = [
            OWClient.Keys.Title : clientNameTextField.text!,
            OWClient.Keys.Rate : rateDoubleValue,
            OWClient.Keys.Entries : [OWEntry]()
        ]
        
        let newClient = OWClient(dictionary: clientDictionary, context: sharedContext)
        
        newClient.urlImageURLString = urlTextField.text //Optional

        
        do {
            try sharedContext.save()
            delegate.owClientViewcontroller(didSaveNewClient: newClient)
            
        } catch let error as NSError? {
            print(error!)
        }
        
        performSegueWithIdentifier("unwindToMasterClientViewController", sender: sender)
    }
    
    @IBAction func cancelButtonAction(sender: UIBarButtonItem) {
        tableView.endEditing(true)
        performSegueWithIdentifier("unwindToMasterClientViewController", sender: sender)
    }
    
    
    //UITextField Delegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let text = NSString(string: textField.text!)
        text.stringByReplacingCharactersInRange(range, withString: "$" + (text as String))
        
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        //Jump to rateTextField with return key
        if textField == clientNameTextField {
            rateTextField.becomeFirstResponder()
            
        //Save new Client to server
        } else if textField == rateTextField {
            saveButtonAction(saveButton)
        }
        
        return true
    }
}
