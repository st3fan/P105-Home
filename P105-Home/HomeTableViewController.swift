//
//  HomeTableViewController.swift
//  P105-Home
//
//  Created by Darrin Henein on 2014-10-21.
//  Copyright (c) 2014 Darrin Henein. All rights reserved.
//

import UIKit
import Alamofire


class HomeTableViewController: UITableViewController {
    
    var tabs: TabsResponse!
    var rc: UIRefreshControl!
    var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 49 is height of tabbar
        self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 49, 0.0)
        self.clearTabs()
        
        self.rc = UIRefreshControl()

        self.rc.backgroundColor = UIColor.orangeColor()
        self.rc.tintColor = UIColor.whiteColor()
        
        let refreshText: NSAttributedString = NSAttributedString(string: "Pull to Refresh", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        self.rc.attributedTitle = refreshText
        
        self.rc.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.rc)
        
        self.spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        self.spinner.center = self.tableView.center
        self.spinner.hidesWhenStopped = true
        self.tableView.addSubview(self.spinner)
        self.spinner.startAnimating()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        if let t = self.tabs {
            return t.clients.count
        } else {
            return 0
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if let t = self.tabs {
            let client: TabClient! = t.clients[section]
            return client.tabs.count
        } else {
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("URLCell", forIndexPath: indexPath) as UITableViewCell
        
        let tab: Tab! = self.tabs.clients[indexPath.section].tabs[indexPath.row]
        
        var title = cell.viewWithTag(1) as? UILabel
        title?.text = tab.title
        
        var url = cell.viewWithTag(2) as? UILabel
        url?.text = tab.url as NSString
        
        var meta = cell.viewWithTag(3) as? UILabel
        meta?.text = self.tabs.clients[0].name as NSString
        

        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let objects = UINib(nibName: "HomeTableHeader", bundle: nil).instantiateWithOwner(nil, options: nil)
        let view = objects[0] as? UIView
        
        if let label = view?.viewWithTag(1) as? UILabel {
            if self.tabs != nil {
                label.text = self.tabs.clients[section].name.uppercaseString
            }
        }
        
        return view
    }
    
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }

    
    func refresh(sender: AnyObject) {
        self.getTabs()
    }
    
    func clearTabs() {
        self.tabs?.clearTabs()
    }
    
    func getTabs() {
        let syncTabs = "https://syncapi-dev.sateh.com/1.0/tabs"
        
        var syncUser: Credentials!
        syncUser = Login().getKeychainUser(Login().getUsername())
        
        Alamofire.request(.GET, syncTabs, parameters: nil)
            .authenticate(user: syncUser.username!, password: syncUser.password!)
            .responseJSON { (res, req, data, error) in
                
                self.tabs = parseTabsResponse(data)
                
                self.rc.endRefreshing()
                self.spinner.stopAnimating()

                self.tableView.reloadData()

            }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let webview = segue.destinationViewController as WebViewController
        let indexPath = self.tableView.indexPathForSelectedRow() as NSIndexPath!
        webview.url = self.tabs.clients[indexPath.section].tabs[indexPath.row].url
        webview.webTitle = self.tabs.clients[indexPath.section].tabs[indexPath.row].title
    }

}
