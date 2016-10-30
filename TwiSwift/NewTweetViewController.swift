//
//  NewTweetViewController.swift
//  TwiSwift
//
//  Created by James Zhou on 10/29/16.
//  Copyright © 2016 James Zhou. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController, UITextViewDelegate {

    let composer = User.currentUser
    
    var charactersLeftLabel: UILabel!
    
    var tweetButton: UIButton!
    
    @IBOutlet weak var composeTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let profileImageUrl = composer?.profileImageUrl {
            let largeImageUrl = profileImageUrl.replacingOccurrences(of: "normal", with: "200x200")
            
            if let url = URL(string: largeImageUrl) {
                let avatarImage = UIImage()
                let avatarImageView = UIImageView(image: avatarImage)
                avatarImageView.setImageWith(url)
                avatarImageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                
                avatarImageView.layer.cornerRadius = 3
                avatarImageView.layer.masksToBounds = true
                
                let leftbarButton = UIBarButtonItem.init(customView: avatarImageView)
                self.navigationItem.leftBarButtonItem = leftbarButton
            }
        }
        
        let dismissImageView = UIImageView(image: UIImage(named: "dismiss"))
        dismissImageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        let rightbarButton = UIBarButtonItem.init(customView: dismissImageView)
        self.navigationItem.rightBarButtonItem = rightbarButton
        
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(dismissTapped))
        dismissTap.numberOfTapsRequired = 1
        dismissImageView.addGestureRecognizer(dismissTap)
        
        
        // text view
        // Spend 2+ hours on this line... just to make UITextView starts typing at the very top...
        self.automaticallyAdjustsScrollViewInsets = false
        
        composeTextView.delegate = self
        
        composeTextView.font = UIFont(name: UIConstants.getTextFontNameLight(), size: 26)
        composeTextView.becomeFirstResponder()
        
        composeTextView.tintColor = UIConstants.twitterPrimaryBlue
        
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 40))
        customView.backgroundColor = UIColor.white
        customView.layer.borderColor = UIConstants.twitterLightGray.cgColor
        customView.layer.borderWidth = 0.3
        composeTextView.inputAccessoryView = customView
        
        self.view.addSubview(composeTextView)
        
       let screenWidth = UIScreen.main.bounds.width
        
        charactersLeftLabel = UILabel()
        charactersLeftLabel.frame = CGRect(x: screenWidth - 130, y: 0, width: 30, height: 40)
        charactersLeftLabel.font = UIFont(name: UIConstants.getTextFontNameLight(), size: 16)
        setCharactersLeftLabel(left: 140)
        
        customView.addSubview(charactersLeftLabel)
        
        tweetButton = UIButton()
        tweetButton.frame = CGRect(x: screenWidth - 80, y: 5, width: 70, height: 30)
        tweetButton.setTitle("Tweet", for: .normal)
        tweetButton.titleLabel?.font = UIFont(name: UIConstants.getTextFontNameLight(), size: 16)
        tweetButton.layer.cornerRadius = 4
        tweetButton.layer.masksToBounds = true
        setTweetButton(ready: false)
        
        tweetButton.addTarget(self, action: #selector(sendTweet), for: .touchUpInside)
        
        customView.addSubview(tweetButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissTapped() {
        // resign first responder is very important, otherwise keyboard will be laggy to be dismissed.
        composeTextView.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    func setCharactersLeftLabel(left: Int) {
        charactersLeftLabel.text = "\(left)"
        if (left > 20) {
            charactersLeftLabel.textColor = UIConstants.twitterDarkGray
        } else {
            charactersLeftLabel.textColor = UIColor.red
        }
    }
    
    func setTweetButton(ready: Bool) {
        if (!ready) {
            tweetButton.backgroundColor = UIColor.white
            tweetButton.setTitleColor(UIConstants.twitterDarkGray, for: .normal)
            tweetButton.layer.borderColor = UIConstants.twitterDarkGray.cgColor
            tweetButton.layer.borderWidth = 0.5
            tweetButton.isUserInteractionEnabled = false
        } else {
            tweetButton.backgroundColor = UIConstants.twitterPrimaryBlue
            tweetButton.setTitleColor(UIColor.white, for: .normal)
            tweetButton.isUserInteractionEnabled = true
        }
    }
    
    func sendTweet() {
        
    }
    
    // MARK: - Text View delegate methods

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
