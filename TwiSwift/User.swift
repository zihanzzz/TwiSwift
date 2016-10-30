//
//  User.swift
//  TwiSwift
//
//  Created by James Zhou on 10/26/16.
//  Copyright © 2016 James Zhou. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"

enum UserEventEnum: String {
    case didLogin = "userDidLoginNotification"
    case didLogout = "userDidLogoutNotification"
    case newTweet = "newTweet"
    
    var notification : Notification.Name {
        return Notification.Name(rawValue: self.rawValue)
    }
}

class User: NSObject {
    
    var name: String?
    var screenname: String?
    var profileImageUrl: String?
    var tagline: String?
    var dictionary: Dictionary<String, AnyObject>?
    
    class var currentUser: User? {
        get {
            let defaults = UserDefaults.standard
            
            if _currentUser == nil {
                if let data = defaults.object(forKey: currentUserKey) as? Data {
                    
                    do {
                        let dictionary = try JSONSerialization.jsonObject(with: data, options: [])
                        _currentUser = User(dictionary: dictionary as! Dictionary<String, AnyObject>)
                    } catch {
                        print("JSON serialization error: \(error)")
                    }
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            let defaults = UserDefaults.standard
            if _currentUser != nil {
                do {
                    let data = try JSONSerialization.data(withJSONObject: user?.dictionary as Any, options: [])
                    defaults.set(data, forKey: currentUserKey)
                } catch {
                    print("JSON deserialization error: \(error)")
                }
            } else {
                defaults.removeObject(forKey: currentUserKey)
            }
            defaults.synchronize()
        }
    }
    
    init(dictionary: Dictionary<String, AnyObject>) {
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url_https"] as? String
        tagline = dictionary["description"] as? String
        self.dictionary = dictionary
    }
    
    func logout() {
        User.currentUser = nil
        TwiSwiftClient.sharedInstance?.deauthorize()
        NotificationCenter.default.post(name: UserEventEnum.didLogout.notification, object: nil)
    }
}
