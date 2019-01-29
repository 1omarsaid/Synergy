//
//  LocationsViewController.swift
//  getting-started-ios-sdk
//
//  Created by omar on 2019-01-19.
//  Copyright © 2019 Smartcar. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import MapKit

class LocationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate {

    var longitude: Double!
    var latitude: Double!
    var address: String!
    @IBOutlet weak var tableView: UITableView!
    var manageObjectContext: NSManagedObjectContext!
    var locations = [Places]()
    let cellID = "Cellid"
    
    
    @IBAction func returnToHomeView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let subscriptionItem = locations[indexPath.row]
        if editingStyle == .delete {
            tableView.reloadData()
            manageObjectContext.delete(subscriptionItem)
            
            do {
                try manageObjectContext.save()
            } catch let error as NSError {
                print("Error While Deleting Note: \(error.userInfo)")
            }
        }
        self.loadSaveData()
    }
    
    
    
    func loadSaveData()  {
        
        let eventRequest: NSFetchRequest<Places> = Places.fetchRequest()
        do{
            locations = try manageObjectContext.fetch(eventRequest)
            self.tableView.reloadData()
        }catch
        {
            print("Could not load save data: \(error.localizedDescription)")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        print(locations)
        

        if CDHandler.fetchObject() != nil {
            locations = CDHandler.fetchObject()!
            tableView.reloadData()
        }
        
        navigationItem.title = "Collections"
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Create own view and connect it to this.
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        //This should display the address.
        
        var location = CLLocation(latitude: locations[indexPath.row].latitude, longitude: locations[indexPath.row].longitude)
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            guard let self = self else {return}
            
            if let _ = error {
                //Show error
                return
            }
            
            guard let placemarks = placemarks?.first else {
                //Show eeor
                return
            }
            let streetNumber = placemarks.subThoroughfare ?? ""
            let streetName = placemarks.thoroughfare ?? ""
            
            DispatchQueue.main.async {
                if streetNumber != "" && streetName != ""  {
                    self.address = "\(streetNumber) \(streetName)"
                    cell.textLabel?.text = self.address
                    cell.detailTextLabel?.text = self.locations[indexPath.row].descriptions
                } else {
                    cell.textLabel?.text = "Address does not exist"
                    cell.detailTextLabel?.text = self.locations[indexPath.row].descriptions
                }
                
            }
        }
        
//        cell.textLabel?.text = "\(address)"
        cell.detailTextLabel?.text = locations[indexPath.row].descriptions
        cell.layer.cornerRadius = 10
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(locations[indexPath.row].longitude)
        
        let latitude = locations[indexPath.row].latitude
        let longitude = locations[indexPath.row].longitude
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = Storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        
        vc.latitude = latitude
        vc.longitude = longitude
        
        
        
        present(vc, animated: true, completion: nil)
        
    }
   
}

//extension LocationsViewController: MKMapViewDelegate {
//    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        var location = CLLocation(latitude: locations, longitude: longitude)
//        let geoCoder = CLGeocoder()
//
//        geoCoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
//            guard let self = self else {return}
//
//            if let _ = error {
//                //Show error
//                return
//            }
//
//            guard let placemarks = placemarks?.first else {
//                //Show eeor
//                return
//            }
//            let streetNumber = placemarks.subThoroughfare ?? ""
//            let streetName = placemarks.subThoroughfare ?? ""
//
//            DispatchQueue.main.async {
//                self.address = "\(streetNumber) and \(streetName)"
//            }
//        }
//    }
//}
