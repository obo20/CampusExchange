//
//  SettingsViewController.swift
//  CampusExchange
//
//  Created by Dylan Laible on 4/22/15.
//  Copyright (c) 2015 MattOber. All rights reserved.
//

import UIKit
import Parse

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    let currentUser = PFUser.currentUser()
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.text = currentUser?.email
        phoneNumberField.text = currentUser!["phoneNumber"] as! String
    }
    
    @IBAction func update() {
        
        let email = self.emailField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as NSString
        let phoneNumber = self.phoneNumberField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as NSString
        
        if (email.length == 0 || phoneNumber.length == 0) {
            var alert = UIAlertController(title: "Invalid Fields!", message: "You cannot leave any of these fields blank.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            
            currentUser?.email = email as? String
            currentUser!["phoneNumber"] = phoneNumber as? String
            
            currentUser?.saveInBackgroundWithBlock({ (success, error) -> Void in
                if (success) {
                    var alert = UIAlertController(title: "Success", message: "Your information has been updated.", preferredStyle: UIAlertControllerStyle.Alert)
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
        
    }
    
    @IBAction func logOut() {
        PFUser.logOut()
        self.navigationController?.tabBarController?.dismissViewControllerAnimated(true, completion: nil)
    }

}
