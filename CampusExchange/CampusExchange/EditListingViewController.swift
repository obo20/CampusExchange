//
//  EditListingViewController.swift
//  CampusExchange
//
//  Created by Matt on 3/14/15.
//  Copyright (c) 2015 MattOber. All rights reserved.
//

import Foundation
import UIKit
import Parse

class EditListingViewController: UIViewController {
    
    @IBOutlet weak var titleField : UITextField!
    @IBOutlet weak var authorField : UITextField!
    @IBOutlet weak var ISBNField : UITextField!
    @IBOutlet weak var courseField : UITextField!
    @IBOutlet weak var conditionField : UITextField!
    @IBOutlet weak var priceField : UITextField!
    
    var listingObject : PFObject!
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleField.text = listingObject["Title"] as? String
        self.authorField.text = listingObject["Author"] as? String
        self.ISBNField.text = listingObject["ISBN"] as? String
        self.courseField.text = listingObject["Course"] as? String
        self.conditionField.text = listingObject["Condition"] as? String
        self.priceField.text = listingObject["Price"] as? String
    }
    
    // TODO: Cancel button on edit menu
    
    @IBAction func saveListing() {
        
        let title = self.titleField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as NSString
        let author = self.authorField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as NSString
        let ISBN = self.ISBNField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as NSString
        let course = self.courseField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as NSString
        let condition = self.conditionField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as NSString
        let price = self.priceField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as NSString
        
        var query = PFQuery(className:"Listing")
        query.getObjectInBackgroundWithId(listingObject.objectId!, block: { (listing, error) -> Void in
            if error != nil {
                println(error)
            } else {
                listing!["Title"] = title
                listing!["Author"] = author
                listing!["ISBN"] = ISBN
                listing!["Course"] = course
                listing!["Condition"] = condition
                listing!["Price"] = price
                
                // fix for no .saveInBackground()
                listing!.saveInBackgroundWithTarget(nil, selector: nil)
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        })
    }
    @IBAction func deleteListing(sender: UIButton) {
        var alert = UIAlertController(title: "About to delete listing!", message: "Are you sure you wish to delete this listing?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
            self.listingObject.deleteInBackgroundWithTarget(nil, selector: nil)
            self.navigationController?.popToRootViewControllerAnimated(true)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}