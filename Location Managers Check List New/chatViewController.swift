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
    var Chatdate = [String]()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var chatTableView: UITableView!
    @IBAction func sendMessageBtn(_ sender: Any) {
        if messageTextField.text == "" {
            self.displayAlert("message is blank", error: "Please write something first")
            messageTextField.text = ""
        }else {
            sendMessage()
            messageTextField.text = ""
            LoadMessages()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.chatTableView.dataSource = self
        self.chatTableView.delegate = self
        
        
        LoadMessages()
        
        
       

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ParsedChats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let chatCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! chatTableViewCell
        
        
        chatCell.userNameLabel.text = self.ChatSender[indexPath.row]
        chatCell.messageLabel.text = self.ChatMessage[indexPath.row]
        chatCell.dateTimeLabel.text = self.Chatdate[indexPath.row]
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
        
        let Chat = PFObject(className: "Chat")
            Chat["sender"] = PFUser.current()!.username
            Chat["Message"] = self.messageTextField.text
            Chat["LocationID"] = self.CurrentLocationID
            Chat.saveInBackground(block: { (success, error) in
                    if success == true {
                        
                        //stops Activity Indicator
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        self.LoadMessages()
                        //self.chatTableView.reloadData()
                        
                        
                    } else {
                        //stops Activity Indicator
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        
                        self.displayAlert("Could not send message", error: "Please check conection and try again")
                        
                    }
                    
                })
        
            
    
        //after this quote the bracket is the end of funtion
    }
    
    
    func LoadMessages() {
        // Mark: -  Query
        ChatMessage.removeAll()
        ChatSender.removeAll()
        
        let query = PFQuery(className: "Chat")
        query.whereKey("LocationID", equalTo: CurrentLocationID)
        query.order(byAscending: "createdAt")
        
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
                
                self.ParsedChats.removeAll(keepingCapacity: true)
                for object in objects {
                    self.ParsedChats.append(object)
                    print(object.createdAt! as NSDate)
                    
                    let sender: String = object["sender"] as! String
                    let message: String = object["Message"] as! String
                    let dateAndTime: NSDate = object.createdAt! as NSDate
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss"
                    let StringDate = dateFormatter.string(from: dateAndTime as Date)
                    
                    
                    
                    self.ChatSender.append(sender)
                    self.ChatMessage.append(message)
                    self.Chatdate.append(StringDate)
                    
                    //print(self.ProjectsTitles)
                    self.chatTableView.reloadData()
                    
                }
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
