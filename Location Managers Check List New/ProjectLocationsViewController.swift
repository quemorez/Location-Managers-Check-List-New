//
//  ProjectLocationsViewController.swift
//  Location Managers Check List New
//
//  Created by Zachary Quemore on 7/26/17.
//  Copyright © 2017 Zachary Quemore. All rights reserved.
//

import UIKit
import Parse

class ProjectLocationsViewController: UIViewController, UITableViewDelegate,UITableViewDataSource  {
    
    var currentProject = ""
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var error:String = ""
    var Locations = [PFObject]()
    var LocationsNames = [String]()
    var LocationsProgress = [Int]()
    var SelectedLocation = ""
    var screwup = false
    
    //outlets
    @IBOutlet var LocationsTableView: UITableView!
    
    
    
    @IBOutlet var projectTitleLable: UILabel!
    
    @IBOutlet var LocationTextField: UITextField!
    
    //Actions
    
    @IBAction func addLocation(_ sender: Any) {
        
        LocationTextField.endEditing(true)
        self.LocationsNames.removeAll(keepingCapacity: true)
        self.Locations.removeAll(keepingCapacity: true)
        
        //print(LocationTextField.text)
        
        if LocationTextField.text == "" {
            LocationTextField.endEditing(true)
            
            error = "Please type in the name of the Location you want to add"
            self.screwup = true
        } else {
            
        }
        
        if error != ""{
            
            displayAlert("Error In Form", error: error)
            
            
        } else {
            // print("first step working")
            
            //creates an activity maker to tell users that a save is in process
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            let Location = PFObject(className: "Location")
            Location["Name"] = LocationTextField.text! as String
            Location["Creater"] = PFUser.current()?.username!
            Location["Project"] = currentProject
            Location["LocationSectionCLItems"] = LocationSectionDictionary
            Location["HoldingSectionCLItems"] = HoldingSectionDictionary
            Location["VendorSectionCLItems"] = VendorSectionDictionary
            Location["OtherSectionCLItems"] = OtherSectionDictionary
            Location["PercentComplete"] = 0
            Location.saveInBackground(block: { (success, error) in
                if success == true {
                    
                    
                    //stops Activity Indicator
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    self.displayAlert("Location Saved", error: "Click on Locations to start checking tasks off")
                    let query = PFQuery(className: "Location")
                    query.whereKey("Project", contains: self.currentProject)
                    //query?.limit = 10
                    
                    query.findObjectsInBackground { (objects, error) in
                        if error != nil{
                            
                            print("There is a error while searching please check internet connection")
                            
                            self.displayAlert("Location not found", error: "Please check internet conection")
                            print(error)
                            
                        }else if let objects = objects {
                            //print(objects)
                            
                            self.Locations.removeAll(keepingCapacity: true)
                            for object in objects {
                                self.Locations.append(object)
                                
                                let Name: String = object["Name"] as! String
                                let Progress: Int = object["PercentComplete"] as! Int
                                
                                self.LocationsNames.append(Name)
                                self.LocationsProgress.append(Progress)
                                //print(self.ProjectsTitles)
                                self.LocationsTableView.reloadData()
                                
                            }
                        }
                    }
                    
                } else {
                    //stops Activity Indicator
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    self.displayAlert("Could not save Project", error: "Please check conection and try again")
                    
                }
                
            })
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(currentProject)
        projectTitleLable.text = currentProject
        
        
        self.LocationsTableView.dataSource = self
        self.LocationsTableView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        
        // Var clean up
        self.SelectedLocation = ""
        self.LocationsNames.removeAll(keepingCapacity: true)
        self.Locations.removeAll(keepingCapacity: true)
        self.LocationsProgress.removeAll(keepingCapacity: true)
        
        
        //creates an activity maker to tell users that a save is in process
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        
        // Mark: -  Query
        
        let query = PFQuery(className: "Location")
        query.whereKey("Project", equalTo: currentProject)
        
        
        
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                
                print("There is a error while searching please check internet connection")
                
                self.displayAlert("Location not found", error: "Please check internet conection")
                print(error)
                
            }else if let objects = objects {
                //print(objects)
                
                //stops Activity Indicator
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                
                self.Locations.removeAll(keepingCapacity: true)
                for object in objects {
                    self.Locations.append(object)
                    
                    let Name: String = object["Name"] as! String
                    let Progress: Int = object["PercentComplete"] as! Int
                    
                    self.LocationsNames.append(Name)
                    self.LocationsProgress.append(Progress)
                    print("location progress is \(self.LocationsProgress)")
                    self.LocationsTableView.reloadData()
                    
                    
                }
            }
        }
        
        // print(self.ProjectsTitles)
        self.LocationsTableView.reloadData()
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LocationsNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let LocationCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LocationTableViewCell
        
        //cell.backgroundColor = UIColor.darkGray
        LocationCell.LocationNameLabel.text = self.LocationsNames[indexPath.row]
        print(self.LocationsProgress[indexPath.row])
        LocationCell.PregressBar.progress = Float( Double (self.LocationsProgress[indexPath.row]) / Double (100))
        print(Float( Double (self.LocationsProgress[indexPath.row]) / Double (100)))
        
        
        return LocationCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        self.SelectedLocation = self.LocationsNames[indexPath.row]
        self.performSegue(withIdentifier: "CheckListSeque", sender: self)
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        // let settings = UITableViewRowAction(style: .normal, title: "Settings") { action, index in
        //    print("settings button tapped")
        //}
        // settings.backgroundColor = .orange
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            print("Delete button tapped")
            
            let locationName = self.LocationsNames[index.row]
            
            let query = PFQuery(className: "Location")
            query.whereKey("Project", equalTo: self.currentProject)
            query.whereKey("Name", equalTo: locationName as String)
            
            
            query.findObjectsInBackground { (objects, error) in
                if error != nil{
                    
                    print("There is a error while searching please check internet connection")
                    
                    self.displayAlert("Location not found", error: "Please check internet conection")
                    print(error)
                    
                }else if let objects = objects {
                    //print(objects)
                    
                    for object in objects {
                        object["Project"] = ""
                        object.saveInBackground()
                        self.LocationsNames.remove(at: index.row)
                        self.LocationsTableView.reloadData()
                        
                        
                    }
                }
            }
            
            print(index.row)
            self.LocationsTableView.reloadData()
        }
        delete.backgroundColor = .red
        
        return [delete]
    }
    
    
    //Helper Methiods
    //this function creats and alert that you can display errors with
    func displayAlert(_ title:String,error:String){
        
        let alert = UIAlertController(title:title, message: error, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            // self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CheckListSeque"{
            print("seque fired again")
            let CheckListView = segue.destination as! CheckListViewController
            CheckListView.CurrentLocation = self.SelectedLocation
            CheckListView.CurrentProject = self.currentProject
        }
        
    }
    
}
