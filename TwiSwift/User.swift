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
            if _currentUser == nil {
                let data = UserDefaults.standard.object(forKey: currentUserKey)
                if data != nil {
                    do {
                        if let data = UserDefaults.standard.object(forKey: currentUserKey) as? Data {
                            let dictionary = try JSONSerialization.jsonObject(with: data, options: [])
                            _currentUser = User(dictionary: dictionary as! Dictionary<String, AnyObject>)
                        }
                    } catch {
                        
                    }
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            if _currentUser != nil {
                do {
                    let data = try JSONSerialization.data(withJSONObject: user?.dictionary as Any, options: [])
                    UserDefaults.standard.set(data, forKey: currentUserKey)
                    UserDefaults.standard.synchronize()
                } catch {
                    UserDefaults.standard.set(nil, forKey: currentUserKey)
                }
                
            } else {
                UserDefaults.standard.set(nil, forKey: currentUserKey)
            }
            UserDefaults.standard.synchronize()
            
        }
    }
    
    
    init(dictionary: Dictionary<String, AnyObject>) {
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagline = dictionary["description"] as? String
        self.dictionary = dictionary
    }
    
    func logout() {
        User.currentUser = nil
        TwiSwiftClient.sharedInstance?.requestSerializer.removeAccessToken()
        NotificationCenter.default.post(name: UserEventEnum.didLogout.notification, object: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    


}
