//
//  TwiSwiftClient.swift
//  TwiSwift
//
//  Created by James Zhou on 10/26/16.
//  Copyright © 2016 James Zhou. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwiSwiftClient: BDBOAuth1SessionManager {
    
    static let twitterBaseURL = URL(string: "https://api.twitter.com")
    static let twitterConsumerKey = "GFsnqjiXQXiBWBrywEmxs38Be"
    static let twitterConsumerSecret = "rmPvY1awnl0GoGtxreNGhfqfBHdDJLWBCkoNEZmiLvYMVXVKM0"
    
    static let sharedInstance = TwiSwiftClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
    

}
