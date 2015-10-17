//
//  OWRateTextFieldDelegate.swift
//  Time and a Half
//
//  Created by Benjamin Heutmaker on 10/12/15.
//  Copyright © 2015 Benjamin Heutmaker. All rights reserved.
//

import UIKit

class OWRateTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField.text == "??" {
//            textField.text = "??"
            return false
        }
        
        return true
    }
    
}
