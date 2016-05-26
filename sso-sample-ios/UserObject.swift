//
//  UserObject.swift
//  sso-sample-ios
//
//  Created by Darnell on 2016-05-26.
//  Copyright © 2016 AppDirect. All rights reserved.
//

import Foundation

class UserObject {
    
    class func jsonFromUrl(withUrl url: String) -> [String:AnyObject]? {
        
        let range = url.rangeOfString("user=")
        let jsonString = url.substringFromIndex(range!.endIndex)
        
        if let jsonString = jsonString.stringByRemovingPercentEncoding {
            if let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding) {
                do {
                    return try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? [String:AnyObject]
                } catch {
                    print("Woops, an error occured:")
                    print(error)
                }
            }
        }
        
        return nil
    }
}
