//
//  TabBarController.swift
//  P105-Home
//
//  Created by Darrin Henein on 2014-10-27.
//  Copyright (c) 2014 Darrin Henein. All rights reserved.
//

import UIKit


@objc protocol canFetchData {
    func fetchData()
}


class TabBarController: UITabBarController, canFetchData, UITabBarControllerDelegate {
 
    override func viewDidAppear(animated: Bool) {
        checkifLoggedIn()
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        checkifLoggedIn()
    }
    
    func checkifLoggedIn() {
        if Login().isLoggedIn() == false {
            self.performSegueWithIdentifier("showLogin", sender: self)
        } else {
            fetchData()
        }
    }
    
    
    func fetchData() {
        if let vc = self.selectedViewController as? canFetchData {
            vc.fetchData()
        }
        
    }
}