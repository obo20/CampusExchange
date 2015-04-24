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

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameField : UITextField!
    @IBOutlet weak var emailField : UITextField!
    @IBOutlet weak var passwordField : UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
    }
    
    @IBAction func signUp() {
        let username = self.usernameField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as NSString
        let email = self.emailField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as NSString
        let password = self.passwordField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as NSString
        let confirmPassword = self.confirmPasswordField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as NSString
        
        if (username.length == 0 || email.length == 0 || password.length == 0 || confirmPassword.length == 0) {
            //one of the fields was left blank, so we need to display an alert telling the user to fill in all fields
            var alert = UIAlertController(title: "Missing Fields!", message: "Please be sure to fill in every field to sign up.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else if(!(password.isEqualToString(confirmPassword as String)))
        {
            var alert = UIAlertController(title: "Passwords Don't Match!", message: "Please make sure your passwords match", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else{
            var user = PFUser()
            user.username = username as String
            user.password = password as String
            user.email = email as String
            
            user.signUpInBackgroundWithBlock { (succeeded, error) -> Void in
                if (error == nil || succeeded == true) {
                    self.performSegueWithIdentifier("signUpToLogin", sender: nil)
                } else {
                    var errorString = "undefined error"
                    if let userError = error!.userInfo {
                        errorString = userError["error"] as! String
                    }
                    var alert = UIAlertController(title: "Error:", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
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