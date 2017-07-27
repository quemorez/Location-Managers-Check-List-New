//
//  ViewController.swift
//  Location Managers Check List New
//
//  Created by Zachary Quemore on 7/25/17.
//  Copyright © 2017 Zachary Quemore. All rights reserved.
//

import UIKit
import Parse
import QuartzCore

class ViewController: UIViewController {

    // Class wide Variables/ set up Variables
    
    var signupMode = true
    var activityIndicator = UIActivityIndicatorView()
    
    
    
    @IBOutlet weak var logo: UIImageView!
    
    @IBOutlet weak var instructionLabel: UILabel!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var alreadySignedUpLabel: UILabel!
    
    @IBOutlet weak var logInSignUptoggleButton: UIButton!
    
    @IBOutlet weak var signUpLogInButton: UIButton!
    
    
    //Helper Methiods/ Functions
    
    // Alert Function
    
    func creatAlert(_ title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func anonymousAlert(_ title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:
            {
                [unowned self] (action) -> Void in
                
                self.performSegue(withIdentifier: "anonymousLogInSegue", sender: self)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    // IBActions for the buttons
    
    @IBAction func logInSignUptoggleButtonAction(_ sender: AnyObject) {
        // All the logic of switching back and forth between Log In and Sign Up Mode
        
        if signupMode {
            //change to Login Mode
            
            logInSignUptoggleButton.setTitle("Sign Up", for: [])
            
            signUpLogInButton.setTitle("Log In", for: [])
            
            alreadySignedUpLabel.text = "Dont have an Account?"
            
            instructionLabel.text = "please use form below to Log In"
            
            emailTextField.isHidden = true
            
            signupMode = false
            
        }else {
            // change to Signup Mode
            
            
            logInSignUptoggleButton.setTitle("Log In", for: [])
            
            signUpLogInButton.setTitle("Sign Up", for: [])
            
            alreadySignedUpLabel.text = "Already signed up? "
            
            instructionLabel.text = "please use form below to sign up"
            
            emailTextField.isHidden = false
            
            signupMode = true
        }
        
    }
    
    
    
    @IBAction func signUpLogInButtonAction(_ sender: AnyObject) {
        
        if  signupMode {
            
            // Checking if the person filled out all the fields in sign up mode
            
            if emailTextField.text == "" || usernameTextField.text == "" || passwordTextField.text == "" {
                
                creatAlert("Error In Form", message: "Please fill in all fields")
                
            } else {
                // Signing the user Up
                
                
                //Activity Indicator code
                activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                activityIndicator.center = self.view.center
                activityIndicator.hidesWhenStopped = true
                activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
                view.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                UIApplication.shared.beginIgnoringInteractionEvents()
                
                
                //Creating user and signing them up in BG
                let user = PFUser()
                
                user.username = usernameTextField.text
                user.password = passwordTextField.text
                user.email = emailTextField.text
                
                user.signUpInBackground(block: { (success, error) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    
                    if error != nil {
                        
                        let error = error as NSError?
                        var displayErrorMessage = "Please Try again Later."
                        
                        if let errorMessage = error?.userInfo["error"] as? String {
                            
                            displayErrorMessage = errorMessage
                            
                        }
                        
                        self.creatAlert("Signup Error", message: displayErrorMessage)
                        
                    } else {
                        
                        print("user signed up")
                        
                        
                        self.performSegue(withIdentifier: "segueToProjectVC", sender: self)
                        
                    }
                    
                    
                })
                
            }
            
            
        }else {
            
            // Checking if the person filled out all the fields in Log in mode
            
            
            if usernameTextField.text == "" || passwordTextField.text == "" {
                
                creatAlert("Error in form", message: "Please enter and username and Password")
                
            }else {
                //Log In User
                
                PFUser.logInWithUsername(inBackground: usernameTextField.text!, password: passwordTextField.text!, block: { (user, error) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if error != nil {
                        
                        let error = error as NSError?
                        var displayErrorMessage = "Please Try again Later."
                        
                        if let errorMessage = error?.userInfo["error"] as? String {
                            
                            displayErrorMessage = errorMessage
                            
                        }
                        
                        self.creatAlert("Log In Error", message: displayErrorMessage)
                        
                        
                    }else {
                        
                        
                        print("Logged In")
                        
                        self.performSegue(withIdentifier: "segueToProjectVC", sender: self)
                        
                        
                    }
                })
                
                
                
                
            }
            
        }
        
    }
    
    @IBAction func AnonymousLogInAction(_ sender: Any) {
        
        anonymousAlert("Anonymous Log In", message: "By logging in anonymously some features of this app are disabled. This is to ensure the ingertity of our information. For full access to all content please create an account")
        
        // self.performSegue(withIdentifier: "anonymousLogInSegue", sender: self)
    }
    
    // Life Cycle of the UI
    
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil {
            // print(PFUser.current())
            performSegue(withIdentifier: "segueToProjectVC", sender: self)
            // self.performSegue(withIdentifier: "segueToProjectVC", sender: self)
            
        }
        
        self.navigationController?.navigationBar.isHidden = true
        
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        usernameTextField.layer.cornerRadius = 20
        usernameTextField.clipsToBounds = true
        passwordTextField.layer.cornerRadius = 20
        passwordTextField.clipsToBounds = true
        emailTextField.layer.cornerRadius = 20
        emailTextField.clipsToBounds = true
        signUpLogInButton.layer.cornerRadius = 10
        signUpLogInButton.clipsToBounds = true
        
        //print("its still working")
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Get the New View Controller
        //println(lotData)
        if (segue.identifier == "anonymousLogInSegue") {
            // pass data to next view
            
            let nav = segue.destination as! UINavigationController
            let AnonymousScene = nav.topViewController as! ProjectViewController
            
            
            
            //pass the selected object to the destination view controler
            //if let indexPath = self.indexPathForSelectedRow(){
            //  let row = Int(indexPath.row)
            AnonymousScene.currentObject = true
            
            
            
        }
    }

}

