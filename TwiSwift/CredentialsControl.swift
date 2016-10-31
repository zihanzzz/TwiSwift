//
//  CredentialsControl.swift
//  TwiSwift
//
//  Created by James Zhou on 10/30/16.
//  Copyright © 2016 James Zhou. All rights reserved.
//

import UIKit

class CredentialsControl: NSObject {

    static let twitterBaseURL = URL(string: "https://api.twitter.com")
    static let keysArray = ["STn5Qo0pAbPo6wRJ20s0cnEEx", "GFsnqjiXQXiBWBrywEmxs38Be"]
    static let secretsArray = ["x1T41B2Z7gb7rAgy2f4ktV0RGV4vbHZy6oknG34oHsdWy69Ce2", "rmPvY1awnl0GoGtxreNGhfqfBHdDJLWBCkoNEZmiLvYMVXVKM0"]
    
    class func getBaseURL() -> URL {
        return twitterBaseURL!
    }
    
    class func getKey() -> String {
        
        let index = UserDefaults.standard.integer(forKey: "credential")
        
        if index == 0 {
            return keysArray[0]
        }
        return keysArray[index - 1]
    }
    
    class func getSecret() -> String {
        
        let index = UserDefaults.standard.integer(forKey: "credential")
        
        if index == 0 {
            return secretsArray[0]
        }
        return secretsArray[index - 1]
    }
}
