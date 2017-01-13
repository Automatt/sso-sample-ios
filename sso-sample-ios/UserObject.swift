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
    
    class func objectFromAccessToken(_ token: String) -> UserObject? {
        
        //splitting JWT to extract payload
        let arr = token.components(separatedBy: ".")
        
        //base64 encoded string i want to decode
        var base64String = arr[1] as String
        if base64String.characters.count % 4 != 0 {
            let padlen = 4 - base64String.characters.count % 4
            base64String += String(repeating: "=", count: padlen)
        }
        
        //attempting to convert base64 string to nsdata
        let nsdata: Data = Data(base64Encoded: base64String, options: NSData.Base64DecodingOptions(rawValue: 0))!
        
        //decoding fails because nsdata unwraps as nil
        let jsonString: NSString = NSString(data: nsdata, encoding: String.Encoding.utf8.rawValue)!
        
        //unpack json string into dictionary
        if let data = jsonString.data(using: String.Encoding.utf8.rawValue) {
            do {
                if let info = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:AnyObject] {
                    return UserObject(withInfo: info)
                }
            } catch {
                print(error)
            }
        }
        
        return nil
    }
}
