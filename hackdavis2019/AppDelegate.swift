//
//  AppDelegate.swift
//  hackdavis2019
//
//  Created by Vanessa on 2/9/19.
//  Copyright © 2019 tut. All rights reserved.
//

import UIKit

// Analytics Import(s)
import AWSPinpoint
import AWSCore
import CoreData

// Register/Login Import(s)
import AWSMobileClient
import AWSCognitoIdentityProvider

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    
    var pinpoint: AWSPinpoint?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let splitViewController = self.window!.rootViewController as! UISplitViewController
        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count - 1] as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        splitViewController.delegate = self
        
        let masterNavigationController = splitViewController.viewControllers[0] as! UINavigationController
//        let controller = masterNavigationController.topViewController as! BuildingTableViewController
//        controller.context = self.persistentContainer.viewContext
        
        // initialize AWSMobileClient
        let didFinishLaunching = AWSMobileClient.sharedInstance().interceptApplication(application, didFinishLaunchingWithOptions: launchOptions) // register user pool as identity provider
        
        let credentialsProvider = AWSMobileClient.sharedInstance().getCredentialsProvider()
        let configuration = AWSServiceConfiguration(region: .USWest2, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        pinpoint = AWSPinpoint(configuration: AWSPinpointConfiguration.defaultPinpointConfiguration(launchOptions: launchOptions))
        
        return didFinishLaunching
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        // create singleton instance of AWSMobileClient
        return AWSMobileClient.sharedInstance().interceptApplication(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool{
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else{ return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? BuildingViewController else { return false }
        if topAsDetailController.building == nil{
            return true
        }
        return false
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    lazy var persistentContainer: NSPersistentContainer = { // make a persistent container
        objc_sync_enter(self)
        let container = NSPersistentContainer(name: "Meal")
        container.loadPersistentStores(){ (storeDescription, error) in // completion handler
            if let error = error as NSError? {
                fatalError("Error! \(error), \(error.userInfo)")
            }
        }
        objc_sync_exit(self)
        return container
    }()
    
}


