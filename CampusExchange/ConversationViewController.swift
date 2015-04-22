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

class ConversationViewController: UIViewController, UITableViewDelegate {
    
    var listingObject : PFObject!
    
    @IBAction func sendPressed(sender: UIButton) {
        let senderId = PFUser.currentUser()!.objectId
        let recipientId = listingObject["UserId"] as? String
        
        var conversation = PFObject(className:"Conversation")
        conversation["Listing_ID"] = listingObject.objectId
        conversation["User1_ID"] = senderId
        conversation["User2_ID"] = recipientId
        
        conversation.saveInBackgroundWithBlock { (success, error) -> Void in
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
        }
        
    }
    
}