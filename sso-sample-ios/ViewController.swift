//
//  ViewController.swift
//  sso-sample-ios
//
//  Created by Mathew Spolin on 5/4/16.
//  Copyright © 2016 AppDirect. All rights reserved.
//

import UIKit
import SafariServices

protocol ViewControllerDelegate {
    func loginWasSccessful(userObject: UserObject)
    func logoutWasSccessful()
}

class ViewController: UIViewController, SFSafariViewControllerDelegate, ViewControllerDelegate {
    
    var safariViewController: SFSafariViewController?
    var userObject: UserObject?
    var delegate: ViewControllerDelegate?
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    // the url that triggers the login form - this could be overriden by the value in NSUserDefaults set by an MDM server
    
    var ssoUrl = "http://isv-ad.us-west-2.elasticbeanstalk.com/account/2/saml/login/?redirect=sso-sample://return/"
    
    // the url that triggers the server logout
    
    var logoutUrl = "https://test.appdirect.com/logout"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // use the notification center to detect when the login was successful
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(safariLogin(_:)), name: "closeSafariLoginView", object: nil)
        
        // fetch the url out of the prefs if it exists
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let value = defaults.stringForKey("login_url") {
            self.ssoUrl = value
        }
        
        self.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginTapped(sender: AnyObject) {
        if loginButton.titleLabel?.text == "Log In" {
            showLogin()
        } else {
            showLogout()
        }
    }
    
    // create the SafariViewController and present it to the user
    
    func showLogin() {
        
        let authUrl = NSURL(string: ssoUrl)!
        
        safariViewController = SFSafariViewController(URL: authUrl)
        safariViewController!.delegate = self
        
        // present the login form in a safari view controller
        
        self.presentViewController(safariViewController!, animated: true, completion: nil)
    }
    
    func showLogout() {
        
        let authLogoutUrl = NSURL(string: logoutUrl)!
        
        safariViewController = SFSafariViewController(URL: authLogoutUrl)
        safariViewController!.delegate = self
        
        // present the login form in a safari view controller
        
        self.presentViewController(safariViewController!, animated: true, completion: nil)
    }
    
    // called when the controller is initialized
    
    func safariViewController(controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
    }
    
    // called when the controller is closed
    
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        
        controller.dismissViewControllerAnimated(true, completion: nil)
        
        // User has ended session
        // Destroy the local user object and call this view's delegate's closure
        
        userObject = nil
        
        delegate?.logoutWasSccessful()
        
        loginButton.setTitle("Log In", forState: .Normal)
    }
    
    // called via the web url scheme callback, from AppDelegate
    
    func safariLogin(notification: NSNotification) {
        
        let url = notification.object as! NSURL
        
        // this url will contain a token we can use to create our session
        // parse out the token we need here and use it to create the session
        
        userObject = UserObject.objectFromUrl(url.absoluteString)
        
        // check to see if we have a valid session
        
        if loginWasSuccessful() {
            
            // call this view's delegate's closure
            
            delegate?.loginWasSccessful(userObject!)
            
            loginButton.setTitle("Log Out", forState: .Normal)
            
        } else {
            
            // The response URL was not properly formatted, we can't build an auth token
        }
        
        // finally, dismiss the login view
        
        self.safariViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // check to see if we have a session
    
    func loginWasSuccessful() -> Bool {
        
        // in this function we should confirm that the session is valid
        // or that we can create a valid session and return true or
        // false otherwise
        
        if userObject != nil {
            
            // We got a valid, properly formatted response from the server to build a token
            
            return true
        }
        
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // clean up our notification observer
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "closeSafariLoginView", object: nil)
    }
    
    // Custom callback handler on successful login
    // These delegate handlers would typically be external
    
    func loginWasSccessful(userObject: UserObject) {
        
        if let userName = userObject.info["username"] as? String {
            
            statusLabel.text = "You have logged in with user name " + userName
        }
    }
    
    func logoutWasSccessful() {
        
        statusLabel.text = "You are not logged in..."
    }
}

