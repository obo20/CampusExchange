//
//  ListingViewController.swift
//  CampusExchange
//
//  Created by Matt on 3/14/15.
//  Copyright (c) 2015 MattOber. All rights reserved.
//

import Foundation
import UIKit
import Parse

class ListingViewController: UIViewController {
    
    var listingObject : PFObject!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var authorOutlet: UILabel!
    @IBOutlet weak var ISBNOutlet: UILabel!
    @IBOutlet weak var conditionOutlet: UILabel!
    @IBOutlet weak var priceOutlet: UILabel!
    @IBOutlet weak var courseOutlet: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleOutlet.text = listingObject["Title"] as? String
        self.authorOutlet.text = listingObject["Author"] as? String
        self.ISBNOutlet.text = listingObject["ISBN"] as? String
        self.courseOutlet.text = listingObject["Course"] as? String
        self.conditionOutlet.text = listingObject["Condition"] as? String
        self.priceOutlet.text = listingObject["Price"] as? String
        self.courseOutlet.text = listingObject["Course"] as? String
    }
    @IBAction func contactSeller(sender: UIButton) {
        var userQuery = PFUser.query()
        var userIdForListing = listingObject["UserId"] as? String
        userQuery.getObjectInBackgroundWithId(userIdForListing){
            (user: PFObject!, error: NSError!) -> Void in
            if error == nil {
                var emailAddress = user["email"] as String
                var phoneNumber = user["phoneNumber"] as String
                var alert = UIAlertController(title: "Contact Information", message: "Email: \(emailAddress) \n Phone: \(phoneNumber)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
            else {
                println("Error: \(error) \(error.userInfo!)")
            }
        }

        
    }
}