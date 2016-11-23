//
//  AppDelegate.swift
//  VideostreamClient
//
//  Created by PC on 11/18/16.
//  Copyright © 2016 Randel Smith rs@randelsmith.com. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        ConfigManger.jsonResourceName = "jsonConfig"
        
        return true
    }

}

