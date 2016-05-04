//
//  AppDelegate.swift
//  sso-sample-ios
//
//  Created by Mathew Spolin on 5/4/16.
//  Copyright © 2016 AppDirect. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        return true
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        
        let sourceApplication = options[UIApplicationOpenURLOptionsSourceApplicationKey] as! String
        
        if sourceApplication == "com.apple.SafariViewService" {
            NSNotificationCenter.defaultCenter().postNotificationName("closeSafariLoginView", object: url)
            
            return true
        }
        return false

    }
    
}
