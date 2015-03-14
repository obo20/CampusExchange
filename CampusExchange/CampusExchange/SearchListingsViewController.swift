//
//  SearchListingsViewController.swift
//  CampusExchange
//
//  Created by Matt on 3/14/15.
//  Copyright (c) 2015 MattOber. All rights reserved.
//

import Foundation
import UIKit

class SearchListingsViewController: UIViewController {
    
    @IBOutlet weak var titleField : UITextField!
    @IBOutlet weak var authorField : UITextField!
    @IBOutlet weak var ISBNField : UITextField!
    @IBOutlet weak var courseField : UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func searchBooks(){
        NSLog("test")
    }
}