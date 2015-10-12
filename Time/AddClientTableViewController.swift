//
//  AddClientTableViewController.swift
//  Time and a Half
//
//  Created by Benjamin Heutmaker on 10/11/15.
//  Copyright © 2015 Benjamin Heutmaker. All rights reserved.
//

import UIKit

class AddClientTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet var clientNameTextField: UITextField!
    @IBOutlet var rateTextField: UITextField!
    
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var cancelButton: UIBarButtonItem!
    
    var delegate: ClientDelegate!
    
    var alert: UIAlertController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        clientNameTextField.delegate = self
        rateTextField.delegate = self
    }

    @IBAction func saveButtonAction(sender: UIBarButtonItem) {
        
        if clientNameTextField.text == nil && rateTextField.text == nil {
            
            alert = UIAlertController(title: "Missing fields", message: "Looks like both fields are blank. Please enter both the Client's name and the hourly rate at which you charge.", preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        guard let clientName = clientNameTextField.text else {
            
            alert = UIAlertController(title: "Client must have a name!", message: "Please give the client a name!", preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        guard let clientRateString = rateTextField.text else {
            
            alert = UIAlertController(title: "You must include a rate", message: "Please specify the rate you charge the client hourly", preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        guard let rateDoubleValue = Double(clientRateString) else {
            
            alert = UIAlertController(title: "Invalid rate format", message: "The rate field must be in a decimal format such as: 10.55", preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        let newClient = Client(title: clientName, rate: rateDoubleValue, id: nil)
        delegate.clientViewcontroller(didSaveNewClient: newClient)
        
        performSegueWithIdentifier("unwindToMasterClientViewController", sender: sender)
    }
    
    @IBAction func cancelButtonAction(sender: UIBarButtonItem) {
        performSegueWithIdentifier("unwindToMasterClientViewController", sender: sender)
    }
    
    //UITextField Delegate
    
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
