//
//  SearchListingsViewController.swift
//  CampusExchange
//
//  Created by Matt on 3/14/15.
//  Copyright (c) 2015 MattOber. All rights reserved.
//

import Foundation
import UIKit
import Parse

class SearchListingsViewController: UIViewController {
    
    var searchResults: [PFObject] = []
    @IBOutlet weak var titleField : UITextField!
    @IBOutlet weak var authorField : UITextField!
    @IBOutlet weak var ISBNField : UITextField!
    @IBOutlet weak var courseField : UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func searchBooks(){
        let title = self.titleField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as NSString
        let author = self.authorField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as NSString
        let ISBN = self.ISBNField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as NSString
        let course = self.courseField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as NSString
        var query = PFQuery(className:"Listing")
        // Get listings originally posted with the current user's id
        query.whereKey("Title", containsString: title)
        query.whereKey("Author", containsString: title)
        query.whereKey("ISBN", containsString: title)
        query.whereKey("Course", containsString: title)
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects.count) listings.")
                //clear out the results
                self.searchResults.removeAll(keepCapacity: false)
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        self.searchResults.append(object)
                    }
                }
                // Reload table data after background query is done
                //self.tableView.reloadData()
            } else {
                // Log details of the failure
                println("Error: \(error) \(error.userInfo!)")
            }
        }
    }
    
}