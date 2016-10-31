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
    case deleteTweet = "deleteTweet"
    
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
    var idString: String?

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
        idString = dictionary["id_str"] as? String
        self.dictionary = dictionary
    }
    
    func logout() {
        User.currentUser = nil
        TwiSwiftClient.sharedInstance?.deauthorize()
        NotificationCenter.default.post(name: UserEventEnum.didLogout.notification, object: nil)
        
        // switch keys
        let defaults = UserDefaults.standard
        let previousIndex = defaults.integer(forKey: "credential")
        if previousIndex == 0 {
            defaults.set(2, forKey: "credential")
        } else if previousIndex == 1 {
            defaults.set(2, forKey: "credential")
        } else if previousIndex == 2 {
            defaults.set(1, forKey: "credential")
        }
        defaults.synchronize()
        
        TwiSwiftClient.sharedInstance? = TwiSwiftClient(baseURL: CredentialsControl.getBaseURL(), consumerKey: CredentialsControl.getKey(), consumerSecret: CredentialsControl.getSecret())
    }
    
    class func isCurrentUser(user: User) -> Bool{
        return user.idString == User.currentUser?.idString
    }
}
