//
//  SignUpViewController.swift
//  CampusExchange
//
//  Created by Matt on 3/14/15.
//  Copyright (c) 2015 MattOber. All rights reserved.
//

import Foundation
import UIKit
import Parse

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameField : UITextField!
    @IBOutlet weak var emailField : UITextField!
    @IBOutlet weak var phoneNumberField : UITextField!
    @IBOutlet weak var passwordField : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func signUp() {
        let username = self.usernameField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as NSString
        let email = self.emailField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as NSString
        let phoneNumber = self.phoneNumberField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as NSString
        let password = self.passwordField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as NSString
        
        if (username.length == 0 || email.length == 0 || phoneNumber.length == 0 || password.length == 0) {
            //one of the fields was left blank, so we need to display an alert telling the user to fill in all fields
            var alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else{
            var user = PFUser()
            user.username = username
            user.password = password
            user.email = email
            user["phoneNumber"] = phoneNumber
            
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool!, error: NSError!) -> Void in
                if (error == nil) {
                    self.performSegueWithIdentifier("signUpToListings", sender: nil)
                } else {
                    //let errorString = error.userInfo["error"] as NSString
                    // Show the errorString somewhere and let the user try again.
                }
            }
        }
    }
}