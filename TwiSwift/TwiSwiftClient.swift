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
    
    var loginCompletionHandler: (User?, Error?) -> () = {arg in}
    
    static let sharedInstance = TwiSwiftClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
    
    func loginWithCompletion(completionHandler: @escaping (User?, Error?) -> ()) {

        loginCompletionHandler = completionHandler
        
        // Fetch request token & redirect to authorization page
        TwiSwiftClient.sharedInstance?.deauthorize()
        let callbackURL = URL(string: "twiswift://oauth")
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: callbackURL, scope: nil, success: { (requestToken: BDBOAuth1Credential?) -> Void in
            
            let authURL = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")!
            UIApplication.shared.open(authURL, options: [:], completionHandler: nil)
            
        }, failure: { (error: Error?) -> Void in
            self.loginCompletionHandler(nil, error)
        })
    }
    
    func homeTimelineWithParams(params: Dictionary<String, Any>?, completionHandler: @escaping ([Tweet]?, Error?) -> ()) {

        self.get("1.1/statuses/home_timeline.json", parameters: params, progress: nil, success: { (operation: URLSessionDataTask, response: Any?) in
            
            if let tweetsJson = response as? [Dictionary<String, AnyObject>] {
                let tweets = Tweet.tweetsWithArray(array: tweetsJson)
                completionHandler(tweets, nil)
            }

        }, failure: { (operation: URLSessionDataTask?, error: Error) in
            completionHandler(nil, error)
        })
    }
    
    func createFavorite(tweet: Tweet, completionHandler: @escaping (Bool?) -> ()) {
        if let remoteId = tweet.remoteId {
            self.post("1.1/favorites/create.json?id=\(remoteId)", parameters: nil, progress: nil, success: { (operation: URLSessionDataTask, response: Any?) in
                completionHandler(true)
            }, failure: { (operation: URLSessionDataTask?, error: Error) in
                completionHandler(false)
            })
        }
    }
    
    func destroyFavorite(tweet: Tweet, completionHandler: @escaping (Bool?) -> ()) {
        if let remoteId = tweet.remoteId {
            self.post("1.1/favorites/destroy.json?id=\(remoteId)", parameters: nil, progress: nil, success: { (operation: URLSessionDataTask, response: Any?) in
                completionHandler(true)
            }, failure: { (operation: URLSessionDataTask?, error: Error) in
                completionHandler(false)
            })
        }
    }
    
    func update(status: String, completionHandler: @escaping (Tweet?, Error?) -> ()) {
        
        let params = ["status": status]
        self.post("1.1/statuses/update.json", parameters: params, progress: nil, success: { (operation: URLSessionDataTask, response: Any?) in
            
            let newTweet = Tweet(dictionary: response as! Dictionary<String, AnyObject>)
            completionHandler(newTweet, nil)

        }, failure: { (operation: URLSessionDataTask?, error: Error) in
            completionHandler(nil, error)
            print(error.localizedDescription)
        })
    }
    
    func openURL(url: URL) {
        
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential.init(queryString: url.query), success: { (accessToken: BDBOAuth1Credential?) in
            
            let saveResult = self.requestSerializer.saveAccessToken(accessToken)
            print("saving token result: \(saveResult)")
            self.get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (operation: URLSessionDataTask, response: Any?) in

                let user = User(dictionary: response as! Dictionary<String, AnyObject>)
                User.currentUser = user
                self.loginCompletionHandler(user, nil)

            }, failure: { (operation: URLSessionDataTask?, error: Error) in
                self.loginCompletionHandler(nil, error)
            })
        }, failure: { (error: Error?) in
            self.loginCompletionHandler(nil, error)
        })
    }
}
