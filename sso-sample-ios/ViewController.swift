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
    var userObject: [String:AnyObject]?
    
    // the calling view can inject a closure for when login is completed
    
    var loginCompletion: () -> () = {}

    @IBOutlet weak var loginButton: UIButton!
    
    // the url that triggers the login form - this could be overriden by the value in NSUserDefaults set by an MDM server
    
//    var ssoUrl = "http://test.appdirect.com/oauth/authorize?response_type=token&client_id=EQVRImsj0i"
    var ssoUrl = "http://172.20.5.68:8080/"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // use the notification center to detect when the login was successful
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(safariLogin(_:)), name: "closeSafariLoginView", object: nil)
        
        // fetch the url out of the prefs if it exists
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let value = defaults.stringForKey("login_url") {
            self.ssoUrl = value
        }

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
    
    // called when the controller is initialized
    
    func safariViewController(controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
    }
    
    // called when the controller is closed
    
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        
        controller.dismissViewControllerAnimated(true, completion: nil)
        
        // check to see if we have a valid session
        
        if loginWasSuccessful() {
            
            // call this view's dynamic closure
            
            self.loginCompletion()
            
        } else {
            
            // present the login form in a safari view controller
            
            self.presentViewController(safariViewController!, animated: true, completion: nil)
        }
    }
    
    // called via the web url scheme callback, from AppDelegate
    
    func safariLogin(notification: NSNotification) {
        
//        let url = notification.object as! NSURL
        let url = "user={\"password\"%3A\"*********\"%2C\"userName\"%3A\"kaligan%40gmail.com\"%2C\"authorities\"%3A[{\"authority\"%3A\"ROLE_USER\"}]}"
        
        // this url will contain a token we can use to create our session
        // parse out the token we need here and use it to create the session
        
        userObject = UserObject.jsonFromUrl(withUrl: url)
        
        // finally, dismiss the login view
        
        self.safariViewController!.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    // check to see if we have a session
    
    func loginWasSuccessful() -> Bool {
        
        // in this function we should confirm that the session is valid
        // or that we can create a valid session and return true or
        // false otherwise
        
        if userObject == nil {
            return false
        } else {
            // do some login stuff...
            return true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // clean up our notification observer
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "closeSafariLoginView", object: nil)
    }

}

