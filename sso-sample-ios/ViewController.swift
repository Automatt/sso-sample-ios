//
//  ViewController.swift
//  sso-sample-ios
//
//  Created by Mathew Spolin on 5/4/16.
//  Copyright © 2016 AppDirect. All rights reserved.
//

import UIKit
import AppAuth

protocol ViewControllerDelegate {
    func loginWasSccessful(userObject: UserObject)
    func logoutWasSccessful()
}

class ViewController: UIViewController, ViewControllerDelegate {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var userObject: UserObject?
    var delegate: ViewControllerDelegate?
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    // OAuth2 config parameters - this will be dependent on your server implementation.
    // We're using an AppDirect test marketplace as our primary identity provider in this example.
    // You should replace these with your primary OAuth2 identity provider, even if AppDirect is a downstream IDP
    
    var clientId = "A1Ih7ZUhAl"
    var redirectUrl = "com.appdirect.myapps://home:443/"
    var authorizationEndpoint = "https://marketplace.appdirect.com/oauth/authorize"
    var tokenEndpoint = "https://myapps.appdirect.com/api/authentication/channels/appdirect/authorize"
    
    //  AppConfig config parameters - we expect these configurations to be set by an MDM server
    //  and made available to our app via the standardUserDefaults mechanism.
    
    var isvAccountId = "1234"   // unique identifier provided by vendor system when the subscription was created
    var isvUserId = "5678"      // unique identifier for the user in the vendor service
    var companyId = "91011"      // unique identifier for the marketplace company that purchased the subscription
    var marketplaceUrl = "https://marketplace.appdirect.com" // base url for the marketplace
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // fetch the OAuth2 config out of the MDM
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let  isvAccountId = defaults.stringForKey("com.appdirect.isv.accountid"),
                isvUserId = defaults.stringForKey("com.appdirect.isv.userid"),
                companyId = defaults.stringForKey("com.appdirect.companyid"),
                marketplaceUrl = defaults.stringForKey("com.appdirect.marketplace.url") {
            
            self.isvAccountId = isvAccountId
            self.isvUserId = isvUserId
            self.companyId = companyId
            self.marketplaceUrl = marketplaceUrl
            
        }
        
        delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginTapped(sender: AnyObject) {
        if loginButton.titleLabel?.text == "Log In" {
            login()
        } else {
            logout()
        }
    }
    
    // create the AppAuth request flow and present it to the user
    
    func login() {
        
        // build the auth configuration
        let configuration = OIDServiceConfiguration(authorizationEndpoint: NSURL(string: authorizationEndpoint)!, tokenEndpoint: NSURL(string: tokenEndpoint)!)
        
        // package the appConfig parameters
        
        let appConfigParameters = ["com.appdirect.isv.accountid": isvAccountId,
                                   "com.appdirect.isv.userid": isvUserId,
                                   "com.appdirect.companyid": companyId,
                                   "com.appdirect.marketplace.url": marketplaceUrl]
        
        // build the auth request
        
        let request = OIDAuthorizationRequest(configuration: configuration, clientId: clientId, scopes: [OIDScopeOpenID, OIDScopeProfile, "ROLE_USER"], redirectURL: NSURL(string: redirectUrl)!, responseType: "code id_token", additionalParameters: appConfigParameters)
        
        // present the auth request
        
        appDelegate.currentAuthorizationFlow = OIDAuthorizationService.presentAuthorizationRequest(request, presentingViewController: self, callback: { (authorizationResponse: OIDAuthorizationResponse?, error: NSError?) in
            guard error == nil else {
                print("Authorization request error: \(error?.localizedDescription)")
                return
            }
            
            if authorizationResponse != nil {
                let authState = OIDAuthState(authorizationResponse: authorizationResponse!)
                
                // perform the code exchange request
                
                if let tokenExchangeRequest = authState?.lastAuthorizationResponse.tokenExchangeRequest() {
                    OIDAuthorizationService.performTokenRequest(tokenExchangeRequest, callback: { (tokenResponse: OIDTokenResponse?, error: NSError?) in
                        guard error == nil else {
                            print("Token exchange error: \(error?.localizedDescription)")
                            return
                        }
                        
                        if let tokenResponse = tokenResponse {
                            
                            // parse out the token we need here and use it to create the session
                            
                            self.userObject = UserObject.objectFromAccessToken(tokenResponse.accessToken!)
                            
                            // check to see if we have a valid session
                    
                            if self.loginWasSuccessful() {
                                
                                // call this view's delegate's closure
                                
                                self.delegate?.loginWasSccessful(self.userObject!)
                                
                            } else {
                                
                                // the response token was not properly formatted, we can't build a user object
                            }
                            
                        } else {
                            print("Token exchange error: %@", error?.localizedDescription)
                        }
                    })
                }
            }
        })
    }
    
    func logout() {
        
        // Here we destory the user object
        
        userObject = nil
        
        delegate?.logoutWasSccessful()
    }
    
    // check to see if we have a session
    
    func loginWasSuccessful() -> Bool {
        
        // in this function we should confirm that the session is valid
        // or that we can create a valid session and return true or
        // false otherwise
        
        if userObject != nil {
            
            // We got a valid, properly formatted response from the server to build a user object
            
            return true
        }
        
        return false
    }
    
    // Custom callback handler on successful login
    // These delegate handlers would typically be external
    
    func loginWasSccessful(userObject: UserObject) {
        
        // We should update the UI
        
        statusLabel.text = "You have logged in"
        
        loginButton.setTitle("Log Out", forState: .Normal)
    }
    
    func logoutWasSccessful() {
        
        // We should update the UI
        
        statusLabel.text = "You are not logged in..."
        
        loginButton.setTitle("Log In", forState: .Normal)
    }
}

