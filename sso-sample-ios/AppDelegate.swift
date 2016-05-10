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
    
    
    // use the openUrl callback to detect when a successful login happens.
    // the website we've connected to should redirect us
    // to a url using our custom scheme and including the security token
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        
        let sourceApplication = options[UIApplicationOpenURLOptionsSourceApplicationKey] as! String
        
        // determine if the calling application is in fact the SafariViewController
        
        if sourceApplication == "com.apple.SafariViewService" {
            
            // close the login view via notification service
            
            NSNotificationCenter.defaultCenter().postNotificationName("closeSafariLoginView", object: url)
            
            return true
        }
        return false

    }
    
}
