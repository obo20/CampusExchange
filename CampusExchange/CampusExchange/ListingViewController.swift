//
//  ListingViewController.swift
//  CampusExchange
//
//  Created by Matt on 3/14/15.
//  Copyright (c) 2015 MattOber. All rights reserved.
//

import Foundation
import UIKit

class ListingViewController: UIViewController {
    
    @IBOutlet weak var titleField : UILabel!
    @IBOutlet weak var authorField : UILabel!
    @IBOutlet weak var ISBNField : UILabel!
    @IBOutlet weak var conditionField : UILabel!
    @IBOutlet weak var priceField : UILabel!
    @IBOutlet weak var courseField : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func searchBooks(){
        NSLog("test")
    }
}