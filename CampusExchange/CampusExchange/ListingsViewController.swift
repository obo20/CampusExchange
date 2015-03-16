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
    
    var currentUserListings : [PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var query = PFQuery(className:"Listing")
        // Get listings originally posted with the current user's id
        query.whereKey("UserId", equalTo:PFUser.currentUser().objectId)
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects.count) listings.")
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        self.currentUserListings.append(object)
                    }
                }
                // Reload table data after background query is done
                self.tableView.reloadData()
            } else {
                // Log details of the failure
                println("Error: \(error) \(error.userInfo!)")
            }
        }
        
//        var currentUser = PFUser.currentUser()
//        var currentUserId = currentUser.objectId
//        var query = PFQuery(className:"Listing")
//        query.whereKey("UserID", equalTo:currentUserId)
//        //query.whereKey("ListingStatus", equalTo: "1")
//        query.findObjectsInBackgroundWithBlock {
//            (objects: [AnyObject]!, error: NSError!) -> Void in
//            if error == nil {
//                // The find succeeded.
//                println("Successfully retrieved \(objects.count) scores.")
//                // Do something with the found objects
//                if let objects = objects as? [PFObject] {
//                    for object in objects {
//                        println(object.objectId)
//                    }
//                }
//            }
//            else {
//                // Log details of the failure
//                println("Error: \(error) \(error.userInfo!)")
//            }
//        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUserListings.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myListingsCell", forIndexPath: indexPath) as UITableViewCell
        
        // Just testing this condition out
        if currentUserListings[indexPath.row]["ListingStatus"] as? Int != 1 {
            cell.textLabel?.textColor = UIColor.redColor()
        }
        
        let title = currentUserListings[indexPath.row]["Title"] as? String
        let price = currentUserListings[indexPath.row]["Price"] as? String
        cell.textLabel!.text = "\(title!) - $\(price!)"
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "myListingsToEditListing") {
            let editController = segue.destinationViewController as EditListingViewController
            let selectedIndex = self.tableView.indexPathForSelectedRow()?.row
            editController.listingId = currentUserListings[selectedIndex!].objectId
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("myListingsToEditListing", sender: nil)
    }
    
}