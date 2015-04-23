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
    
    var listingObject : PFObject! // !nil if coming from listing controller, nil otherwise
    var conversationObject : PFObject! // !nil if coming from message controller, nil otherwise
    
    var conversationId : String!
    var messagesArray : [PFObject] = []
    var conversationUsers = [String: PFUser]() // Both users
    
    let currentUserId = PFUser.currentUser()?.objectId
    var conversationPartnerId : String! // The other conversation partner
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
        println("keyboard action")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MessageCell")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        conversationUsers[currentUserId!] = PFUser.currentUser()
        
        if listingObject != nil {
            // Coming from ListingController
            conversationPartnerId = listingObject["UserId"] as? String
            
            // Need to get conversationId from the listing
            var query = PFQuery(className:"Conversation")
            query.whereKey("Listing_ID", equalTo:listingObject.objectId!)
            query.getFirstObjectInBackgroundWithBlock { (conversation, error) -> Void in
                if error == nil {
                    // The find succeeded.
                    self.conversationId = conversation?.objectId!
                    self.getMessages()
                    
                } else if error?.code == 101 {
                    // No such conversation exists - make a new one
                    self.createNewConversation()
                    // no use to call getMessages() here
                } else {
                    println("Error: \(error) \(error!.userInfo!)")
                }
            }
            
        } else if conversationObject != nil {
            // Coming from MessagesController
            conversationId = conversationObject.objectId!
            if conversationObject["User1_ID"] as? String == currentUserId! {
                conversationPartnerId = conversationObject["User2_ID"] as? String
            } else {
                conversationPartnerId = conversationObject["User1_ID"] as? String
            }
            self.getMessages()
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
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messagesArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:MessageCell = tableView.dequeueReusableCellWithIdentifier("MessageCell") as! MessageCell
        let message = messagesArray[indexPath.row]["Message"] as? String
        let senderId = messagesArray[indexPath.row]["Sender_ID"] as? String
        
        let date = messagesArray[indexPath.row].createdAt
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "h:mm a"
        
        cell.messageOutlet.text = message
        cell.usernameOutlet.text = conversationUsers[senderId!]?.username
        cell.timeOutlet.text = dateFormat.stringFromDate(date!)
        return cell
    }
    
    func getMessages(){
        if conversationId != nil {
            var query = PFQuery(className:"Message")
            query.whereKey("Conversation_ID", equalTo:conversationId)
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
    }
    
    func createNewConversation() {
        var conversation = PFObject(className:"Conversation")
        conversation["Listing_ID"] = self.listingObject.objectId
        conversation["User1_ID"] = self.currentUserId
        conversation["User2_ID"] = self.conversationPartnerId
        
        conversation.saveInBackgroundWithBlock { (success, error) -> Void in
            if (success) {
                // The object has been saved.
                self.conversationId = conversation.objectId
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
        }
    }
    
    @IBAction func sendPressed(sender: UIButton) {
        var messageObject = PFObject(className: "Message")
        messageObject["Sender_ID"] = currentUserId
        messageObject["Recipient_ID"] = conversationPartnerId
        messageObject["Conversation_ID"] = conversationId
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
    }
    
}