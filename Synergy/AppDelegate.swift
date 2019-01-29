//
//  AppDelegate.swift
//  getting-started-ios-sdk
//
//  Created by Smartcar on 11/19/18.
//  Copyright © 2018 Smartcar. All rights reserved.
//

import UIKit
import SmartcarAuth
import CoreData
import Foundation
import SmartcarAuth
import Alamofire
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var smartcar: SmartcarAuth?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        let viewController = ViewController()
        let navController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navController
//        var speedTimer = Timer.scheduledTimer(timeInterval: 100.0, target: self, selector: #selector(getSpeed), userInfo: nil, repeats: true)
        
        DispatchQueue.global(qos: .background).async {
            print("This is run on the background queue")
            var speedTimer = Timer.scheduledTimer(timeInterval: 100.0, target: self, selector: #selector(self.getSpeed), userInfo: nil, repeats: true)
            DispatchQueue.main.async {
                print("This is run on the main queue, after the previous code in outer block")
            }
        }
        
        return true
    }

    var d1: Double!
    var d2: Double!
    var d3: Double!
    var d4: Double!
    
    var speed: Double!
    var speed1: Double!
    
    @objc func getSpeed() {
        
        Alamofire.request("\(Constants.appServer)/speed", method: .get).responseJSON { (response) in
            
            if let result = response.result.value as! [String:Any]? {
                if let response = result["data"] as! [String: Any]?
                {
                    self.d1 = response["distance"] as? Double
                    print("First distance is \((self.d1)!) KM")
                    //Delay for 5 secods
                    sleep(5)
                    //Make the call again.
                    Alamofire.request("\(Constants.appServer)/speed", method: .get).responseJSON(completionHandler: { (response) in
                        
                        if let result = response.result.value as! [String: Any]? {
                            if let response = result["data"] as! [String:Any]?
                            {
                                self.d2 = response["distance"] as? Double
                                print("The third distance is \((self.d2)!)")
                                let distance = self.d2 - self.d1
                                print("The total distance for the first part is \(distance)")
                                self.speed = (distance / 5) * 1000
                                print("\((self.speed)!) is the speed (m/s) for the first part")
                            }
                        }
                    })
                }
            }
        }
    
        sleep(30)
        Alamofire.request("\(Constants.appServer)/speed", method: .get).responseJSON { (response) in
            
            if let result = response.result.value as! [String:Any]? {
                if let response = result["data"] as! [String: Any]?
                {
                    self.d3 = response["distance"] as? Double
                    print("The second distance is \((self.d3)!)")
                    //Delay for 5 secods
                    sleep(5)
                    //Make the call again.
                    Alamofire.request("\(Constants.appServer)/speed", method: .get).responseJSON(completionHandler: { (response) in
                        
                        if let result = response.result.value as! [String: Any]? {
                            if let response = result["data"] as! [String:Any]?
                            {
                                self.d4 = response["distance"] as? Double
                                print("The fourth distance is \((self.d4)!)")
                                let distance = self.d4 - self.d3
                                print("The total distance for the second part is \(distance)")
                                self.speed = (distance / 5) * 1000
                                print("\((self.speed)!) is the speed (m/s) for the second part")
                            }
                        }})
                }
            }
        }
        
        if speed1 == 0 && speed > 80000 {
            //Wait 5 minutes to see if the car moves
            sleep(300)
            if speed1 == 0 {
                //Send SMS
                let VC = MapViewController()
                let long = VC.locationManager.location?.coordinate.longitude
                let lat = VC.locationManager.location?.coordinate.latitude
                Alamofire.request("\(Constants.appServer)/message?long=\((long)!)&lat=\((lat)!)", method: .get).responseJSON { _ in}
            }
        }else {
            print("There is no issue")
            let VC = MapViewController()
            let long = VC.locationManager.location?.coordinate.longitude
            let lat = VC.locationManager.location?.coordinate.latitude
            let VC1 = SOSViewController()
            let number = VC1.resetingPasswordTextField.text
            Alamofire.request("\(Constants.appServer)/message?long=\((long)!)&lat=\((lat)!)&number=5148143838", method: .get).responseJSON { _ in}
        }
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

    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        // TODO: Authorization Step 3a: Receive the authorization code
        window!.rootViewController?.presentedViewController?.dismiss(animated: true , completion: nil)
        smartcar!.handleCallback(with: url)
        
        return true
    
}
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
 
    
}



