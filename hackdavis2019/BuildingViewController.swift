//
//  BuildingViewController.swift
//  hackdavis2019
//
//  Created by Vanessa on 2/9/19.
//  Copyright © 2019 tut. All rights reserved.
//

import UIKit
import os.log
import Foundation
import CoreData
import CoreGraphics
import AWSS3
import AWSMobileClient
import AWSDynamoDB
import AWSLambda

class BuildingViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    @IBOutlet weak var steamDataLabel: UILabel!
    @IBOutlet weak var electricityDataLabel: UILabel!
    @IBOutlet weak var waterDataLabel: UILabel!
    @IBOutlet weak var totalDataLabel: UILabel!
    
    var _userInfoProvider: UserInfoProvider? = nil
    var building: Building? = nil
    
    override func viewDidLoad() {
        loadData()
        super.viewDidLoad()
    }
    
    func loadData(){
        let name = building!.name
        let lambda_invoker = AWSLambdaInvoker.default()
        let json_obj: [String: Any] = ["Name": name]
        lambda_invoker.invokeFunction("DavisNRG-buildingHandler-mobilehub-358030209", jsonObject: json_obj).continueWith(block: {(task: AWSTask<AnyObject>)-> Any? in
            if (task.error != nil){
                print("Error: \(task.error!)")
                return nil
            }
            else{
                if let json_dict = task.result as? NSDictionary{
                    let body = json_dict["body"] as? NSDictionary
                    self.building!.electricity = body!["Electricity"] as! NSNumber
                    self.building!.steam = body!["Steam"] as! NSNumber
                    self.building!.water = body!["ChilledWater"] as! NSNumber
                    
                    if (name == "Life Sciences"){
                        DispatchQueue.main.async{
                            let total_float: Float = self.building!.electricity.floatValue + self.building!.steam.floatValue + self.building!.water.floatValue
                            self.building!.total_demand = total_float as NSNumber
                            self.totalDataLabel.text = self.building!.total_demand.stringValue + " kBtu"
                        }
                    }
                    else{
                        print("Yo")
                        self.building!.total_demand = body!["Total"] as! NSNumber
                    
                        DispatchQueue.main.async{
                            self.totalDataLabel.text = self.building!.total_demand.stringValue + " kBtu"
                        }
                    }
                    DispatchQueue.main.async{
                        self.steamDataLabel.text = self.building!.steam.stringValue + " kBtu"
                        self.electricityDataLabel.text = self.building!.electricity.stringValue + " kBtu"
                        self.waterDataLabel.text = self.building!.water.stringValue + " kBtu"
                    }
                }
            }
            return nil
        })
    }
    @IBAction func refreshButtonPressed(_ sender: Any) {
        loadData()
    }

    
}
