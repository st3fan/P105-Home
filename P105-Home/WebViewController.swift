//
//  WebViewController.swift
//  P105-Home
//
//  Created by Darrin Henein on 2014-10-22.
//  Copyright (c) 2014 Darrin Henein. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var NavBarTitle: UINavigationItem!
    @IBOutlet weak var webview: UIWebView!
    @IBAction func DoneWasPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBAction func OpenWasPressed(sender: UIBarButtonItem) {
        UIApplication.sharedApplication().openURL(NSURL(string: self.url!)!)
    }
    
    var url:NSString?
    var webTitle:NSString?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fullURL:NSURL! = NSURL(string: self.url!)
        let req:NSURLRequest! = NSURLRequest(URL: fullURL)

        self.webview.loadRequest(req)
        self.NavBarTitle.title = self.webTitle
        // Do any additional setup after loading the view.
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
