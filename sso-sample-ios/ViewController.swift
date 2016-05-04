//
//  ViewController.swift
//  sso-sample-ios
//
//  Created by Mathew Spolin on 5/4/16.
//  Copyright © 2016 AppDirect. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController, SFSafariViewControllerDelegate {
    
    var safariViewController: SFSafariViewController?
    
    var loginCompletion: () -> () = {}

    // the url that trigger the login form
    var ssoUrl = "http://test.appdirect.com/oauth/authorize?response_type=token&client_id=EQVRImsj0i"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(safariLogin(_:)), name: "closeSafariLoginView", object: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func loginTapped(sender: AnyObject) {
        showLogin()
    }

    // create the SafariViewController and present it to the user
    func showLogin() {
        
        let authUrl = NSURL(string: ssoUrl)!
        
        safariViewController = SFSafariViewController(URL: authUrl)
        safariViewController!.delegate = self
        
        self.presentViewController(safariViewController!, animated: true, completion: nil)
    }
    
    // called when the controller is closed
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        
        controller.dismissViewControllerAnimated(true, completion: nil)
        
        if loginWasSuccessful() {
            
            self.loginCompletion()
            
        } else {
            
            self.presentViewController(safariViewController!, animated: true, completion: nil)
        }
    }
    
    // called via the web url scheme callback, from AppDelegate
    func safariLogin(notification: NSNotification) {
        
        let url = notification.object as! NSURL
        
        // the url will have information to complete the login
        // need to parse out the token we need and store it
        
        self.safariViewController!.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    // check to see if we have a valid login session
    func loginWasSuccessful() -> Bool {
        
        // this should confirm that the token we stored is valid
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "closeSafariLoginView", object: nil)
    }

}

