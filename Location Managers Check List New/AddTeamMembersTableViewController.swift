//
//  AddTeamMembersTableViewController.swift
//  Location Managers Check List New
//
//  Created by Zachary Quemore on 7/26/17.
//  Copyright © 2017 Zachary Quemore. All rights reserved.
//

import UIKit
import Parse

class AddTeamMembersTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    var searchController: UISearchController!
    var resultsController = UITableViewController()
    var Usersemail = [String]()
    var filteredUseremails = [String]()
    var TeamMembers = [String]()
    var projectSettings = Bool()
    var CurrentProject = ""
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        // Mark -  Query users
        let query = PFUser.query()
        //query?.limit = 10
        
        query?.findObjectsInBackground { (objects, error) in
            if error != nil{
                
                print("There is a error while searching please check internet connection")
                
                self.displayAlert("Location not found", error: "Please check internet conection")
                
                
                
                print(error)
                
            }else if let objects = objects {
                
                self.Usersemail.removeAll(keepingCapacity: true)
                for object in objects {
                    let email: String = object["email"] as! String
                    
                    self.Usersemail.append(email)
                    
                    self.tableView.reloadData()
                }
                
                
                
                
                
                
                
            }
        }
        
        
        self.tableView.reloadData()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(projectSettings)
        
        
        // seting up members table search functionality
        self.searchController = UISearchController(searchResultsController: self.resultsController)
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchResultsUpdater = self
        definesPresentationContext = true
        
        //seting up results table view
        self.resultsController.tableView.dataSource = self
        self.resultsController.tableView.delegate = self
        
        // messing with the look of the tableviews
        self.tableView.tintColor = UIColor.green
        self.resultsController.view.tintColor = UIColor.green
        self.searchController.view.tintColor = UIColor.green
        searchController.searchBar.placeholder = "Search for Team Members using email"
        searchController.searchBar.setShowsCancelButton(false, animated: true)
        searchController.searchBar.enablesReturnKeyAutomatically = true
        searchController.searchBar.setValue("Done", forKey: "_cancelButtonText")
        self.tableView.backgroundColor = UIColor.darkGray
        self.resultsController.view.backgroundColor = UIColor.darkGray
        //resultsController.searchbar
        
    }
    
    private func searchBarCancelButtonClicked(_ searchBar: UISearchController) {
        print("the cancel button was clicked")
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if tableView == self.tableView {
            return TeamMembers.count
            
        }else {
            return self.filteredUseremails.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let cell = UITableViewCell()
        
        if tableView == self.tableView {
            
            //cell.textLabel?.text = self.Usersemail[indexPath.row]
            cell.textLabel?.text = self.TeamMembers[indexPath.row]
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
            return cell
            
        }else {
            
            cell.textLabel?.text = self.filteredUseremails[indexPath.row]
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
        
        let cell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        
        
        if TeamMembers.contains(filteredUseremails[indexPath.row] as String){
            
            cell.accessoryType = UITableViewCellAccessoryType.none
            print("delete function is running")
            //removes members to team array
            let index = indexPath.row as Int
            let deselectedEmail = filteredUseremails[index] as String
            //isSelected.append(index:index)
            let deleteInt = TeamMembers.index(of: deselectedEmail)!
            TeamMembers.remove(at: deleteInt)
            print(deleteInt)
            
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
            print("add function is running")
            
            
            //adds members to team array
            let index = indexPath.row
            //isSelected.append(index:index)
            TeamMembers.append(filteredUseremails[index])
            print(TeamMembers)
            
        }
        
        self.tableView.reloadData()
      
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        //filter through users
        self.filteredUseremails = self.Usersemail.filter({ (email: String) -> Bool in
            
            if email.lowercased().contains(self.searchController.searchBar.text!.lowercased()){
                return true
            }else {
                
                return false
            }
            
            
        })
        
        
        // update the resaults tableview
        self.resultsController.tableView.reloadData()
    }
    
    
    //Send team mate data to add project controler
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveTeamMembersSegue" {
            print("this should be sending over \(TeamMembers)")
            let AddProjectView = segue.destination as! AddProjectViewController
            AddProjectView.TeamMembers = self.TeamMembers
            AddProjectView.projectSettings = projectSettings
            AddProjectView.CurrentProject = CurrentProject
        }
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
    
    
   
    
    
}

