//
//  AppDelegate.swift
//  sso-sample-ios
//
//  Created by Mathew Spolin on 5/4/16.
//  Copyright © 2016 AppDirect. All rights reserved.
//

import UIKit
import AppAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var currentAuthorizationFlow: OIDAuthorizationFlowSession?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    /*! @fn application:openURL:options:
     @brief Handles inbound URLs. Checks if the URL matches the redirect URI for a pending
     AppAuth authorization request.
     */
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        // Sends the URL to the current authorization flow (if any) which will process it if it relates to
        // an authorization response.
        if currentAuthorizationFlow?.resumeAuthorizationFlowWithURL(url) == true {
            currentAuthorizationFlow = nil
            return true
        }
        
        return false
    }
}
