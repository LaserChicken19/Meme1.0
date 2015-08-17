//
//  myTextFieldDelegate.swift
//  Portrait
//
//  Created by Chao Ju on 8/15/15.
//  Copyright (c) 2015 Chao Ju. All rights reserved.
//

import UIKit

class myTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        if textField.text=="TOP" || textField.text=="BOTTOM" {
            textField.text=""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
