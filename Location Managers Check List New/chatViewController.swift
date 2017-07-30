//
//  chatViewController.swift
//  Location Managers Check List New
//
//  Created by Zachary Quemore on 7/29/17.
//  Copyright © 2017 Zachary Quemore. All rights reserved.
//

import UIKit
import Parse

class chatViewController: UIViewController,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource {
  
    
    
    var CurrentLocation = ""
    var CurrentProject = ""
    var CurrentLocationID = ""
    var ParsedChats = [PFObject]()
    var ChatSender = [String]()
    var ChatMessage = [String]()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var chatTableView: UITableView!
    @IBAction func sendMessageBtn(_ sender: Any) {
        sendMessage()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.chatTableView.dataSource = self
        self.chatTableView.delegate = self
        
        
        
        
       

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ParsedChats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var pfobject = PFObject()
        var username = ""
        var message = ""
        
        pfobject = self.ParsedChats[indexPath.row]
        username = pfobject["sender"] as! String
        message = pfobject["message"] as! String
        
        
        
        
        let chatCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! chatTableViewCell
        
        
        chatCell.userNameLabel.text = username
        chatCell.messageLabel.text = message
        // check the value of item
        return chatCell
    }
    
    func sendMessage() {
        //creates an activity maker to tell users that a save is in process
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let query = PFQuery(className: "Chat")
        
        query.getObjectInBackground(withId:CurrentLocationID){
            (Chat, error) in
            if error != nil{
                
                print("There is a error while searching please check internet connection")
                
                self.displayAlert("The Chat function is not working", error: "Please check internet conection")
                print(error)
                
            }else if let Chat = Chat {
                Chat["sender"] = PFUser.current()!.username
                Chat["Message"] = self.messageTextField.text
                Chat["LocationID"] = self.CurrentLocationID
                
                
                Chat.saveInBackground(block: { (success, error) in
                    if success == true {
                        
                        //stops Activity Indicator
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        
                        self.chatTableView.reloadData()
                        
                        
                    } else {
                        //stops Activity Indicator
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        
                        self.displayAlert("Could not send message", error: "Please check conection and try again")
                        
                    }
                    
                })
            }
            
        }
        //after this quote the bracket is the end of funtion
    }
    
    
    func LoadMessages() {
        // Mark: -  Query
        
        let query = PFQuery(className: "Chat")
        query.whereKey("LocationID", equalTo: CurrentLocationID)
        query.order(byAscending: "createdAt")
        
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                
                print("There is a error while searching please check internet connection")
                
                self.displayAlert("Check list not found", error: "Please check internet conection")
                print(error)
                
            }else if let objects = objects {
                
                
                for object in objects {
                    
                    var sender = object ["sender"] as! String
                    var message = object ["Message"] as! String
                    
                    self.ParsedChats.append(object)
                    
                    
                
                    }
                
                    
                    self.chatTableView.reloadData()
                    //stops Activity Indicator
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
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
