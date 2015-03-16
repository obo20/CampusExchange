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
    
    var listingId : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var query = PFQuery(className:"Listing")
        query.getObjectInBackgroundWithId(listingId) {
            (listing: PFObject!, error: NSError!) -> Void in
            if error != nil {
                println(error)
            } else {
                self.titleField.text = listing["Title"] as? String
                self.authorField.text = listing["Author"] as? String
                self.ISBNField.text = listing["ISBN"] as? String
                self.courseField.text = listing["Course"] as? String
                self.conditionField.text = listing["Condition"] as? String
                self.priceField.text = listing["Price"] as? String
            }
        }
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
        query.getObjectInBackgroundWithId(listingId) {
            (listing: PFObject!, error: NSError!) -> Void in
            if error != nil {
                println(error)
            } else {
                listing["Title"] = title
                listing["Author"] = author
                listing["ISBN"] = ISBN
                listing["Course"] = course
                listing["Condition"] = condition
                listing["Price"] = price
                
                // fix for no .saveInBackground()
                listing.saveInBackgroundWithTarget(nil, selector: nil)
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        }
    }
}