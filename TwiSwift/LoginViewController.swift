//
//  ViewController.swift
//  TwiSwift
//
//  Created by James Zhou on 10/26/16.
//  Copyright © 2016 James Zhou. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.loginButton.backgroundColor = UIConstants.twitterPrimaryBlue
        self.loginButton.setTitleColor(UIColor.white, for: .normal)
        self.loginButton.titleLabel?.font = UIFont(name: UIConstants.getTextFontNameBold(), size: 24)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogin(_ sender: Any) {
        
        TwiSwiftClient.sharedInstance?.loginWithCompletion(completionHandler: { (user: User?, error: Error?) in
            
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            } else {
                print("Login failure with error: \(error)")
            }
        })
    }
}

