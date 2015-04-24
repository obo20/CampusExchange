//
//  LoginViewController.swift
//  CampusExchange
//
//  Created by Matt on 3/14/15.
//  Copyright (c) 2015 MattOber. All rights reserved.
//

import Foundation
import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameField : UITextField!
    @IBOutlet weak var passwordField : UITextField!
    
    
    override func viewDidLoad()
    {
        usernameField.delegate = self
        passwordField.delegate = self
    }
    //sets the fields to blank after logging out
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.usernameField.text = ""
        self.passwordField.text = ""
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        var currentUser = PFUser.currentUser()
        if (currentUser != nil) {
            // Do stuff with the user
            println("Logged in as \(currentUser!.username)")
            self.performSegueWithIdentifier("loginToListings", sender: nil)
        }
    }
    
    @IBAction func forgotPassword() {
        var alert = UIAlertController(title: "Forgot Password?", message: "Enter your email to have a password reset link sent to you.", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.text = "Email address"
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Reset Password", style: .Default, handler: { (action) -> Void in
            let emailField = alert.textFields![0] as! UITextField
            if !emailField.text.isEmpty {
                PFUser.requestPasswordResetForEmailInBackground(emailField.text, block: { (success, error) -> Void in
                    if (success) {
                        // The object has been saved.
                        var alert = UIAlertController(title: "Success", message: "Your reset password link has been sent.", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    } else {
                        // There was a problem, check error.description
                        var errorString = "undefined error"
                        if let userError = error!.userInfo {
                            errorString = userError["error"] as! String
                        }
                        var alert = UIAlertController(title: "Error:", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                })
            }
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func logIn() {
        let username = self.usernameField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as NSString
        let password = self.passwordField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as NSString
        
        if (username.length == 0 || password.length == 0) {
            //either the username or password was left blank, so we need to display an alert telling the user to fill in all fields
            var alert = UIAlertController(title: "Missing Fields!", message: "Both your username and password are needed to log in.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else{
            PFUser.logInWithUsernameInBackground(username as String, password:password as String, block: { (user, error) -> Void in
                if (user != nil) {
                    self.performSegueWithIdentifier("loginToListings", sender: nil)
                }
                else {
                    var errorString = "undefined error"
                    if let userError = error!.userInfo {
                        errorString = userError["error"] as! String
                    }
                    var alert = UIAlertController(title: "Error: ", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    // MARK: KEYBOARD CONTROLS
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if (textField.text.isEmpty)
        {
            return false
        }
        return true
    }
}