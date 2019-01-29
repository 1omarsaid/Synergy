//
//  ViewController.swift
//  getting-started-ios-sdk
//
//  Created by Smartcar on 11/19/18.
//  Copyright © 2018 Smartcar. All rights reserved.
//

import Alamofire
import UIKit
import SmartcarAuth
import CoreLocation
import UserNotifications



class ViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var vehicleText = ""
    var longitude: Double!
    var latitude: Double!
    let locationManager = CLLocationManager()
    
    
    let lockSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Lock", "Unlock"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
        sc.selectedSegmentIndex = 0     //Automatic highlight of the register icon
        sc.layer.cornerRadius = 5
        sc.clipsToBounds = true
        sc.addTarget(self, action: #selector(lockCarFunction), for: .valueChanged)
        return sc
    }()
    
    @objc func lockCarFunction() {
        //notificationSegmentation is the name of the segment control
        let getIndex = lockSegmentedControl.selectedSegmentIndex
        //Setting actions depending on which index was used
        switch getIndex {
        //If the Lock button is pressed
        case 0:
            print("locked")
            Alamofire.request("\(Constants.appServer)/lock", method: .post, parameters: ["action" : "LOCK"], encoding: JSONEncoding.default, headers: nil).responseJSON { _ in
            }
            //Show notification that the car is locked
            let content = UNMutableNotificationContent()
            content.title = "Locked"
            content.subtitle = "The car has been locked"
            content.body = ""
            content.badge = 1
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: "locked", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            
            break
            
        case 1:
            print("Unlocked")
            let parameters: Parameters = ["action" : "UNLOCK"]
            
            Alamofire.request("\(Constants.appServer)/unlock", method: .post, parameters: parameters , encoding: URLEncoding.default, headers: nil).responseJSON { _ in
            }
            let content = UNMutableNotificationContent()
            content.title = "Unlocked"
            content.subtitle = "The car has been Unlocked"
            content.body = ""
            content.badge = 1
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: "locked", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            break
        default:
            print("No selected")
        }
    }
    
    private func setupNavController() {
        view.backgroundColor = .white
        navigationItem.title = "Synergy"
        navigationController?.navigationBar.barTintColor =  #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    var roundedView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height * 0.15, width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.8))
        view.backgroundColor = .white
        view.layer.cornerRadius = 40
        return view
    }()
    
    //This is the button used to get the locations
    var roundButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.width * 0.4))
        button.backgroundColor = UIColor.blue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var sosButton: UIButton = {
        let button = UIButton(frame: CGRect(x: UIScreen.main.bounds.width * 0.57, y: UIScreen.main.bounds.height * 0.23, width: UIScreen.main.bounds.width * 0.13, height: UIScreen.main.bounds.width * 0.13))
        button.backgroundColor = .clear
        let image = UIImage(named: "sos")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(presentSOS), for: .touchUpInside)
        return button
    }()
    
    @objc func presentSOS() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "SOSViewController")
        let navigationController = UINavigationController(rootViewController: vc )
        self.present(navigationController, animated: true, completion: nil)
    }
    
    var listButtons: UIButton = {
        let button = UIButton(frame: CGRect(x: UIScreen.main.bounds.width * 0.15, y: UIScreen.main.bounds.height * 0.23 , width: UIScreen.main.bounds.width * 0.13, height: UIScreen.main.bounds.width * 0.13))
        button.backgroundColor = .clear
        let image = UIImage(named: "route")
        button.setImage(image, for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(openUpCollections), for: .touchUpInside)
        return button
    }()
    
    @objc func openUpCollections() {
        
        print("Will segue to the collections view")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "SubscriptionViewController")
        let navigationController = UINavigationController(rootViewController: vc )
        self.present(navigationController, animated: true, completion: nil)
        
        
    }

    let button: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: UIScreen.main.bounds.height * 0.2, width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.055))
        button.addTarget(self, action: #selector(connectPressed), for: .touchUpInside)
        button.setTitle("Connect your vehicle", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(#colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1), for: .normal)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        view.addSubview(roundedView)
        view.addSubview(roundButton)
        roundedView.addSubview(sosButton)
        roundedView.addSubview(listButtons)
        roundedView.addSubview(lockSegmentedControl)
        roundedView.center.x = view.center.x
//        setupNavController()
        navigationItem.title = "Synergy"
        navigationController?.navigationBar.tintColor = .white
        // TODO: Authorization Step 1: Initialize the Smartcar object
        appDelegate.smartcar = SmartcarAuth(
            clientId: Constants.clientId,
            redirectUri: "sc\(Constants.clientId)://exchange",
            development: true,
            completion: completion
        )
        
        self.view.addSubview(button)
        button.center.x = view.center.x

        roundButton.center.x = view.center.x
        roundButton.center.y = view.center.y

        setupSegmentControl()
        checkLocationServices()
        UNUserNotificationCenter.current().delegate = self

        
        
    }
    
    
    func setupSegmentControl() {
        lockSegmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.bounds.height * 0.3).isActive = true
        lockSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lockSegmentedControl.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.6).isActive = true
        lockSegmentedControl.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.04).isActive = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        roundButton.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        createFloatingButton()
        
        if button.titleLabel?.text == "Connect your vehicle" {
            roundButton.isHidden = true
            print("Helllo")
        }else {
            roundButton.isHidden = false
        }
    }
    
    
    func createFloatingButton() {
        roundButton = UIButton(type: .custom)
        roundButton.translatesAutoresizingMaskIntoConstraints = false
        roundButton.backgroundColor = .white
        // Make sure you replace the name of the image:
        roundButton.setImage(UIImage(named:"Press me"), for: .normal)
            // Make sure to create a function and replace DOTHISONTAP with your own function:
            roundButton.addTarget(self, action: #selector(getLocation), for: UIControl.Event.touchUpInside)
      
        
        // We're manipulating the UI, must be on the main thread:
        DispatchQueue.main.async {
            if let keyWindow = UIApplication.shared.keyWindow {
                keyWindow.addSubview(self.roundButton)
                NSLayoutConstraint.activate([
                    keyWindow.trailingAnchor.constraint(equalTo: self.roundButton.centerXAnchor, constant: UIScreen.main.bounds.width * 0.5),
                    keyWindow.topAnchor.constraint(equalTo: self.roundButton.topAnchor, constant: -UIScreen.main.bounds.height * 0.5),
                    self.roundButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.55),
                    self.roundButton.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.55)])
            }
            // Make the button round:
            self.roundButton.layer.cornerRadius = (UIScreen.main.bounds.width * 0.55) / 2
            // Add a black shadow:
            self.roundButton.layer.shadowColor =  #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)
            self.roundButton.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
            self.roundButton.layer.masksToBounds = false
            self.roundButton.layer.shadowOpacity = 0.5
            let scaleAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.duration = 0.4
            scaleAnimation.repeatCount = .greatestFiniteMagnitude
            scaleAnimation.autoreverses = true
            scaleAnimation.fromValue = 1.0;
            scaleAnimation.toValue = 1.05;
            self.roundButton.layer.add(scaleAnimation, forKey: "scale")
        }
    }
    
    
    @objc func getLocation() {
        print("Get location")
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Description", message: "Enter a description for the Location", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
            self.roundButton.isHidden = true
        }
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
            //This will take the description, longitude, latitude and save it to core data.
            self.roundButton.isHidden = false
            
            Alamofire.request("\(Constants.appServer)/location", method: .get).responseJSON { response in
//                print(response.result.value!)
                
                if let result = response.result.value as! [String:Any]? {
                    if let response = result["data"] as! [String : Any]? {
                        self.latitude = response["latitude"] as? Double
                        self.longitude = response["longitude"] as? Double
                        
                        //Need to save the data to core data so that it will be called in the collectionView.
                        if textField.text != nil && self.longitude != nil && self.latitude != nil {
                            if CDHandler.saveObject(description: textField.text!, longitude: self.longitude!, latitude: self.latitude!) {
                                for user in CDHandler.fetchObject()! {
                                    print("\((user.descriptions)!) \nLatitude: \((user.latitude)) \nLongitude: \((user.longitude))")
                                }
                            }
                        }else {
                            //error handeling
                            
                        }
                    }
                }
            }
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func connectPressed(_ sender: UIButton) {
        // TODO: Authorization Step 2: Launch the authorization flow
        let smartcar = appDelegate.smartcar!
        smartcar.launchAuthFlow(viewController: self)
    }
    
    
    func completion(err: Error?, code: String?, state: String?) -> Any {
        
        
        // send request to exchange auth code for 
        Alamofire.request("\(Constants.appServer)/exchange?code=\(code!)", method: .get).responseJSON { _ in
            // TODO: Request Step 2: Get vehicle information
            // send request to retrieve the vehicle info
            Alamofire.request("\(Constants.appServer)/vehicle", method: .get).responseJSON { response in
                print(response.result.value!)
                
                if let result = response.result.value {
                    let JSON = result as! NSDictionary
                    
                    let make = JSON.object(forKey: "make")!  as! String
                    let model = JSON.object(forKey: "model")!  as! String
                    let year = String(JSON.object(forKey: "year")!  as! Int)
                    
                    let vehicle = "\(year) \(make) \(model)"
                    self.vehicleText = vehicle
                    print(vehicle)
                }
            }
        }
        
        
        button.setTitle("Connected!! 🙌", for: .normal)
        return ""
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? InfoViewController {
            destinationVC.text = self.vehicleText
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            
            break
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        }else {
            //Show alert to turn on location services
            
        }
    }

}


extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    }
    
}

extension ViewController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //If you don't want to show notification when app is open, do something here else and make a return here.
        //Even you you don't implement this delegate method, you will not see the notification on the specified controller. So, you have to implement this delegate and make sure the below line execute. i.e. completionHandler.
        
        completionHandler([.alert, .badge, .sound])
    }
    
}
