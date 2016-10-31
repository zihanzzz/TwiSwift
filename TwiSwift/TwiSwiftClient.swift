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
    static let twitterConsumerKey = "STn5Qo0pAbPo6wRJ20s0cnEEx"
    static let twitterConsumerSecret = "x1T41B2Z7gb7rAgy2f4ktV0RGV4vbHZy6oknG34oHsdWy69Ce2"
    static let twitterConsumerKey1 = "GFsnqjiXQXiBWBrywEmxs38Be"
    static let twitterConsumerSecret1 = "rmPvY1awnl0GoGtxreNGhfqfBHdDJLWBCkoNEZmiLvYMVXVKM0"
    
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
                print(error.localizedDescription)
                completionHandler(false)
            })
        }
    }
    
    func destroyFavorite(tweet: Tweet, completionHandler: @escaping (Bool?) -> ()) {
        if let remoteId = tweet.remoteId {
            self.post("1.1/favorites/destroy.json?id=\(remoteId)", parameters: nil, progress: nil, success: { (operation: URLSessionDataTask, response: Any?) in
                completionHandler(true)
            }, failure: { (operation: URLSessionDataTask?, error: Error) in
                print(error.localizedDescription)
                completionHandler(false)
            })
        }
    }
    
    func update(status: String, inReplyToStatusId: String?, completionHandler: @escaping (Tweet?, Error?) -> ()) {
        
        var params = ["status": status]
        
        if let replyIdStr = inReplyToStatusId {
            params["in_reply_to_status"] = replyIdStr
        }
        
        self.post("1.1/statuses/update.json", parameters: params, progress: nil, success: { (operation: URLSessionDataTask, response: Any?) in
            
            let newTweet = Tweet(dictionary: response as! Dictionary<String, AnyObject>)
            completionHandler(newTweet, nil)

        }, failure: { (operation: URLSessionDataTask?, error: Error) in
            completionHandler(nil, error)
            print(error.localizedDescription)
        })
    }
    
    func reweet(tweetIdString: String, completionHandler: @escaping (Bool?) -> ()) {
        
        self.post("1.1/statuses/retweet/\(tweetIdString).json", parameters: nil, progress: nil, success: { (operation: URLSessionDataTask, response: Any?) in

            completionHandler(true)
            
        }, failure: { (operation: URLSessionDataTask?, error: Error) in
            
            print(error.localizedDescription)
            completionHandler(false)
            
        })
    }
    
    func deleteTweet(tweetIdString: String, completionHandler: @escaping (Tweet?, Error?) -> ()) {

        self.post("1.1/statuses/destroy/\(tweetIdString).json", parameters: nil, progress: nil, success: { (operation: URLSessionDataTask, response: Any?) in
            
            let deletedTweet = Tweet(dictionary: response as! Dictionary<String, AnyObject>)
            completionHandler(deletedTweet, nil)
            
        }, failure: { (operation: URLSessionDataTask?, error: Error) in
            
            print(error.localizedDescription)
            completionHandler(nil, error)
            
        })
    }
    
    func findMyRetweet(originalTweetIdString: String, completionHandler: @escaping (Bool?) -> ()) {
        
        let params = ["include_my_retweet" : true]
        
        self.get("1.1/statuses/show/\(originalTweetIdString).json", parameters: params, progress: nil, success: { (operation: URLSessionDataTask, response: Any?) in
            
            if let tweetDict = response as? Dictionary<String, AnyObject> {
                
                if let currentUserRTDict = tweetDict["current_user_retweet"] as? Dictionary<String, AnyObject> {
                    
                    if let myOwnRTIdStr = currentUserRTDict["id_str"] as? String {
                        
                        self.deleteTweet(tweetIdString: myOwnRTIdStr, completionHandler: { (tweet: Tweet?, error: Error?) in
                            
                            if (tweet != nil) {
                                completionHandler(true)
                            } else {
                                completionHandler(false)
                            }
                            
                        })
                        
                    }
                    
                    
                }
                
            }

            
            
            
            
        }, failure: { (operation: URLSessionDataTask?, error: Error) in
            
            print(error.localizedDescription)
            completionHandler(false)
            
            
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
