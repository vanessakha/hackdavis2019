//
//  Building.swift
//  hackdavis2019
//
//  Created by Vanessa on 2/9/19.
//  Copyright © 2019 tut. All rights reserved.
//
import Foundation
import UIKit

class Building{
    var name: String
    var total_demand: NSNumber
    var electricity: NSNumber
    var water: NSNumber
    var steam: NSNumber
    var imageView: UIImage
    
    init(name: String, total_demand: NSNumber, electricity: NSNumber, water: NSNumber, steam: NSNumber, imageView: UIImage){
        self.name = name
        self.total_demand = total_demand
        self.electricity = electricity
        self.water = water
        self.steam = steam
        self.imageView = imageView
    }
    
    
    
}
