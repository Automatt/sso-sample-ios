//
//  UserObject.swift
//  sso-sample-ios
//
//  Created by Darnell on 2016-05-26.
//  Copyright © 2016 AppDirect. All rights reserved.
//

import Foundation

class UserObject {
    
    let info: [String:AnyObject]
    
    init(withInfo info: [String:AnyObject]) {
        self.info = info
    }
    
    class func objectFromUrl(url: String) -> UserObject? {
        let range = url.rangeOfString("user=")
        let jsonString = url.substringFromIndex(range!.endIndex)
        
        if let jsonString = jsonString.stringByRemovingPercentEncoding {
            print(jsonString)
            if let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding) {
                do {
                    if let info = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? [String:AnyObject] {
                        return UserObject(withInfo: info)
                    }
                } catch {
                    print(error)
                }
            }
        }
        
        return nil
    }
}
