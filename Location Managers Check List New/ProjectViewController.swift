//
//  ProjectViewController.swift
//  Location Managers Check List New
//
//  Created by Zachary Quemore on 7/26/17.
//  Copyright © 2017 Zachary Quemore. All rights reserved.
//

import UIKit
import Parse

class ProjectViewController: UIViewController,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource {
    
    var currentObject = Bool()
    var Projects = [PFObject]()
    var SelectedProject = String()
    var ProjectsTitles = [String]()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet var projectTableView: UITableView!
    //Actions
    @IBAction func addProject(_ sender: Any) {
        performSegue(withIdentifier: "addProjectSegue", sender: self)
    }
    
    @IBAction func logOutBarButtonAction(_ sender: AnyObject) {
        
        if PFUser.current() != nil {
            PFUser.logOut()
            
            performSegue(withIdentifier: "logoutSegue", sender: self)
        }else {
            performSegue(withIdentifier: "logoutSegue", sender: self)
        }
        
        
        
    }
    
    //UI Life Cycle
    
    override func viewDidAppear(_ animated: Bool) {
        self.projectTableView.dataSource = self
        self.projectTableView.delegate = self
        
        
        self.ProjectsTitles.removeAll(keepingCapacity: true)
        self.projectTableView.reloadData()
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor.darkGray
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): UIFont(name: "Holtwood One SC", size: 20)!]
        
        
        //creates an activity maker to tell users that a save is in process
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        // Mark: -  Query
        let userEmail = PFUser.current()?.email!
        //let predicate = NSPredicate(format: "TeamMembers = \(String(describing: userEmail))")
        let query = PFQuery(className: "Project")
        query.whereKey("TeamMembers", contains: userEmail)
        //query?.limit = 10
        
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                
                print("There is a error while searching please check internet connection")
                
                self.displayAlert("Location not found", error: "Please check internet conection")
                
                
                
                print(error)
                
            }else if let objects = objects {
                //print(objects)
                self.Projects.removeAll(keepingCapacity: true)
                for object in objects {
                    self.Projects.append(object)
                    let Title: String = object["Title"] as! String
                    self.ProjectsTitles.append(Title)
                    //print(self.ProjectsTitles)
                    self.projectTableView.reloadData()
                    
                    //stops Activity Indicator
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
                
                
                
                
                //  print(self.StringDistances)
                
                
            }
        }
        
        print(self.ProjectsTitles)
        self.projectTableView.reloadData()
        
        
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        self.projectTableView.reloadData()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    //MARK: - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProjectsTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        //cell.backgroundColor = UIColor.darkGray
        cell.textLabel?.text = self.ProjectsTitles[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        self.SelectedProject = self.ProjectsTitles[indexPath.row]
        self.performSegue(withIdentifier: "ProjectToLocationSegue", sender: self)
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        let settings = UITableViewRowAction(style: .normal, title: "Settings") { action, index in
            print("settings button tapped")
            self.SelectedProject = self.ProjectsTitles[index.row]
            self.performSegue(withIdentifier:"settingsSegue", sender: self)
        }
        settings.backgroundColor = .orange
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            print("Delete button tapped")
            let userEmail = PFUser.current()?.email!
            
            let query = PFQuery(className: "Project")
            query.whereKey("Title", equalTo: self.ProjectsTitles[index.row])
            query.whereKey("TeamMembers", contains: userEmail)
            
            
            
            query.findObjectsInBackground { (objects, error) in
                if error != nil{
                    
                    print("There is a error while searching please check internet connection")
                    
                    self.displayAlert("Location not found", error: "Please check internet conection")
                    print(error)
                    
                }else if let objects = objects {
                    
                    
                    for object in objects {
                        print(object)
                        
                        
                        var teamarray = object["TeamMembers"] as! Array<String?>
                        print("the Team array is \(teamarray)")
                        
                        let userindex = (teamarray.index(where: { $0 == userEmail})) as! Int
                        print(userindex)
                        teamarray.remove(at: userindex)
                        print(teamarray)
                        object["TeamMembers"] = teamarray
                        
                        object.saveInBackground(block: { (success, error) in
                            if error != nil{
                                print(error)
                            }else {
                                self.displayAlert("Project Deleted", error: "Your Name has been removed from Project")
                            }
                        })
                        
                        self.ProjectsTitles.remove(at: index.row)
                        self.projectTableView.reloadData()
                        
                        
                    }
                }
            }
            
            print(index.row)
            self.projectTableView.reloadData()
        }
        delete.backgroundColor = .red
        
        return [settings, delete]
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProjectToLocationSegue"{
            let LocationView = segue.destination as! ProjectLocationsViewController
            LocationView.currentProject = self.SelectedProject
        }else if segue.identifier == "settingsSegue"{
            print("settings fired")
            let addProjectView = segue.destination as! AddProjectViewController
            addProjectView.CurrentProject = SelectedProject
        }
        
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
