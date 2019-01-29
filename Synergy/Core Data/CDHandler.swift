//
//  CDHandler.swift
//  getting-started-ios-sdk
//
//  Created by omar on 2019-01-19.
//  Copyright © 2019 Smartcar. All rights reserved.
//

import CoreData
import UIKit

class CDHandler: NSObject {
    private class func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    
    class func saveObject (description: String, longitude: Double, latitude: Double) -> Bool {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Places", in: context)
        let managedObject = NSManagedObject(entity: entity!, insertInto: context)
        
        managedObject.setValue(description, forKey: "descriptions")
        managedObject.setValue(longitude, forKey: "longitude")
        managedObject.setValue(latitude, forKey: "latitude")
        
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    class func fetchObject() -> [Places]? {
        let context = getContext()
        var locations: [Places]? = nil
        
        do {
            locations = try context.fetch(Places.fetchRequest())
            return locations
        }catch {
            return locations
        }
        
    }
    
    
    
}
