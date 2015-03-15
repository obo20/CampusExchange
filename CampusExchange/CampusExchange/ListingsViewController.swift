//
//  ListingsViewController.swift
//  CampusExchange
//
//  Created by Matt on 3/14/15.
//  Copyright (c) 2015 MattOber. All rights reserved.
//

import Foundation
import UIKit
import Parse

class ListingsViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var currentUser = PFUser.currentUser()
        var currentUserId = currentUser.objectId
        var query = PFQuery(className:"Listing")
        query.whereKey("UserID", equalTo:currentUserId)
        //query.whereKey("ListingStatus", equalTo: "1")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects.count) scores.")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        println(object.objectId)
                    }
                }
            }
            else {
                // Log details of the failure
                println("Error: \(error) \(error.userInfo!)")
            }
        }
    }

    
}