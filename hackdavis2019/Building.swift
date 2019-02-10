//
//  Building.swift
//  hackdavis2019
//
//  Created by Vanessa on 2/9/19.
//  Copyright © 2019 tut. All rights reserved.
//

class Building{
    var name: String
    var total_demand: Int
    var electricity: Int
    var water: Int
    var steam: Int
    var imageView: UIImage
    
    init(name: String, total_demand: Int, electricity: Int, water: Int, steam: Int, imageView: UIImage){
        self.name = name
        self.total_demand = total_demand
        self.electricity = electricity
        self.water = water
        self.steam = steam
        self.imageView = imageView
    }
    
    
    
}
