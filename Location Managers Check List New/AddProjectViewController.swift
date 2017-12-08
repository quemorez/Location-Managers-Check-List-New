//
//  AddProjectViewController.swift
//  Location Managers Check List New
//
//  Created by Zachary Quemore on 7/26/17.
//  Copyright © 2017 Zachary Quemore. All rights reserved.
//

import UIKit
import Parse

var savedTitle = ""
var CurrentProjectID = ""

class AddProjectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var CurrentLocation = ""
    var CurrentProject = ""
    var projectSettings = Bool()
    var TeamMembers = [String]()
    //var CurrentProjectID = ""
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var error:String = ""
    
    // searcg controler
    var searchControler : UISearchController!
    
    //outlets
    @IBOutlet var projectTitleTextField: UITextField!
    @IBOutlet var savebutton: UIButton!
    
    @IBOutlet var teamMembersTableView: UITableView!
    
    @IBOutlet var addTeamMemberButtonOutlet: UIButton!
    
    
    
    
    //Actions
    @IBAction func titleAction(_ sender: UITextField) {
        savedTitle = projectTitleTextField.text!
    }
    
    @IBAction func AddTeamMemberButtonAction(_ sender: Any) {
        
        self.performSegue(withIdentifier: "AddTeamMembersSegue", sender: self)
        
        
    }
    
    
    
    
    @IBAction func saveProjectTitle(_ sender: Any) {
        
        // There is something wrong with this function, I think you need to check to see if you are coming from the settings before you querry anything put all querries inside that if statement.
        projectTitleTextField.endEditing(true)
        
        if projectTitleTextField.text == "" {
            error = "Please type in projects title"
        }
        
        if error != ""{
            
            displayAlert("Error In Form", error: error)
            
            
        } else {
            
            
            //creates an activity maker to tell users that a save is in process
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            
            if projectSettings == false {
                // Mark: -  Query Before Save
                
                let query = PFQuery(className: "Project")
                query.whereKey("Title", equalTo: projectTitleTextField.text!.uppercased() as String)
                //query.whereKey("Title", contains: projectTitleTextField.text! as String)
                
                
                query.findObjectsInBackground { (objects, error) in
                    
                    if error != nil{
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        print("There is a error while searching please check internet connection")
                        
                        self.displayAlert("We cannot save Project", error: "Please check internet conection")
                        print(error)
                        
                    } else if let objects = objects {
                        
                        if self.projectSettings == false {
                            if objects.count > 0 {
                                self.activityIndicator.stopAnimating()
                                UIApplication.shared.endIgnoringInteractionEvents()
                                self.displayAlert("There is a Project with same title", error: "Please Change name of Project or contact the Location Manager and have your email added to project")
                                self.projectTitleTextField.text? = ""
                            }else {
                                let Project = PFObject(className: "Project")
                                Project["Title"] = self.projectTitleTextField.text!.uppercased() as String
                                Project["Creater"] = PFUser.current()?.username!
                                self.TeamMembers.removeAll()
                                self.TeamMembers.append((PFUser.current()?.email!)!)
                                Project["TeamMembers"] = self.TeamMembers
                                let acl = PFACL()
                                acl.getPublicReadAccess = true
                                acl.getPublicWriteAccess = true
                                PFACL.setDefault(acl, withAccessForCurrentUser: true)
                                Project.saveInBackground(block: { (success, error) in
                                    if success == true {
                                        self.TeamMembers.removeAll()
                                        self.CurrentProject.removeAll()
                                        
                                       // self.projectSettings = false
                                        self.performSegue(withIdentifier: "ProjectSavedSeque", sender: self)
                                        //stops Activity Indicator
                                        self.activityIndicator.stopAnimating()
                                        UIApplication.shared.endIgnoringInteractionEvents()
                                        
                                        self.displayAlert("Project Saved", error: "get started by adding locations to your project")
                                        
                                        
                                        //Segue to Project list
                                        
                                        
                                    } else {
                                        //stops Activity Indicator
                                        self.activityIndicator.stopAnimating()
                                        UIApplication.shared.endIgnoringInteractionEvents()
                                        
                                        self.displayAlert("Could not save Project", error: "Please check conection and try again")
                                        
                                    }
                                    
                                })
                            }
                        }
                    }
                }
                
            }else {
                // Mark: -  Settings Save area
                print("the settings code is running")
                print("the current project ID is \(CurrentProjectID)")
                // Getting object and saving updates
                let query = PFQuery(className: "Project")
                query.getObjectInBackground(withId: CurrentProjectID, block: { (Project, error) in
                    if error != nil {
                        print("its saving")
                        
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        print("There is a error while searching please check internet connection")
                        
                        self.displayAlert("We cannot Update Project", error: "Please check internet conection and try again")
                        print(error as Any)
                    } else if let updatedProject = Project {
                        print(updatedProject)
                        print("its saving")
                        updatedProject["Title"] = self.projectTitleTextField.text!.uppercased() as String
                        updatedProject["Creater"] = PFUser.current()?.username!
                        //self.TeamMembers.append((PFUser.current()?.email!)!)
                        updatedProject["TeamMembers"] = self.TeamMembers
                        let acl = PFACL()
                        acl.getPublicReadAccess = true
                        acl.getPublicWriteAccess = true
                        PFACL.setDefault(acl, withAccessForCurrentUser: true)
                        
                        updatedProject.saveInBackground(block: { (success, error) in
                            if success == true {
                                self.TeamMembers.removeAll()
                                self.CurrentProject.removeAll()
                                
                                //self.projectSettings = false
                                //Segue to Project list
                                self.performSegue(withIdentifier: "ProjectSavedSeque", sender: self)
                                //stops Activity Indicator
                                self.activityIndicator.stopAnimating()
                                UIApplication.shared.endIgnoringInteractionEvents()
                                
                                self.displayAlert("Project Updated", error: "Two Points for keeping things up to date")
                                
                                
                                
                                
                                
                            } else {
                                //stops Activity Indicator
                                self.activityIndicator.stopAnimating()
                                UIApplication.shared.endIgnoringInteractionEvents()
                                //self.projectSettings = false
                                self.displayAlert("Could not update Project", error: "Please check conection and try again")
                                
                            }
                        })
                    }
                })
            }
        }
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(CurrentProject)
        print(projectSettings)
        if CurrentProject != ""{
            projectTitleTextField.text = CurrentProject
            
            
            let query = PFQuery(className: "Project")
            query.whereKey("Title", equalTo: projectTitleTextField.text!.uppercased() as String)
            //query.whereKey("Title", contains: projectTitleTextField.text! as String)
            
            
            query.findObjectsInBackground { (objects, error) in
                
                if error != nil{
                    self.activityIndicator.stopAnimating()
                    //UIApplication.shared.endIgnoringInteractionEvents()
                    print("There is a error while searching please check internet connection")
                    
                    self.displayAlert("No Project found", error: "Please check internet conection")
                    print(error as Any)
                    
                } else if let objects = objects {
                    for object in objects {
                        CurrentProjectID = object.objectId!
                        
                        let teammembers = object["TeamMembers"] as! [String]
                        for teammember in teammembers {
                            
                            self.TeamMembers.append(teammember)
                            //print(self.TeamMembers)
                            //self.projectSettings = true
                            self.teamMembersTableView.reloadData()
                        }
                        
                    }
                }
            }
            
            
            
            
            self.teamMembersTableView.reloadData()
        }
        
        if savedTitle != "" {
            projectTitleTextField.text = savedTitle
        }
        
        //seting up the look of the UI
        projectTitleTextField.layer.cornerRadius = 10
        projectTitleTextField.clipsToBounds = true
        savebutton.layer.cornerRadius = 10
        savebutton.clipsToBounds = true
        addTeamMemberButtonOutlet.layer.cornerRadius = 10
        addTeamMemberButtonOutlet.clipsToBounds = true
        
        
        
        
        // seting up members table
        teamMembersTableView.dataSource = self
        teamMembersTableView.delegate = self
        teamMembersTableView.tintColor = UIColor.green
        teamMembersTableView.backgroundColor = UIColor.darkGray
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(CurrentProject)
        print(projectSettings)
        
        self.TeamMembers.removeAll()
        for teamMember in TeamMembers {
            if teamMember != (PFUser.current()?.email!)!{
                self.TeamMembers.append(teamMember)
            }
        }
        print(CurrentProject)
        if CurrentProject != ""{
            projectTitleTextField.text = CurrentProject
            savedTitle = CurrentProject
            
            
            let query = PFQuery(className: "Project")
            query.whereKey("Title", equalTo: projectTitleTextField.text!.uppercased() as String)
            //query.whereKey("Title", contains: projectTitleTextField.text! as String)
            
            
            query.findObjectsInBackground { (objects, error) in
                
                if error != nil{
                    self.activityIndicator.stopAnimating()
                    //UIApplication.shared.endIgnoringInteractionEvents()
                    print("There is a error while searching please check internet connection")
                    
                    self.displayAlert("No Project found", error: "Please check internet conection")
                    print(error as Any)
                    
                } else if let objects = objects {
                    for object in objects {
                        CurrentProjectID = object.objectId!
                        print(CurrentProjectID)
                        let teammembers = object["TeamMembers"] as! [String]
                        for teammember in teammembers {
                            
                            self.TeamMembers.append(teammember)
                            //print(self.TeamMembers)
                           // self.projectSettings = true
                            self.teamMembersTableView.reloadData()
                        }
                        
                    }
                }
            }
            
            
            
            
            self.teamMembersTableView.reloadData()
            
            
        }
        
        if savedTitle != "" {
            projectTitleTextField.text = savedTitle
        }

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TeamMembers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.darkGray
        cell.textLabel?.text = self.TeamMembers[indexPath.row]
        cell.accessoryType = UITableViewCellAccessoryType.checkmark
        return cell
    }
    
    
    //Helper Methiods
    //this function creats and alert that you can display errors with
    func displayAlert(_ title:String,error:String){
        
        let alert = UIAlertController(title:title, message: error, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            //self.dismiss(animated: true, completion: nil)
            
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
