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

class ConversationViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    var listingObject : PFObject! // !nil if coming from listing controller, nil otherwise
    var conversationObject : PFObject! // !nil if coming from message controller, nil otherwise
    var conversationId : String!
    var messagesArray : [PFObject] = []
    var messagesArrayLastCount : NSInteger = 0
    var conversationUsers = [String: PFUser]() // Both users
    let currentUserId = PFUser.currentUser()?.objectId
    var conversationPartnerId : String! // The other conversation partner
    var chatTimer: NSTimer?
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
        println("keyboard action")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageField.delegate = self
        //notifications that the keyboard is going up or down
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
        //timer that refreshes the chat every 5 seconds
        chatTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("chatRefresh"), userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(animated: Bool) {
        //we want to stop the chat from refreshing once the view leaves
        chatTimer!.invalidate()
    }
    
    func chatRefresh()
    {
        self.getMessages()
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
                self.tableView.reloadData()
            }
            else {
                println("Error: \(error) \(error!.userInfo!)")
            }
        })
        
    }
    // MARK: TABLE RELATED FUNCTIONS
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
    
    //this scrolls to the bottom row of the chat table
    func scrollToBottom()
    {
        var indexPath = NSIndexPath(forRow: (messagesArray.count - 1), inSection: 0)
        self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
    }
    // MARK: KEYBOARD CONTROLS
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if (textField.text.isEmpty)
        {
            return false
        }
        return true
    }
    
    func keyboardWasShown(notification: NSNotification)
    {
        NSLog("hi")
        let info: NSDictionary = notification.userInfo!
        let keyboardSize: CGSize = info.objectForKey(UIKeyboardFrameBeginUserInfoKey)?.CGRectValue().size as CGSize!
        self.view.frame.origin.y -= (keyboardSize.height - 49)
    }
    
    func keyboardWillBeHidden(notification: NSNotification)
    {
        NSLog("hi")
        let info: NSDictionary = notification.userInfo!
        let keyboardSize: CGSize = info.objectForKey(UIKeyboardFrameBeginUserInfoKey)?.CGRectValue().size as CGSize!
        self.view.frame.origin.y = 0//(keyboardSize.height - 49)
    }
    
    // MARK: OTHER
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
                    //if the counts aren't the same as the last time, we have a new message to show, so we need to scroll to the latest message.
                    if(self.messagesArray.count != self.messagesArrayLastCount)
                    {
                        self.scrollToBottom()
                        self.messagesArrayLastCount = self.messagesArray.count
                    }
                }
                else
                {
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
        if(messageField.text.isEmpty)
        {
            return
        }
        
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
            self.scrollToBottom()
        }
    }
    
}