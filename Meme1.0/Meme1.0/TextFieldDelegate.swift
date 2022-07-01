//
//  TextFieldDelegate.swift
//  Meme1.0
//
//  Created by minhdat on 30/06/2022.
//

import Foundation
import UIKit
class TextFieldDelegate : NSObject, UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    
}
