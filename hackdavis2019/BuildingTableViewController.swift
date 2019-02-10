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

//    @IBAction func accountButtonPressed(_ sender: Any) {
//
//        performSegue(withIdentifier: "showAccount", sender: nil)
//    }
    
    
    var _detailViewController: BuildingViewController? = nil
    var _userInfoProvider: UserInfoProvider? = nil
//    var _fetchedResultsController: NSFetchedResultsController<Meal>? = nil
//    var context: NSManagedObjectContext? = nil
    
    
    var buildings: [Building] = []
    static var absDocURL: URL?
    
    override func viewDidLoad() {
        setBuildings()
        super.viewDidLoad()
        
        print("table view did load")
        self.tableView.delegate = self
//        self.tableView.backgroundColor = UIColor.orange
//        let fileManager = FileManager.default
//        MealTableViewController.absDocURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
//        print("docs path is \(MealTableViewController.absDocURL!.path)")
        
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
        
//        context?.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
//        navigationItem.leftBarButtonItem = editButtonItem
        
//        let addMealButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewMeal(_:)))
//        navigationItem.rightBarButtonItem = addMealButton
        
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            _detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? BuildingViewController
        }
        
    }
    
    func setBuildings(){
        let wellman = Building(name: "Wellman Hall", total_demand: 0, electricity: 0, water: 0, steam: 0, imageView: UIImage(named: "wellman")!)
        let segundo_dc = Building(name: "Segundo Dining Commons", total_demand: 0, electricity: 0, water: 0, steam: 0, imageView: UIImage(named: "segundo-dc")!)
        let tercero_dc = Building(name: "Tercero Dining Commons", total_demand: 0, electricity: 0, water: 0, steam: 0, imageView: UIImage(named: "tercero-dc")!)
        buildings.append(wellman)
        buildings.append(segundo_dc)
        buildings.append(tercero_dc)
//
        // etc
    }
    override func viewWillAppear(_ animated: Bool){
        print("table view about to appear")
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed // change
        //        _mealsContentProvider?.getMealsFromDDB() // change: why include †his query?
        super.viewWillAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if (segue.identifier == "showDetail") {
            print("Performing segue")
            if let indexPath = tableView.indexPathForSelectedRow {
//                let object = fetchedResultsController.object(at: indexPath)
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
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let sectionInfo = fetchedResultsController.sections![section] // get information about fetched core data results
//        return sectionInfo.numberOfObjects // get number of objects in core data
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
//        cell.ratingControl.rating = Int(event.rating)
        //        print("configuring cell. file path is \(String(describing: event.filePath))")
//        if let meal_photo_path = event.filePath{
//            let absFilePath = MealTableViewController.absDocURL!.appendingPathComponent("\(meal_photo_path)").path
//            if !absFilePath.isEmpty && FileManager.default.fileExists(atPath: absFilePath){
//                if let image = UIImage(contentsOfFile: absFilePath){
//                    cell.photoImageView.image = image
//                }
//            }
//        }
//
    }

}
