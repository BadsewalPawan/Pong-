//
//  LaunchIC.swift
//  watchOS
//
//  Created by Pawan Badsewal on 26/04/19.
//  Copyright © 2019 Pawan Badsewal. All rights reserved.
//

import UIKit
import WatchKit
import Foundation



class LaunchIC: WKInterfaceController {
    var timer:Timer!
    
    @objc func segue(){
        //presentController(withName: "GameIC", context: ["GameIC"])
        WKInterfaceController.reloadRootControllers(withNames: ["GameIC"], contexts: ["GameIC"])
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
    }
    override func didAppear() {
        super.didAppear()
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(segue), userInfo: nil, repeats: false)
    }
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
