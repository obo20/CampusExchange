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
    
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var listingObject : PFObject!
    var conversationObject : PFObject!
    var messagesArray : [PFObject] = []
    
    var conversationUsers = [String: PFUser]()
    var conversationPartnerId : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MessageCell")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if(conversationObject != nil) {
            conversationUsers[PFUser.currentUser()!.objectId!] = PFUser.currentUser()
            
            if conversationObject["User1_ID"] as? String == PFUser.currentUser()!.objectId! {
                conversationPartnerId = conversationObject["User2_ID"] as? String
            } else {
                conversationPartnerId = conversationObject["User1_ID"] as? String
            }
            
            var partnerQuery = PFUser.query()
            partnerQuery?.getObjectInBackgroundWithId(conversationPartnerId, block: { (partner, error) -> Void in
                if error == nil {
                    self.conversationUsers[self.conversationPartnerId] = (partner as! PFUser)
                }
                else {
                    println("Error: \(error) \(error!.userInfo!)")
                }
            })
            
            self.getMessages()
            
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messagesArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:MessageCell = tableView.dequeueReusableCellWithIdentifier("MessageCell") as! MessageCell
        let message = messagesArray[indexPath.row]["Message"] as? String
        let userId = messagesArray[indexPath.row]["Sender_ID"] as? String
        
        let date = messagesArray[indexPath.row].createdAt
        let dateFormat = NSDateFormatter()
        dateFormat.dateStyle = NSDateFormatterStyle.ShortStyle
        
        cell.messageOutlet.text = message
        cell.usernameOutlet.text = conversationUsers[userId!]?.username
        cell.timeOutlet.text = dateFormat.stringFromDate(date!)
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
        
//        code for adding a new conversation when we need to do this.
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