//
//  ConversationViewController.swift
//  CampusExchange
//
//  Created by Matt on 4/21/15.
//  Copyright (c) 2015 MattOber. All rights reserved.
//

import Foundation
import UIKit
import Parse

class ConversationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var listingObject : PFObject!
    var conversationObject : PFObject!
    var conversationPartner : PFUser!
    var messagesArray : [PFObject] = []
    var conversationPartnerId : NSString!
    @IBOutlet weak var messageField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MessageCell")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if(conversationObject != nil)
        {
            if(conversationObject["User1_ID"]!.isEqualToString(PFUser.currentUser()!.objectId!))
            {
                conversationPartnerId = conversationObject["User2_ID"] as! NSString
            }
            else if(conversationObject["User2_ID"]!.isEqualToString(PFUser.currentUser()!.objectId!))
            {
                conversationPartnerId = conversationObject["User1_ID"] as! NSString
            }
            self.getMessages()
            
            //this is the code that for some reason won't allow us to load in the User for the conversation partner
            //        var query = PFQuery(className:"User")
            //        query.getObjectInBackgroundWithId(conversationPartnerId, block: { (partner:PFObject, error: NSError?) -> Void in
            //            if error != nil {
            //                println(error)
            //            }
            //            else
            //            {
            //                self.conversationPartner = partner as! PFUser
            //            }
            //        })
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messagesArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:MessageCell = tableView.dequeueReusableCellWithIdentifier("MessageCell") as! MessageCell
        let message = messagesArray[indexPath.row]["Message"] as? String
        cell.messageOutlet.text = message
        return cell
    }
    
    func getMessages(){
        var query = PFQuery(className:"Message")
        // Get listings originally posted with the current user's id
        query.whereKey("Conversation_ID", equalTo:conversationObject.objectId!)
        query.orderByAscending("createdAt")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) messages.")
                self.messagesArray.removeAll(keepCapacity: false)
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        self.messagesArray.append(object)
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
    
    @IBAction func sendPressed(sender: UIButton) {
        let senderId = PFUser.currentUser()!.objectId

        var messageObject = PFObject(className: "Message")
        messageObject["Sender_ID"] = senderId
        messageObject["Recipient_ID"] = conversationPartnerId
        messageObject["Conversation_ID"] = conversationObject.objectId
        messageObject["Message"] = messageField.text as NSString
        
        messageObject.saveInBackgroundWithBlock { (success, error) -> Void in
            if (success) {
                // The object has been saved.
            
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
            self.messagesArray.append(messageObject)
            self.messageField.text = ""
            self.tableView.reloadData()
        }
        //code for adding a new conversation when we need to do this.
//        var conversation = PFObject(className:"Conversation")
//        conversation["Listing_ID"] = listingObject.objectId
//        conversation["User1_ID"] = senderId
//        conversation["User2_ID"] = recipientId
//        
//        conversation.saveInBackgroundWithBlock { (success, error) -> Void in
//            if (success) {
//                // The object has been saved.
//                
//                
//            } else {
//                // There was a problem, check error.description
//                var errorString = "undefined error"
//                if let userError = error!.userInfo {
//                    errorString = userError["error"] as! String
//                }
//                var alert = UIAlertController(title: "Error:", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
//                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
//                self.presentViewController(alert, animated: true, completion: nil)
//            }
//        }
    }
    
}