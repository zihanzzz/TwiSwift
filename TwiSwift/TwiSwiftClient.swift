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
    
    var loginCompletionHandler: (User?, Error?) -> () = {arg in}
    
    static let twitterBaseURL = URL(string: "https://api.twitter.com")
    static let twitterConsumerKey = "GFsnqjiXQXiBWBrywEmxs38Be"
    static let twitterConsumerSecret = "rmPvY1awnl0GoGtxreNGhfqfBHdDJLWBCkoNEZmiLvYMVXVKM0"
    
    static let sharedInstance = TwiSwiftClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
    
    func loginWithCompletion(completionHandler: @escaping (User?, Error?) -> ()) {

        loginCompletionHandler = completionHandler
        
        // Fetch request token & redirect to authorization page
        TwiSwiftClient.sharedInstance?.requestSerializer.removeAccessToken()
        let callbackURL = URL(string: "twiswift://oauth")
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: callbackURL, scope: nil, success: { (requestToken: BDBOAuth1Credential?) -> Void in
            
            let authURL = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")!
            UIApplication.shared.open(authURL, options: [:], completionHandler: nil)
            
        }, failure: { (error: Error?) -> Void in
            
            self.loginCompletionHandler(nil, error)
            
        })
    }
    
    func openURL(url: URL) {
        
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential.init(queryString: url.query), success: { (accessToken: BDBOAuth1Credential?) in
            
            self.requestSerializer.saveAccessToken(accessToken)
            
            self.get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (operation: URLSessionDataTask, response: Any?) in

                let user = User(dictionary: response as! Dictionary<String, AnyObject>)
                self.loginCompletionHandler(user, nil)

            }, failure: { (operation: URLSessionDataTask?, error: Error) in
                
                self.loginCompletionHandler(nil, error)
                
            })
            
        }, failure: { (error: Error?) in
            self.loginCompletionHandler(nil, error)
        })
    }
    
    
}
