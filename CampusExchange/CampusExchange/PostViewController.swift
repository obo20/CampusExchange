//
//  PostViewController.swift
//  CampusExchange
//
//  Created by Matt on 3/14/15.
//  Copyright (c) 2015 MattOber. All rights reserved.
//

import Foundation
import UIKit
import Parse

class PostViewController: UIViewController {
    
    @IBOutlet weak var titleField : UITextField!
    @IBOutlet weak var authorField : UITextField!
    @IBOutlet weak var ISBNField : UITextField!
    @IBOutlet weak var courseField : UITextField!
    @IBOutlet weak var conditionField : UITextField!
    @IBOutlet weak var priceField : UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func addListing() {
        
        let title = self.titleField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as NSString
        let author = self.authorField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as NSString
        let ISBN = self.ISBNField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as NSString
        let course = self.courseField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as NSString
        let condition = self.conditionField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as NSString
        let price = self.priceField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as NSString
        
        if (title.length == 0 || author.length == 0 || ISBN.length == 0 || course.length == 0 || condition.length == 0 || price.length == 0) {
            //one of the fields was left blank, so we need to display an alert telling the user to fill in all fields
            var alert = UIAlertController(title: "Missing Fields!", message: "Please be sure to fill in every field to post a listing.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            var listing = PFObject(className:"Listing")
            listing["UserId"] = PFUser.currentUser()!.objectId
            listing["Title"] = title
            listing["Author"] = author
            listing["ISBN"] = ISBN
            listing["Course"] = course
            listing["Condition"] = condition
            listing["Price"] = price
            listing["ListingStatus"] = 1
            listing.saveInBackgroundWithBlock { (success, error) -> Void in
                if (success) {
                    // The object has been saved.
                    self.navigationController?.popToRootViewControllerAnimated(true)
                    
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
}