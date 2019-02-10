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
        print("saving")
        
        var number_exists : Bool = false
        var user_name: String
        var user_number: String
        if let name: String = nameTextField.text {
            print("name is alright - 1")
            user_name = name
        }
        else{
            if let number: String = numberTextField.text{
                print("name and number are alright - 1")
                warningTextLabel.text = "Please include your name."
            }
            else{
                warningTextLabel.text = "Please include your name and number."
            }
            
            return
        }
        if let number: String = numberTextField.text {
            print("number is alright")
            user_number = numberTextField.text!
        }
        else{
            warningTextLabel.text = "Please include your number."
            return
        }
        
        if (user_name.isEmpty){
            print("user_name is empty")
            if (user_number.isEmpty){
                warningTextLabel.text = "Please include your name and number."
                print("both are empty")
            }
            else{
                warningTextLabel.text = "Please include your name and number."
            }
            return
        }
        if (user_number.isEmpty){
            warningTextLabel.text = "Please include your number."
            print("number is empty")
            return
        }
        
        if (user_number.count != 12){
            warningTextLabel.text = "Please follow the correct number format of: +12223334444."
            return
        }
        let start_index = user_number.index(user_number.startIndex, offsetBy: 3)
        let end_index = user_number.index(user_number.startIndex, offsetBy: 7)
        if let str = Int(String(user_number[start_index...end_index])){
            
        }
        else{
            warningTextLabel.text = "Please follow the correct number format of: +12223334444."
            return
        }
        
        _userInfoProvider!.updateUserDDB(userId: _userInfoProvider!._userId!, name: user_name, phone_number: user_number, wants_notifications: textSwitch.isOn)
        
    }
    
}
