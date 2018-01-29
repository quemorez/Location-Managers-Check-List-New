//
//  LocationInformationViewController.swift
//  Location Managers Check List New
//
//  Created by Zachary Quemore on 7/27/17.
//  Copyright © 2017 Zachary Quemore. All rights reserved.
//

import UIKit
import Parse
import UserNotifications

class LocationInformationViewController: UIViewController {
    var basecamp = true
    var crewParking = true
    var currentLocation = ""
    var CurrentLocationID = ""
    //var currentObject = PFObject()
    var BasecampLocation = PFGeoPoint()
    var CrewParkingLocation = PFGeoPoint()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var ShootDate = ""
    
    
    
    @IBOutlet var locationLabel: UILabel!
    
    
    
    @IBOutlet var locationAddressTextfield: UITextField!
    
    @IBOutlet var LocationContactTextField: UITextField!
    
    @IBOutlet var locationContactNumberTextfield: UITextField!
    
    @IBOutlet var locationContactEmailTextfield: UITextField!
    
    
    @IBOutlet var ShootDatePicker: UIDatePicker!
    
    @IBAction func ShootDateSellected(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        self.ShootDate = formatter.string(from: ShootDatePicker.date)
        print(self.ShootDate)
    }
    
    @IBOutlet var CateringAddressTextfield: UITextField!
    
    @IBOutlet var cateringContactNameTextfield: UITextField!
    
    @IBOutlet var cateringContactNumberTextfield: UITextField!
    
    @IBOutlet var cateringContactEmailTextfield: UITextField!
    
    
    
    
    @IBOutlet var basecampAddressTextfield: UITextField!
    
    @IBOutlet var basecampContactTextfield: UITextField!
    
    @IBOutlet var basecampContactNumberTextfield: UITextField!
    
    @IBOutlet var basecampContactEmailTextfield: UITextField!
    
    @IBOutlet var baseCampSwitch: UISwitch!
    
    @IBAction func basecampSwitch(_ sender: Any) {
        if baseCampSwitch.isOn {
            crewParking = true
            
        }else{
            crewParking = false
        }
        
    }
    
    @IBAction func BasecampAddressConversion(_ sender: Any) {
        var placemark: CLPlacemark!
        
        //this changes an address into a CLPlacemark that contains address,long,lat, and other info
        
        CLGeocoder().geocodeAddressString((sender as AnyObject).text!) { (placemarks, error) in
            if error == nil{
                
                placemark=(placemarks?[0])! as CLPlacemark
                
                
                
                //this creates a PFGeoPoint from the CLPlacemark created above
                
                self.BasecampLocation = PFGeoPoint(latitude: (placemark.location?.coordinate.latitude)!, longitude: (placemark.location?.coordinate.longitude)!)
                
                
            }else{
                self.displayAlert("Address not found", error: "please check address and try again")
            }
            
        }
    }
    
    
    
    
    @IBOutlet var crewParkingAddressTextField: UITextField!
    
    @IBOutlet var crewParkingContactTextfield: UITextField!
    
    @IBOutlet var crewparkingContactNumberTextfield: UITextField!
    
    @IBOutlet var crewParkingContactEmailTextfield: UITextField!
    
    @IBOutlet var crewParkingSwitch: UISwitch!
    
    @IBAction func crewParkingSwitch(_ sender: Any) {
        if crewParkingSwitch.isOn {
            basecamp = true
            
        }else{
            basecamp = false
        }
        
    }
    
    @IBAction func crewParkingAddressConversion(_ sender: Any) {
        var placemark: CLPlacemark!
        
        //this changes an address into a CLPlacemark that contains address,long,lat, and other info
        
        CLGeocoder().geocodeAddressString((sender as AnyObject).text!) { (placemarks, error) in
            if error == nil{
                
                placemark=(placemarks?[0])! as CLPlacemark
                
                
                
                //this creates a PFGeoPoint from the CLPlacemark created above
                
                self.CrewParkingLocation = PFGeoPoint(latitude: (placemark.location?.coordinate.latitude)!, longitude: (placemark.location?.coordinate.longitude)!)
                
                
                
            }else{
                self.displayAlert("Address not found", error: "please check address and try again")
            }
            
        }
    }
    
    
    
    @IBOutlet var holdingAddressTextfield: UITextField!
    
    @IBOutlet var holdingContactTextfield: UITextField!
    
    @IBOutlet var holdingContactNumberTextfield: UITextField!
    
    @IBOutlet var holdingContactEmailTextfield: UITextField!
    
    
    
    @IBOutlet var LocationNotesTextView: UITextView!
    
    @IBOutlet var openingNotesTextview: UITextView!
    
    @IBOutlet var closingNotesTextview: UITextView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationLabel.text = currentLocation
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        crewParking = false
        basecamp = false
        
        let query = PFQuery(className: "Location")
        query.getObjectInBackground(withId:CurrentLocationID){
            (Location, error) in
            if error != nil{
                
                print("There is a error while searching please check internet connection")
                
                self.displayAlert("Location Information was not saved", error: "Please check internet conection")
                print(error)
                
            }else if let Location = Location {
                // this saves all the text fields into the back end
                self.locationAddressTextfield.text  = Location["LocationAddress"] as? String
                self.LocationContactTextField.text = Location["LocationContact"] as? String
                self.locationContactNumberTextfield.text = Location["LocationContactNumber"] as? String
                self.locationContactEmailTextfield.text = Location["LocationContactEmail"] as? String
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yy"
                if (Location["ShootDate"] as? String) != nil {
                let date = dateFormatter.date(from: (Location["ShootDate"] as? String)!)
                    print(date)
                   self.ShootDatePicker.date = (date)!
                }
                
                
                self.CateringAddressTextfield.text = Location["CateringAddress"] as? String
                self.cateringContactNameTextfield.text = Location["CateringContact"] as? String
                self.cateringContactNumberTextfield.text = Location["CateringContactNumber"] as? String
                self.cateringContactEmailTextfield.text = Location["CateringContactEmail"] as? String
                
                
                self.basecampAddressTextfield.text = Location["BasecampAddress"] as? String
                self.basecampContactTextfield.text = Location["BasecampContact"] as? String
                self.basecampContactNumberTextfield.text = Location["BasecampContactNumber"] as? String
                self.basecampContactEmailTextfield.text = Location["BasecampContactEmail"] as? String
                
                
                self.crewParkingAddressTextField.text = Location["CrewParkingAddress"] as? String
                self.crewParkingContactTextfield.text = Location["CrewParkingContact"] as? String
                self.crewparkingContactNumberTextfield.text = Location["CrewParkingContactNumber"] as? String
                self.crewParkingContactEmailTextfield.text = Location["CrewParkingContactEmail"] as? String
                
                self.holdingAddressTextfield.text = Location["HoldingAddress"] as? String
                self.holdingContactTextfield.text = Location["HoldingContact"] as? String
                self.holdingContactNumberTextfield.text = Location["HoldingContactNumber"] as? String
                self.holdingContactEmailTextfield.text = Location["HoldingContactEmail"] as? String
                
                self.LocationNotesTextView.text = Location["LocationNotes"] as? String
                self.openingNotesTextview.text = Location["OpeningNotes"] as? String
                self.closingNotesTextview.text = Location["ClosingNotes"] as? String
                
                //put a bracket here
                
                
                
            }
            
        }
        
        
        
        
        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
        
        
        //creates an activity maker to tell users that a save is in process
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let query = PFQuery(className: "Location")
        query.getObjectInBackground(withId:CurrentLocationID){
            (Location, error) in
            if error != nil{
                
                print("There is a error while searching please check internet connection")
                
                self.displayAlert("Location Information was not saved", error: "Please check internet conection")
                print(error)
                
            }else if let Location = Location {
                // this saves all the text fields into the back end
                Location["LocationAddress"] = self.locationAddressTextfield.text
                Location["LocationContact"] = self.LocationContactTextField.text
                Location["LocationContactNumber"] = self.locationContactNumberTextfield.text
                Location["LocationContactEmail"] = self.locationContactEmailTextfield.text
                Location["ShootDate"] = self.ShootDate
                
                
                Location["CateringAddress"] = self.CateringAddressTextfield.text
                Location["CateringContact"] = self.cateringContactNameTextfield.text
                Location["CateringContactNumber"] = self.cateringContactNumberTextfield.text
                Location["CateringContactEmail"] = self.cateringContactEmailTextfield.text
                
                
                Location["BasecampAddress"] = self.basecampAddressTextfield.text
                Location["BasecampContact"] = self.basecampContactTextfield.text
                Location["BasecampContactNumber"] = self.basecampContactNumberTextfield.text
                Location["BasecampContactEmail"] = self.basecampContactEmailTextfield.text
                
                
                Location["CrewParkingAddress"] = self.crewParkingAddressTextField.text
                Location["CrewParkingContact"] = self.crewParkingContactTextfield.text
                Location["CrewParkingContactNumber"] = self.crewparkingContactNumberTextfield.text
                Location["CrewParkingContactEmail"] = self.crewParkingContactEmailTextfield.text
                
                Location["HoldingAddress"] = self.holdingAddressTextfield.text
                Location["HoldingContact"] = self.holdingContactTextfield.text
                Location["HoldingContactNumber"] = self.holdingContactNumberTextfield.text
                Location["HoldingContactEmail"] = self.holdingContactEmailTextfield.text
                
                Location["LocationNotes"] = self.LocationNotesTextView.text
                Location["OpeningNotes"] = self.openingNotesTextview.text
                Location["ClosingNotes"] = self.closingNotesTextview.text
                
                
                
                Location.saveInBackground(block: { (success, error) in
                    if success == true {
                        
                        //stops Activity Indicator
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        
                        //This saves the basecamp lot into the parking lot database for the basecamp crewparking App
                        // this saves the Basecamp parking
                        let queryBase = PFQuery(className: "parkingLot")
                        queryBase.whereKey("Location", equalTo: self.BasecampLocation)
                        queryBase.findObjectsInBackground{
                            (Location, error) in
                            if error != nil{
                                
                                print("There is a error while searching please check internet connection")
                                
                                self.displayAlert("Location Information was not saved", error: "Please check internet conection")
                                print(error)
                                
                            }else if let Location = Location {
                                print("this is location matching \(Location)")
                                
                                if Location.count < 1 && self.basecampAddressTextfield.text != "" {
                                    //checks if there is already a lot in the database with the same address
                                    let parkingLot = PFObject(className: "parkingLot")
                                    parkingLot["contact"] = self.basecampContactTextfield.text! as String
                                    
                                    parkingLot["PhoneNumber"] = self.basecampContactNumberTextfield.text! as String
                                    
                                    parkingLot["Address"] = self.basecampAddressTextfield.text! as String
                                    
                                    parkingLot["Email"] = self.basecampContactEmailTextfield.text! as String
                                    
                                    parkingLot["basecamp"] = true
                                    parkingLot["crewparking"] = self.crewParking
                                    
                                    // parkingLot.setObject(self.notesTextView.text, forKey: "Notes")
                                    parkingLot["Location"] = self.BasecampLocation
                                    parkingLot["UserWhoCreated"] = PFUser.current()?.username
                                    
                                    
                                    parkingLot.acl?.getPublicReadAccess = true
                                    parkingLot.acl?.getPublicWriteAccess = true
                                    
                                    
                                    
                                    
                                    parkingLot.saveInBackground(block: { (success, error) in
                                        if success == true {
                                            //stops Activity Indicator
                                            self.activityIndicator.stopAnimating()
                                            UIApplication.shared.endIgnoringInteractionEvents()
                                            
                                            print("parking lot created with ID:\(parkingLot.objectId)")
                                            
                                            
                                            
                                            
                                        } else {
                                            //stops Activity Indicator
                                            self.activityIndicator.stopAnimating()
                                            UIApplication.shared.endIgnoringInteractionEvents()
                                            
                                            self.displayAlert("Could not save lot", error: "Please check conection and try again")
                                            
                                        }
                                        
                                    })
                                    //put a bracket here
                                }
                            }
                            
                            
                        }
                        
                        
                        // this saves the crew parking
                        let queryCrew = PFQuery(className: "Location")
                        queryCrew.whereKey("Location", equalTo: self.CrewParkingLocation)
                        queryCrew.findObjectsInBackground{
                            (Location, error) in
                            if error != nil{
                                
                                print("There is a error while searching please check internet connection")
                                
                                self.displayAlert("Location Information was not saved", error: "Please check internet conection")
                                print(error)
                                
                            }else if let Location = Location {
                                print("this is the location\(Location)")
                                if Location.count < 1 && self.crewParkingAddressTextField.text != ""{
                                    let parkingLot = PFObject(className: "parkingLot")
                                    parkingLot["contact"] = self.crewParkingContactTextfield.text! as String
                                    
                                    parkingLot["PhoneNumber"] = self.crewparkingContactNumberTextfield.text! as String
                                    
                                    parkingLot["Address"] = self.crewParkingAddressTextField.text! as String
                                    
                                    parkingLot["Email"] = self.crewParkingContactEmailTextfield.text! as String
                                    
                                    parkingLot["basecamp"] = self.basecamp
                                    parkingLot["crewparking"] = true
                                    
                                    // parkingLot.setObject(self.notesTextView.text, forKey: "Notes")
                                    parkingLot["Location"] = self.CrewParkingLocation
                                    parkingLot["UserWhoCreated"] = PFUser.current()?.username
                                    
                                    
                                    parkingLot.acl?.getPublicReadAccess = true
                                    parkingLot.acl?.getPublicWriteAccess = true
                                    
                                    
                                    
                                    
                                    parkingLot.saveInBackground(block: { (success, error) in
                                        if success == true {
                                            //stops Activity Indicator
                                            self.activityIndicator.stopAnimating()
                                            UIApplication.shared.endIgnoringInteractionEvents()
                                            
                                            print("parking lot created with ID:\(parkingLot.objectId)")
                                            
                                            
                                            
                                            
                                            
                                        } else {
                                            //stops Activity Indicator
                                            self.activityIndicator.stopAnimating()
                                            UIApplication.shared.endIgnoringInteractionEvents()
                                            
                                            self.displayAlert("Could not save lot", error: "Please check conection and try again")
                                            
                                        }
                                        
                                    })
                                }
                                
                                
                            }
                            
                        }
                        
                        
                        self.displayAlert("Location Information Saved", error: "Your information has been saved")
                        
                        
                    } else {
                        //stops Activity Indicator
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        
                        self.displayAlert("Could not save Items", error: "Please check conection and try again")
                        
                    }
                    
                })
            }
            
        }
        
    }
    
    
    func CreateNotifications() {
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Testing Local Notifications", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "We are testing local notifications thais would have something about what your location is shooting", arguments: nil)
        content.sound = UNNotificationSound.default()
        let comps = Calendar.current.dateComponents(in: .current, from: ShootDatePicker.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
        let request = UNNotificationRequest(identifier: "Shoot Date Notification", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error: Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
        
    }
    
    //Helper Methiods
    //this function creats and alert that you can display errors with
    func displayAlert(_ title:String,error:String){
        
        let alert = UIAlertController(title:title, message: error, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            // self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
