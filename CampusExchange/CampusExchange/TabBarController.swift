//
//  TabBarController.swift
//  CampusExchange
//
//  Created by Dylan Laible on 4/21/15.
//  Copyright (c) 2015 MattOber. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "swipeNavigation:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "swipeNavigation:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    func swipeNavigation(gesture: UIGestureRecognizer){
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                let i = self.selectedIndex
                if i == 2 {
                    self.selectedIndex = 0
                } else {
                    self.selectedIndex++
                }
            case UISwipeGestureRecognizerDirection.Left:
                let i = self.selectedIndex
                if i == 0 {
                    self.selectedIndex = 2
                } else {
                    self.selectedIndex--
                }
            default:
                break
            }
        }
        
    }
   
}
