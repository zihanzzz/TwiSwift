//
//  Tweet.swift
//  TwiSwift
//
//  Created by James Zhou on 10/26/16.
//  Copyright © 2016 James Zhou. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var originalComposer: User?
    var text: String?
    var createdAtString: String?
    var createdAt: Date?
    var rtStatus: Dictionary<String, AnyObject>?

    init(dictionary: Dictionary<String, AnyObject>) {

        
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        rtStatus = dictionary["retweeted_status"] as? Dictionary<String, AnyObject>
        
        if let createdAtString = createdAtString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            createdAt = formatter.date(from: createdAtString)
        }

        if let rtDictionary = rtStatus {
            originalComposer = User(dictionary: rtDictionary["user"] as! Dictionary<String, AnyObject>)
        } else {
            originalComposer = User(dictionary: dictionary["user"] as! Dictionary<String, AnyObject>)
        }

    }

    class func tweetsWithArray(array: [Dictionary<String, AnyObject>]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        return tweets
    }
    
    func isRetweeted() -> Bool {
        if rtStatus != nil {
            return true
        } else {
            return false
        }
    }
    
}
