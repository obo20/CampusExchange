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

class SearchListingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    var searchResults: [PFObject] = []
    @IBOutlet weak var titleField : UITextField!
    @IBOutlet weak var authorField : UITextField!
    @IBOutlet weak var ISBNField : UITextField!
    @IBOutlet weak var courseField : UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "searchResultCell")
    }
    
    @IBAction func searchBooks(){
        let title = self.titleField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as NSString
        let author = self.authorField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as NSString
        let ISBN = self.ISBNField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as NSString
        let course = self.courseField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as NSString
        var query = PFQuery(className:"Listing")
        // Get listings originally posted with the current user's id
        if(title.length > 0)
        {
            query.whereKey("Title", matchesRegex: title as String, modifiers:"i")
        }
        if(author.length > 0)
        {
            query.whereKey("Author", matchesRegex: author as String, modifiers:"i")
        }
        if(ISBN.length > 0)
        {
            query.whereKey("ISBN", matchesRegex: ISBN as String, modifiers:"i")
        }
        if(course.length > 0)
        {
            query.whereKey("Course", matchesRegex: course as String, modifiers:"i")
        }
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) listings.")
                //clear out the results
                self.searchResults.removeAll(keepCapacity: false)
                if objects!.count == 0 {
                    var alert = UIAlertController(title: "Notice:", message: "Sorry, no related listings were found.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        self.searchResults.append(object)
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("searchResultCell") as! UITableViewCell
        
        let title = searchResults[indexPath.row]["Title"] as? String
        let price = searchResults[indexPath.row]["Price"] as? String
        cell.textLabel?.text = "$\(price!) - \(title!)"
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "searchToListing") {
            let listingController = segue.destinationViewController as! ListingViewController
            let selectedIndex = self.tableView.indexPathForSelectedRow()?.row
            listingController.listingObject = searchResults[selectedIndex!]
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("searchToListing", sender: nil)
    }
}