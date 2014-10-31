//
//  ShareViewController.swift
//  BookmarkWithFirefox
//
//  Created by Stefan Arentz (Mozilla) on 2014-10-30.
//  Copyright (c) 2014 Darrin Henein. All rights reserved.
//

import UIKit
import Social
import Alamofire

class ShareViewController: SLComposeServiceViewController, NSURLSessionDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func isContentValid() -> Bool {
        return true
    }

    override func didSelectPost() {
        
        let login = Login()
        
        if login.isLoggedIn() {
            
            if let inputItems : [NSExtensionItem] = self.extensionContext!.inputItems as? [NSExtensionItem] {
                
                let item = inputItems[0]
                
                if let attachments = item.attachments as? [NSItemProvider] {
                    
                    if attachments.isEmpty {
                        self.extensionContext!.completeRequestReturningItems(nil, completionHandler: nil)
                        return
                    }
                    
                    attachments[0].loadItemForTypeIdentifier("public.url", options:nil, completionHandler: { (obj, error) in
                        if let u = obj as? NSURL {
                            let url = u.absoluteString
                            let title = self.textView.text

                            println("There we go!")
                            let credentials = Login().getKeychainUser(login.getUsername())
                            
                            let request = NSMutableURLRequest(URL: NSURL(string: "https://moz-syncapi.sateh.com/1.0/bookmarks")!)
                            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                            request.addValue("application/json", forHTTPHeaderField: "Accept")
                            request.HTTPMethod = "POST"
                            
                            var object = NSMutableDictionary()
                            object["url"] = url
                            object["title"] = title
                            
                            var jsonError: NSError?
                            let data = NSJSONSerialization.dataWithJSONObject(object, options: nil, error: &jsonError)
                            if data != nil {
                                println(data)
                                request.HTTPBody = data
                            }
                            
                            print("We're good")
                            
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
                            
                            self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
                            
                        }
                        self.extensionContext!.completeRequestReturningItems(nil, completionHandler: nil)
                    })
                    
                }
                
            }

        }
        
//        let login = Login()
//        println("Hello!")
//        if login.isLoggedIn() {
//            println("There we go!")
//            let credentials = Login().getKeychainUser(login.getUsername())
//            
//            let url = NSURL(string: "https://moz-syncapi.sateh.com/1.0/bookmarks")
//            let request = NSMutableURLRequest(URL: url!)
//            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.addValue("application/json", forHTTPHeaderField: "Accept")
//            request.HTTPMethod = "POST"
//            
//            var item : NSExtensionItem = self.extensionContext!.inputItems[0] as NSExtensionItem
//            var itemProvider : NSItemProvider = item.attachments[0] as NSItemProvider
//            
//            if itemProvider.hasItemConformingToTypeIdentifier("public.url") {
//                itemProvider.loadItemForTypeIdentifier("public.url", options: nil, completionHandler: { (urlItem, error) in
//                    var urlString = urlItem.absoluteString
//
//                    var object = NSMutableDictionary()
//                    object["url"] = "http://www.apple.ca"
//                    object["title"] = "Welcome to Apple, eh!"
//                    
//                    var jsonError: NSError?
//                    let data = NSJSONSerialization.dataWithJSONObject(object, options: nil, error: &jsonError)
//                    if data != nil {
//                        println(data)
//                        request.HTTPBody = data
//                    }
//                    
//                    print("We're good")
//                    
//                    let userPasswordString = "\(credentials.username!):\(credentials.password!)"
//                    let userPasswordData = userPasswordString.dataUsingEncoding(NSUTF8StringEncoding)
//                    let base64EncodedCredential = userPasswordData!.base64EncodedStringWithOptions(nil)
//                    let authString = "Basic \(base64EncodedCredential)"
//                    
//                    let configuration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("com.P105-Home.BackgroundUpload")
//                    configuration.HTTPAdditionalHeaders = ["Authorization" : authString]
//                    configuration.sharedContainerIdentifier = "group.P105-Home"
//                    
//                    let session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
//                    let task = session.dataTaskWithRequest(request)
//                    task.resume()
//                })
//            }
//
//            self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
//        }
    }

    override func configurationItems() -> [AnyObject]! {
        return NSArray()
    }
}
