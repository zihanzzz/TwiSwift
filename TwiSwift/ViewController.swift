//
//  ViewController.swift
//  TwiSwift
//
//  Created by James Zhou on 10/26/16.
//  Copyright © 2016 James Zhou. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogin(_ sender: Any) {
        TwiSwiftClient.sharedInstance?.requestSerializer.removeAccessToken()
        let callbackURL = URL(string: "twiswift://oauth")
        TwiSwiftClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: callbackURL, scope: nil, success: { (requestToken: BDBOAuth1Credential?) -> Void in
            
            print("got the request token")
            let authURL = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")!
            UIApplication.shared.open(authURL, options: [:], completionHandler: nil)
        }, failure: { (error: Error?) -> Void in
            print("Failed to get request token")
        })
        
    }
    


}

