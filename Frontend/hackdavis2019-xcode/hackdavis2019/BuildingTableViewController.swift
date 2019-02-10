//
//  BuildingTableViewController.swift
//  hackdavis2019
//
//  Created by Vanessa on 2/9/19.
//  Copyright © 2019 tut. All rights reserved.

import UIKit
import os.log

// Analytics Import(s)
import AWSCore
import CoreData
import Foundation
import AWSPinpoint

// Register/Login Import(s)
import AWSAuthCore
import AWSAuthUI
import AWSS3
import AWSCognitoIdentityProvider
import AWSMobileClient

class BuildingTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var _detailViewController: BuildingViewController? = nil
    var _userInfoProvider: UserInfoProvider? = nil
    
    var buildings: [Building] = []
    static var absDocURL: URL?
    
    override func viewDidLoad() {
        setBuildings()
        super.viewDidLoad()
        
        print("table view did load")
        self.tableView.delegate = self
        
        _userInfoProvider = UserInfoProvider()
        if !(AWSSignInManager.sharedInstance().isLoggedIn){
            AWSAuthUIViewController.presentViewController(with: self.navigationController!, configuration: nil) {(provider: AWSSignInProvider, error: Error?) in
                if error != nil{
                    print("Error occurred: \(String(describing: error))")
                }
                else{
                    print("About to query.")
                    self._userInfoProvider?.getUserFromDDB()
                }
            }
        }
        else{
            print("Already signed in. About to query.")
            self._userInfoProvider?.getUserFromDDB()
        }
        print("checked for sign-in")
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            _detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? BuildingViewController
        }
        
    }
    
    func setBuildings(){
        let wellman = Building(name: "Wellman Hall", total_demand: 0, electricity: 0, water: 0, steam: 0, imageView: UIImage(named: "wellman")!)
        let segundo_dc = Building(name: "Segundo Dining Commons", total_demand: 0, electricity: 0, water: 0, steam: 0, imageView: UIImage(named: "segundo-dc")!)
        let tercero_dc = Building(name: "Tercero Dining Commons", total_demand: 0, electricity: 0, water: 0, steam: 0, imageView: UIImage(named: "tercero-dc")!)
        let olson = Building(name: "Olson Hall", total_demand: 0, electricity: 0, water: 0, steam: 0, imageView: UIImage(named: "olson")!)
        let scc = Building(name: "Student Community Center", total_demand: 0, electricity: 0, water: 0, steam: 0, imageView: UIImage(named: "scc")!)
        let meyer = Building(name: "Meyer Hall", total_demand: 0, electricity: 0, water: 0, steam: 0, imageView: UIImage(named: "meyer")!)
        let life_sciences = Building(name: "Life Sciences", total_demand: 0, electricity: 0, water: 0, steam: 0, imageView: UIImage(named: "life-sciences")!)
        let young = Building(name: "Young Hall", total_demand: 0, electricity: 0, water: 0, steam: 0, imageView: UIImage(named: "young")!)
        let tupper = Building(name: "Tupper Hall", total_demand: 0, electricity: 0, water: 0, steam: 0, imageView: UIImage(named: "tupper")!)
        
        buildings.append(wellman)
        buildings.append(segundo_dc)
        buildings.append(tercero_dc)
        buildings.append(olson)
        buildings.append(scc)
        buildings.append(meyer)
        buildings.append(life_sciences)
        buildings.append(young)
        buildings.append(tupper)
        // etc
    }
    override func viewWillAppear(_ animated: Bool){
        print("table view about to appear")
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed // change
        super.viewWillAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if (segue.identifier == "showDetail") {
            print("Performing segue")
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = (segue.destination as! UINavigationController).topViewController as! BuildingViewController
                
                controller._userInfoProvider = _userInfoProvider
                
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                
                let to_building = buildings[indexPath.row]
                controller.navigationItem.title = to_building.name
                controller.building = to_building
                controller.navigationItem.leftItemsSupplementBackButton = true
                
                
            }
        }
        if (segue.identifier == "showAccount"){
            print("Performing segue")
            let controller = (segue.destination as! UINavigationController).topViewController as! AccountViewController
            controller._userInfoProvider = _userInfoProvider
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buildings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> BuildingTableViewCell {
        let cellIdentifier = "BuildingTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? BuildingTableViewCell else{
            fatalError("The dequeued cell is not an instance of BuildingTableViewCell.")
        } // change
//        let event = fetchedResultsController.object(at: indexPath)
        let curr_building: Building = buildings[indexPath.row]
        
        configureCell(cell, withBuilding: curr_building)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print("selected a row")
        _ = indexPath
        self.performSegue(withIdentifier: "showDetail", sender: indexPath)
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    func configureCell(_ cell: BuildingTableViewCell, withBuilding building: Building){
        print("configuring cell")
        cell.photoImageView.image = building.imageView
        cell.nameLabel.text = building.name
    }

}
