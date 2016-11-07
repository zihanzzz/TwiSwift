//
//  UIConstants.swift
//  TwiSwift
//
//  Created by James Zhou on 10/28/16.
//  Copyright © 2016 James Zhou. All rights reserved.
//

import UIKit
import SwiftDate

class UIConstants: NSObject {
    
    
    // MARK : - Enums
    enum UserEventEnum: String {
        case didLogin = "userDidLoginNotification"
        case didLogout = "userDidLogoutNotification"
        case newTweet = "newTweet"
        case deleteTweet = "deleteTweet"
        
        var notification : Notification.Name {
            return Notification.Name(rawValue: self.rawValue)
        }
    }
    
    enum HamburgerEventEnum: String {
        case didOpen = "didOpen"
        case didClose = "didClose"
        
        var notification : Notification.Name {
            return Notification.Name(rawValue: self.rawValue)
        }
    }
    
    enum TimelineEnum: String {
        case home = "home_timeline"
        case mentions = "mentions_timeline"
        case user = "user_timeline"
        case favorite = "favorites"
    }
    
    // MARK : - Nav Bar
    static func configureNavBarStyle(forViewController viewController: UIViewController, withTitle: String) {
        viewController.navigationController?.navigationBar.barTintColor = UIConstants.twitterPrimaryBlue
        viewController.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white,
                                                                                  NSFontAttributeName: getTitleFont()]
        viewController.navigationController?.navigationBar.tintColor = UIColor.white
        viewController.navigationController?.navigationBar.isTranslucent = false
        if withTitle.characters.count > 0 {
            viewController.navigationItem.title = withTitle
        }
        viewController.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: getBarButtonItemFont()], for: .normal)
        viewController.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: getBarButtonItemFont()], for: .normal)
    }
    
    // MARK : - Colors
    static let twitterPrimaryBlue = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)  // Hex is 1DA1F2
    
    static let twitterDarkGray = UIColor(red: 101/255, green: 119/255, blue: 134/255, alpha: 1)  // Hex is 657786
    
    static let twitterLightGray = UIColor(red: 170/255, green: 184/255, blue: 194/255, alpha: 1) // Hex is AAB8C2
    
    static let swiftColor = UIColor(red: 232/255, green: 127/255, blue: 61/255, alpha: 1)

    // MARK : - Fonts
    static func getBarButtonItemFont() -> UIFont {
        return UIFont(name: getTextFontNameBold(), size: 16)!
    }
    
    static func getTitleFont() -> UIFont {
        return UIFont(name: getTextFontNameBold(), size: 20)!
    }
    
    static func getTextFontNameBold() -> String {
        return "HelveticaNeue-Bold"
    }
    
    static func getTextFontNameLight() -> String {
        return "HelveticaNeue-Light"
    }
    
    // MARK: - Miscellaneous
    static func getLeftMenuAnimationSpeed() -> TimeInterval {
        return 0.3
    }
    
    // MARK: - Strings
    static func getAppVersion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
    static func getAppBundle() -> String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    }
    
    static func getFriendlyCounts(count: Int) -> String {
        
        let doubleCount = Double(count)
        
        if count < 1000 {
            return "\(count)"
        } else if ((count > 1000 || count == 1000) && count < 1000000) {
            let newNumber = doubleCount / 1000.0
            return String(format: "%.1fK", newNumber)
        } else if (count > 1000000 || count == 1000000) {
            let newNumber = doubleCount / 1000000.0
            return String(format: "%.1fM", newNumber)
        }
        return "0"
    }
    
    static func getTimeStampLabel(date: Date) -> String {
        return date.string(dateStyle: .short, timeStyle: .short, in: nil)
    }
    
    static func getTimeAgoLabel(date: Date) -> String {
        
        let componentsDictionary = date.timeIntervalSinceNow.in([.day, .hour, .minute, .second])
        
        let day = componentsDictionary[Calendar.Component.day] ?? 0
        let hour = componentsDictionary[Calendar.Component.hour] ?? 0
        let minute = componentsDictionary[Calendar.Component.minute] ?? 0
        let second = componentsDictionary[Calendar.Component.second] ?? 0

        if abs(day) > 0 {
            return "\(abs(day))d"
        } else if abs(hour) > 0 {
            return "\(abs(hour))h"
        } else if abs(minute) > 0 {
            return "\(abs(minute))m"
        } else if (abs(second) > 0 || second == 0) {
            return "\(abs(second))s"
        }        
        return ""
    }
}
