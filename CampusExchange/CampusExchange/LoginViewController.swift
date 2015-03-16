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

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameField : UITextField!
    @IBOutlet weak var passwordField : UITextField!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        var currentUser = PFUser.currentUser()
        if (currentUser != nil) {
            // Do stuff with the user
            println("Logged in as \(currentUser.username)")
            self.performSegueWithIdentifier("loginToListings", sender: nil)
        }
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
            PFUser.logInWithUsernameInBackground(username, password:password) {
                (user: PFUser!, error: NSError!) -> Void in
                if (user != nil) {
                    self.performSegueWithIdentifier("loginToListings", sender: nil)
                }
                else {
                    var errorString = "undefined error"
                    if let userError = error.userInfo {
                        errorString = userError["error"] as NSString
                    }
                    var alert = UIAlertController(title: "Error: ", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
    }
}