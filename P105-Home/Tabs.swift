//
//  Tabs.swift
//  P105-Home
//
//  Created by Darrin Henein on 2014-10-22.
//  Copyright (c) 2014 Darrin Henein. All rights reserved.
//

import UIKit


class Tab
{
    var title: String
    var url: String
    init(title: String, url: String) {
        self.title = title
        self.url = url
    }
}

class TabClient
{
    var name: String
    var tabs: [Tab] = []
    init(name: String) {
        self.name = name
    }
}

class TabsResponse: NSObject
{
    var clients: [TabClient] = []
    func clearTabs() {
        clients = []
    }
}

func parseTabsResponse(response: AnyObject?) -> TabsResponse {
    let tabsResponse = TabsResponse()
    if let response: NSArray = response as? NSArray {
        for client in response {
            let tabClient = TabClient(name: client.valueForKey("clientName") as String)
            if let tabs = client.valueForKey("tabs") as? NSArray {
                for tab in tabs {
                    var title = ""
                    var url = ""
                    if let t = tab.valueForKey("title") as? String {
                        title = t
                    }
                    if let u = tab.valueForKey("urlHistory") as? NSArray {
                        if u.count > 0 {
                            url = u[0] as String
                        }
                    }
                    tabClient.tabs.append(Tab(title: title, url: url))
                }
            }
            tabsResponse.clients.append(tabClient)
        }
    }
    return tabsResponse
}