//
//  HomeViewController.swift
//  P105-Home
//
//  Created by Darrin Henein on 2014-10-24.
//  Copyright (c) 2014 Darrin Henein. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, canFetchData {

   var tableController: HomeTableViewController?
    
    
    func fetchData() {
        self.tableController?.getTabs()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let segueName: NSString? = segue.identifier
        
        if segueName == "HomeTableSegue" {
            self.tableController = segue.destinationViewController as? HomeTableViewController
        }
    }

    override func viewDidAppear(animated: Bool) {
        if Login().isLoggedIn() == true {
            fetchData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
        

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
