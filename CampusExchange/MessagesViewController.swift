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
                // Reload table data after background query is done
                self.tableView.reloadData()
                
            } else {
                // Log details of the failure
                println("Error: \(error) \(error!.userInfo!)")
            }
        }
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