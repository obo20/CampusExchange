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
    let currentUser = PFUser.currentUser()

    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.text = currentUser?.email
    }
    
    @IBAction func update() {
        // TODO
    }
    
    @IBAction func logOut() {
        PFUser.logOut()
        self.navigationController?.tabBarController?.dismissViewControllerAnimated(true, completion: nil)
    }

}
