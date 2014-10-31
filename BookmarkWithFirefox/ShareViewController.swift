//
//  ShareViewController.swift
//  BookmarkWithFirefox
//
//  Created by Stefan Arentz (Mozilla) on 2014-10-30.
//  Copyright (c) 2014 Darrin Henein. All rights reserved.
//

import UIKit
import Social


class ShareDestinationsViewController: UITableViewController {

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let titles = ["Send to Unsorted Bookmarks", "Add to my Reading List", "Send to my Home Screen"]
        cell.textLabel.text = titles[indexPath.row]
        return cell
    }
}



struct SharedBookmark {
    var url: String
    var title: String
}

class ShareViewController: SLComposeServiceViewController, NSURLSessionDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.backgroundColor = UIColor.orangeColor()
        
        // This is a pretty bad back - because it seems navigationItem.titleView does not work :-( - So how does Evernote do it?
        let navigationBar: UINavigationBar = view.subviews[2].subviews[2] as UINavigationBar
        let logo = UIImageView(image: UIImage(named: "flat-logo"))
        logo.frame = CGRect(x: navigationBar.frame.width/2-32, y: 6, width: 32, height: 32)
        navigationBar.addSubview(logo)
    }
    
    override func isContentValid() -> Bool {
        return true
    }

    func shareBookmark(bookmark: SharedBookmark, credentials: Credentials) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://moz-syncapi.sateh.com/1.0/bookmarks")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.HTTPMethod = "POST"
        
        var object = NSMutableDictionary()
        object["url"] = bookmark.url
        object["title"] = bookmark.title
        
        var jsonError: NSError?
        let data = NSJSONSerialization.dataWithJSONObject(object, options: nil, error: &jsonError)
        if data != nil {
            println(data)
            request.HTTPBody = data
        }
        
        let userPasswordString = "\(credentials.username!):\(credentials.password!)"
        let userPasswordData = userPasswordString.dataUsingEncoding(NSUTF8StringEncoding)
        let base64EncodedCredential = userPasswordData!.base64EncodedStringWithOptions(nil)
        let authString = "Basic \(base64EncodedCredential)"
        
        let configuration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("com.P105-Home.BackgroundUpload")
        configuration.HTTPAdditionalHeaders = ["Authorization" : authString]
        configuration.sharedContainerIdentifier = "group.P105-Home"

        let session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        let task = session.dataTaskWithRequest(request)
        task.resume()
        
//        let configuration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("com.P105-Home.BackgroundUpload")
//        configuration.sharedContainerIdentifier = "group.P105-Home"
//        let manager = Alamofire.Manager(configuration: configuration)
//        
//        let params = ["url": bookmark.url, "title": bookmark.title]
//        manager.request(.POST, NSURL(string: "https://moz-syncapi.sateh.com/1.0/bookmarks")!, parameters: params, encoding: .JSON)
//            .authenticate(user: credentials.username!, password: credentials.password!)
    }
    
    func fetchSharedURL(completionHandler: (NSURL!, NSError!) -> Void) {
        if let inputItems : [NSExtensionItem] = self.extensionContext!.inputItems as? [NSExtensionItem] {
            let item = inputItems[0]
            if let attachments = item.attachments as? [NSItemProvider] {
                attachments[0].loadItemForTypeIdentifier("public.url", options:nil, completionHandler: { (obj, error) in
                    completionHandler(obj as? NSURL, error)
                })
            }
        }
    }
    
    override func didSelectPost() {
        let login = Login()
        if login.isLoggedIn() {
            fetchSharedURL({ (url, error) -> Void in
                if url != nil {
                    let sharedBookmark = SharedBookmark(url: url.absoluteString!, title: self.textView.text)
                    let credentials = Login().getKeychainUser(login.getUsername())
                    self.shareBookmark(sharedBookmark, credentials: credentials)
                    self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
                }
            })
        }
    }

    override func configurationItems() -> [AnyObject]! {
        
        let item = SLComposeSheetConfigurationItem()
        item.title = "Send to Unsorted Bookmarks"
        item.tapHandler = {
            self.pushConfigurationViewController(ShareDestinationsViewController())
        }
        
        return [item]
    }
    
    override func loadPreviewView() -> UIView! {
        return nil
    }
}
