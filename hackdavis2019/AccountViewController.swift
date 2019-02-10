//
//  AccountViewController.swift
//  hackdavis2019
//
//  Created by Vanessa on 2/10/19.
//  Copyright © 2019 tut. All rights reserved.
//

import Foundation
import UIKit

class AccountViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UITextViewDelegate{
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var textSwitch: UISwitch!
    @IBOutlet weak var warningTextLabel: UILabel!
    
    var _userInfoProvider: UserInfoProvider? = nil
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        // save info
        
        var name: String = nameTextField.text!
        var number: String = numberTextField.text!
        if (name.isEmpty || number.isEmpty){
            warningTextLabel.text = "Please include your name and number before saving."
        }
        else{
            _userInfoProvider!.updateUserDDB(userId: _userInfoProvider!._userId, name: name, phone_number: number, wants_notifications: textSwitch.isOn)
        }
        
    }
    
}
