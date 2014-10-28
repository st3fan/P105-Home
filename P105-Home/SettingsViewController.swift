//
//  SettingsViewController.swift
//  P105-Home
//
//  Created by Darrin Henein on 2014-10-24.
//  Copyright (c) 2014 Darrin Henein. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, canFetchData {

    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var usernameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoutButton.addTarget(self, action: Selector("logoutPressed"), forControlEvents: UIControlEvents.TouchUpInside)
        // Do any additional setup after loading the view.
    }
    
    func updateStrings() {
        usernameLabel.text = Login().getUsername()
        var buttonText: NSString = "Login"
        if Login().isLoggedIn() == true {
            buttonText = "Logout"
        }
        self.logoutButton.titleLabel?.text = buttonText
    }
    
    func fetchData() {
        updateStrings()
    }
    
    override func viewDidAppear(animated: Bool) {
        updateStrings()
    }
    
    func logoutPressed() {
        Login().logout()
        updateStrings()
        UIApplication.sharedApplication().keyWindow?.rootViewController?.performSegueWithIdentifier("showLogin", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
