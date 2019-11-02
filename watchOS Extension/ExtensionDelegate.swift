//
//  ExtensionDelegate.swift
//  watchOS Extension
//
//  Created by Pawan Badsewal on 11/03/19.
//  Copyright © 2019 Pawan Badsewal. All rights reserved.
//

import WatchKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {

    
    
    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
    }

    func applicationDidBecomeActive() {
        WKInterfaceController.reloadRootControllers(withNames: ["LaunchIC"], contexts: ["LaunchIC"])
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        WKInterfaceController.reloadRootControllers(withNames: ["IdleIC"], contexts: ["IdleIC"])
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

}
