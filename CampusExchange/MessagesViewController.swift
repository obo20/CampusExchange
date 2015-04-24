//
//  MessagesViewController.swift
//  CampusExchange
//
//  Created by Matt on 4/21/15.
//  Copyright (c) 2015 MattOber. All rights reserved.
//

import Foundation
import UIKit
import Parse

class MessagesViewController: UITableViewController {
    
    var currentUserConversations : [PFObject] = []
    var usersForCells : [PFUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        var query1 = PFQuery(className:"Conversation")
        var query2 = PFQuery(className:"Conversation")
        // Gets the list of conversations a user is a part of
        query1.whereKey("User1_ID", equalTo:PFUser.currentUser()!.objectId!)
        query2.whereKey("User2_ID", equalTo:PFUser.currentUser()!.objectId!)
        var query = PFQuery.orQueryWithSubqueries([query1,query2])
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) conversations.")
                self.currentUserConversations.removeAll(keepCapacity: false)
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        self.currentUserConversations.append(object)
                    }
                }
                let partners = self.setPartners()
                self.queryForPartners(partners)
                
            } else {
                // Log details of the failure
                println("Error: \(error) \(error!.userInfo!)")
            }
        }
    }
    
    //this function querys for the partners you're conversing with, so we can utilize their names in the table cells
    func queryForPartners(partnerIds : [NSString])
    {
        
        var query = PFQuery(className: "User")
        
        var tempArrayOfObjects : [PFObject] = []
        for partnerId in partnerIds
        {
            var partner: PFUser = PFUser.objectWithoutDataWithObjectId(partnerId as String)
            //partner.objectForKey(partnerId as String)
            //partner.objectId = partnerId as String
            tempArrayOfObjects.append(partner)
        }
        PFUser.fetchAllInBackground(tempArrayOfObjects, block: { (objects, error) -> Void in
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) Users.")
                self.usersForCells.removeAll(keepCapacity: false)
                if let objects = objects as? [PFUser] {
                    for object in objects {
                        self.usersForCells.append(object)
                    }
                }
                
            } else {
                // Log details of the failure
                println("Error: \(error) \(error!.userInfo!)")
            }
            self.tableView.reloadData()
        })
    }
    
    //this function creates an array of Users that the user is messaging with
    func setPartners() -> [NSString]
    {
        var partnerIds : [NSString] = []
        for conversation in self.currentUserConversations
        {
            if(conversation["User1_ID"] as? String == PFUser.currentUser()!.objectId!)
            {
                partnerIds.append(conversation["User2_ID"] as! NSString)
                
            }
            else if(conversation["User2_ID"] as? String == PFUser.currentUser()!.objectId!)
            {
                partnerIds.append(conversation["User1_ID"] as! NSString)
            }
        }
        return partnerIds
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUserConversations.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myConversationCell", forIndexPath: indexPath) as! UITableViewCell
        
        let title = currentUserConversations[indexPath.row]["Listing_ID"] as? String
        cell.textLabel!.text = "\(title!)"
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("messagesToConversation", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "messagesToConversation") {
            let conversationController = segue.destinationViewController as! ConversationViewController
            let selectedIndex = self.tableView.indexPathForSelectedRow()?.row
            conversationController.conversationObject = currentUserConversations[selectedIndex!]
        }
    }
}