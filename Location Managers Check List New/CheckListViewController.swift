//
//  CheckListViewController.swift
//  Location Managers Check List New
//
//  Created by Zachary Quemore on 7/26/17.
//  Copyright © 2017 Zachary Quemore. All rights reserved.
//

import UIKit
import Parse




class CheckListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var CurrentLocation = ""
    var CurrentProject = ""
    var CurrentLocationID = ""
    var numberComplete = 0
    var PercentComplete = 0
    var newItem = [String: String]()
    var CheckedTasks = [String]()
    var canEdit = false
    var parsedLocationSectionCLItems = [String:Bool]()
    var parsedLocationSectionCLItemsKeys: Array = [String]()
    var parsedHoldingSectionCLItems = [String:Bool]()
    var parsedHoldingSectionCLItemsKeys: Array = [String]()
    var parsedVendorSectionCLItems = [String:Bool]()
    var parsedVendorSectionCLItemsKeys: Array = [String]()
    var parsedOtherSectionCLItems = [String:Bool]()
    var parsedOtherSectionCLItemsKeys: Array = [String]()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet var checkListTableView: UITableView!
    
    @IBAction func addCheckListItemAction(_ sender: Any) {
        performSegue(withIdentifier: "addItemSegue", sender: self)
    }
    
    @IBAction func locationInfoBtn(_ sender: Any) {
        performSegue(withIdentifier: "toLocationInformationSegue", sender: self)
    }
    
    @IBAction func vendorOrderBtn(_ sender: Any) {
        performSegue(withIdentifier: "VendorOrderSegue", sender: self)
    }
    
    @IBAction func chatBtn(_ sender: Any) {
        performSegue(withIdentifier: "toChatSegue", sender: self)
        
    }
    
    override func viewDidLoad() {
        
        //checkListTableView.setEditing(true, animated: true)
        super.viewDidLoad()
        
        
        self.checkListTableView.dataSource = self
        self.checkListTableView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        //checkListTableView.reloadData()
        
        
        // Var clean up
        
        self.parsedLocationSectionCLItemsKeys.removeAll()
        self.parsedHoldingSectionCLItemsKeys.removeAll()
        self.parsedVendorSectionCLItemsKeys.removeAll()
        self.parsedOtherSectionCLItemsKeys.removeAll()
        
        
        
        
        
        
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
        query.whereKey("Project", equalTo: CurrentProject)
        query.whereKey("Name", equalTo: CurrentLocation)
        
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                
                print("There is a error while searching please check internet connection")
                
                self.displayAlert("Check list not found", error: "Please check internet conection")
                print(error)
                
            }else if let objects = objects {
                
                
                for object in objects {
                    
                    self.CurrentLocationID = object.objectId!
                    self.parsedLocationSectionCLItems = object ["LocationSectionCLItems"] as! Dictionary
                    self.parsedHoldingSectionCLItems = object ["HoldingSectionCLItems"] as! Dictionary
                    self.parsedVendorSectionCLItems = object ["VendorSectionCLItems"] as! Dictionary
                    self.parsedOtherSectionCLItems = object ["OtherSectionCLItems"] as! Dictionary
                    
                    
                    // handle new checklist item
                    for (newKey,newValue) in self.newItem {
                        if newValue == "Location" {
                            self.parsedLocationSectionCLItems[newKey] = false
                        }else if newValue == "Holding"{
                            self.parsedHoldingSectionCLItems[newKey] = false
                        }else if newValue == "Vendor"{
                            self.parsedVendorSectionCLItems[newKey] = false
                        }else{
                            self.parsedOtherSectionCLItems[newKey] = false
                        }
                    }
                    
                    
                    // self.LocationsTableView.reloadData()
                    
                    let lazyMapCollection = self.parsedLocationSectionCLItems.keys
                    let lazyMapCollection2 = self.parsedHoldingSectionCLItems.keys
                    let lazyMapCollection3 = self.parsedVendorSectionCLItems.keys
                    let lazyMapCollection4 = self.parsedOtherSectionCLItems.keys
                    
                    
                    let stringArray = Array(lazyMapCollection)
                    
                    self.parsedLocationSectionCLItemsKeys += stringArray
                    
                    
                    let stringArray2 = Array(lazyMapCollection2)
                    
                    self.parsedHoldingSectionCLItemsKeys += stringArray2
                    
                    
                    let stringArray3 = Array(lazyMapCollection3)
                    self.parsedVendorSectionCLItemsKeys += stringArray3
                    
                    
                    let stringArray4 = Array(lazyMapCollection4)
                    self.parsedOtherSectionCLItemsKeys += stringArray4
                    
                    
                    self.checkListTableView.reloadData()
                    //stops Activity Indicator
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
            }
        }
        
        
 
        //self.checkListTableView.reloadData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        let numberOfItems = parsedLocationSectionCLItemsKeys.count + parsedHoldingSectionCLItemsKeys.count + parsedVendorSectionCLItemsKeys.count + parsedOtherSectionCLItemsKeys.count
        
        print("these are how many tasks  there are \( numberOfItems)")
        print("these are how many tasks are complete \( numberComplete)")
       // self.PercentComplete = ((Int (self.numberComplete)) / (Int (numberOfItems)) * 100)
        //print(PercentComplete)
        let test = Double(self.numberComplete) / Double(numberOfItems)
        self.PercentComplete = Int(test * 100)
        print(PercentComplete)
        
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
                
                self.displayAlert("Check List was not saved", error: "Please check internet conection")
                print(error)
                
            }else if let Location = Location {
                Location["LocationSectionCLItems"] = self.parsedLocationSectionCLItems
                Location["HoldingSectionCLItems"] = self.parsedHoldingSectionCLItems
                Location["VendorSectionCLItems"] = self.parsedVendorSectionCLItems
                Location["OtherSectionCLItems"] = self.parsedOtherSectionCLItems
                Location["PercentComplete"] = self.PercentComplete
                Location.saveInBackground(block: { (success, error) in
                    if success == true {
                        
                        //stops Activity Indicator
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        
                        self.displayAlert("Checked items Saved", error: "Your progress has been saved")
                        
                        
                    } else {
                        //stops Activity Indicator
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        
                        self.displayAlert("Could not save Items", error: "Please check conection and try again")
                        
                    }
                    
                })
            }
            
        }
        // self.parsedLocationSectionCLItems.removeAll(keepingCapacity: false)
        // self.parsedHoldingSectionCLItems.removeAll(keepingCapacity: false)
        // self.parsedVendorSectionCLItems.removeAll(keepingCapacity: false)
        // self.parsedOtherSectionCLItems.removeAll(keepingCapacity: false)
    }
    
    //MARK: - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "LOCATION SECTION"
        } else if section == 1 {
            return "HOLDING/ PARKING SECTION"
        }else if section == 2 {
            return "VENDOR SECTION"
        }else {
            return "OTHER SEECTION"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return parsedLocationSectionCLItemsKeys.count
        } else if section == 1 {
            return parsedHoldingSectionCLItemsKeys.count
        }else if section == 2 {
            return parsedVendorSectionCLItemsKeys.count
        }else {
            return parsedOtherSectionCLItemsKeys.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.numberComplete = 0
        var checkListTask = ""
        var taskBoolValue = false
        
        if indexPath.section == 0 {
            if parsedLocationSectionCLItemsKeys.count >= 0 {
            checkListTask = parsedLocationSectionCLItemsKeys.sorted()[indexPath.row]
            taskBoolValue = parsedLocationSectionCLItems[checkListTask]!
            if parsedLocationSectionCLItems[checkListTask]! == true{
                self.numberComplete += 1
                print(numberComplete)
                }
            }
        }else if indexPath.section == 1 {
            if parsedHoldingSectionCLItemsKeys.count >= 0 {
            checkListTask = parsedHoldingSectionCLItemsKeys.sorted()[indexPath.row]
            taskBoolValue = parsedHoldingSectionCLItems[checkListTask]!
            if parsedHoldingSectionCLItems[checkListTask]! == true{
                self.numberComplete += 1
                }
            }
        }else if indexPath.section == 2 {
            if parsedVendorSectionCLItemsKeys.count >= 0 {
            checkListTask = parsedVendorSectionCLItemsKeys.sorted()[indexPath.row]
            taskBoolValue = parsedVendorSectionCLItems[checkListTask]!
            if parsedVendorSectionCLItems[checkListTask]! == true{
                self.numberComplete += 1
                }
            }
        }else if indexPath.section == 3 {
            if parsedOtherSectionCLItemsKeys.count >= 0 {
            checkListTask = parsedOtherSectionCLItemsKeys.sorted()[indexPath.row]
            taskBoolValue = ((parsedOtherSectionCLItems[checkListTask]))!
            if parsedOtherSectionCLItems[checkListTask]! == true{
                self.numberComplete += 1
            }
            }
        }
        
        
        
        let taskcell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CheckListTableViewCell
        
        //cell.textLabel?.text = self.LocationsNames[indexPath.row]
        taskcell.CheckListItemLabel?.text = checkListTask
        taskcell.CheckButtonOutlet.isSelected = taskBoolValue
        // check the value of item
        
        
        
        
        
        
        //MARK: - Check Mark feature
        // This is the bread and butter of the app this is what allows you to check items off your list!!1
        
        // Assign the tap action which will be executed when the user taps the UIButton/ check button
        taskcell.checkAction = { [weak self] (selectedcell) in
            print(taskcell.CheckButtonOutlet.isSelected)
            
            //If the task in not checked this will check the box and save the new value to check list Item array depending on catagory/section
            if taskcell.CheckButtonOutlet.isSelected == false {
                
                // print(tableView.indexPath(for: selectedcell)!.section ,tableView.indexPath(for: selectedcell)!.row)
                
                if tableView.indexPath(for: selectedcell)!.section == 0 {
                    let key = self?.parsedLocationSectionCLItemsKeys.sorted()[tableView.indexPath(for: selectedcell)!.row]
                    self?.parsedLocationSectionCLItems[key!] = true
                    
                }else if tableView.indexPath(for: selectedcell)!.section == 1 {
                    let key = self?.parsedHoldingSectionCLItemsKeys.sorted()[tableView.indexPath(for: selectedcell)!.row]
                    self?.parsedHoldingSectionCLItems[key!] = true
                    
                }else if tableView.indexPath(for: selectedcell)!.section == 2 {
                    let key = self?.parsedVendorSectionCLItemsKeys.sorted()[tableView.indexPath(for: selectedcell)!.row]
                    self?.parsedVendorSectionCLItems[key!] = true
                    
                }else {
                    let key = self?.parsedOtherSectionCLItemsKeys.sorted()[tableView.indexPath(for: selectedcell)!.row]
                    self?.parsedOtherSectionCLItems[key!] = true
                }
                
                //Actually check the Box
                taskcell.CheckButtonOutlet.isSelected = true
                print(self?.parsedLocationSectionCLItems)
                
                
        
                
            } else if taskcell.CheckButtonOutlet.isSelected == true {
                // print(tableView.indexPath(for: selectedcell)!.section ,tableView.indexPath(for: selectedcell)!.row)
                    print("the box was checked but now is not ")
                
                // this is what sets the value of the array
                if tableView.indexPath(for: selectedcell)!.section == 0 {
                    let key = self?.parsedLocationSectionCLItemsKeys.sorted()[tableView.indexPath(for: selectedcell)!.row]
                    self?.parsedLocationSectionCLItems[key!] = false
                    //  print(key)
                }else if tableView.indexPath(for: selectedcell)!.section == 1 {
                    let key = self?.parsedHoldingSectionCLItemsKeys.sorted()[tableView.indexPath(for: selectedcell)!.row]
                    self?.parsedHoldingSectionCLItems[key!] = false
                    
                }else if tableView.indexPath(for: selectedcell)!.section == 2 {
                    let key = self?.parsedVendorSectionCLItemsKeys.sorted()[tableView.indexPath(for: selectedcell)!.row]
                    self?.parsedVendorSectionCLItems[key!] = false
                    
                }else {
                    let key = self?.parsedOtherSectionCLItemsKeys.sorted()[tableView.indexPath(for: selectedcell)!.row]
                    self?.parsedOtherSectionCLItems[key!] = false
                }
                
                
                //Actually check the Box
                taskcell.CheckButtonOutlet.isSelected = false
                print(self?.parsedLocationSectionCLItems)
                //self?.checkListTableView.reloadData()
            }
            
            
            
        }
        return taskcell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(indexPath.row)
        let _:UITableViewCell = tableView.cellForRow(at: indexPath)!
        if indexPath.section == 0 {
            // print("its from location section")
            
            
        } else if indexPath.section == 1{
            // print("its from Holding section")
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        /*
         let settings = UITableViewRowAction(style: .normal, title: "Settings") { action, index in
         print("settings button tapped")
         }
         settings.backgroundColor = .orange
         */
        
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            print("Delete button tapped, the section is \(index.section)")
            print(" the list item is  at \(index.row)")
            
            if index.section == 0 {
                let deletedItem = self.parsedLocationSectionCLItemsKeys.sorted()[index.row]
                self.parsedLocationSectionCLItems.removeValue(forKey: deletedItem)
                print(deletedItem)
                print(self.parsedLocationSectionCLItems)
                
                let lazyMapCollection4 = self.parsedLocationSectionCLItems.keys
                let stringArray4 = Array(lazyMapCollection4)
                self.parsedLocationSectionCLItemsKeys.removeAll()
                self.parsedLocationSectionCLItemsKeys += stringArray4
                
                print(self.parsedLocationSectionCLItems)
                self.checkListTableView.reloadData()
                
            }else if index.section == 1  {
                let deletedItem = self.parsedHoldingSectionCLItemsKeys.sorted()[index.row]
                self.parsedHoldingSectionCLItems.removeValue(forKey: deletedItem)
                print(deletedItem)
                print(self.parsedHoldingSectionCLItems)
                
                let lazyMapCollection4 = self.parsedHoldingSectionCLItems.keys
                let stringArray4 = Array(lazyMapCollection4)
                self.parsedHoldingSectionCLItemsKeys.removeAll()
                self.parsedHoldingSectionCLItemsKeys += stringArray4
                
                
                self.checkListTableView.reloadData()
                
                print(self.parsedHoldingSectionCLItems)
                
            }else if index.section == 2 {
                let deletedItem = self.parsedVendorSectionCLItemsKeys.sorted()[index.row]
                self.parsedVendorSectionCLItems.removeValue(forKey: deletedItem)
                print(deletedItem)
                print(self.parsedVendorSectionCLItems)
                
                let lazyMapCollection4 = self.parsedVendorSectionCLItems.keys
                let stringArray4 = Array(lazyMapCollection4)
                self.parsedVendorSectionCLItemsKeys.removeAll()
                self.parsedVendorSectionCLItemsKeys += stringArray4
                
                
                self.checkListTableView.reloadData()
                
                print(self.parsedVendorSectionCLItems)
                
            }else {
                let deletedItem = self.parsedOtherSectionCLItemsKeys.sorted()[index.row]
                self.parsedOtherSectionCLItems.removeValue(forKey: deletedItem)
                print(deletedItem)
                print(self.parsedOtherSectionCLItems)
                
                let lazyMapCollection4 = self.parsedOtherSectionCLItems.keys
                let stringArray4 = Array(lazyMapCollection4)
                self.parsedOtherSectionCLItemsKeys.removeAll()
                self.parsedOtherSectionCLItemsKeys += stringArray4
                
            
                self.checkListTableView.reloadData()
                print(self.parsedOtherSectionCLItemsKeys)
                print(self.parsedOtherSectionCLItems)
            }
           
        }
        delete.backgroundColor = .red
        
        //self.checkListTableView.reloadData()
        // You still have to implement the delete function***
        //testing if the scource tree is still working
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
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addItemSegue"{
            
            let AddCheckListView = segue.destination as! AddCheckListItemViewController
            AddCheckListView.CurrentLocation = self.CurrentLocation
            AddCheckListView.CurrentProject = self.CurrentProject
            
        }else if segue.identifier == "toLocationInformationSegue"{
            
            let LocationInfoView = segue.destination as! LocationInformationViewController
            LocationInfoView.currentLocation = self.CurrentLocation
            LocationInfoView.CurrentLocationID = self.CurrentLocationID
 
        }else if segue.identifier == "VendorOrderSegue"{
            
            let VendorView = segue.destination as! VendorOrdersViewController
            VendorView.CurrentLocation = self.CurrentLocation
            VendorView.CurrentLocationID = self.CurrentLocationID
            
        }else if segue.identifier == "toChatSegue"{
            
            let ChatView = segue.destination as! chatViewController
            ChatView.CurrentLocation = self.CurrentLocation
            ChatView.CurrentLocationID = self.CurrentLocationID
            
        }
        
    }
 
    
}
