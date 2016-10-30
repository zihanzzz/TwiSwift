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
    
    var placeholderLabel: UILabel!

    var isReadyToTweet = false
    
    var replyingTweet: Tweet?
    
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
        
        // placeholder
        placeholderLabel = UILabel()
        placeholderLabel.frame = CGRect(x: 8, y: 9, width: 280, height: 30)
        placeholderLabel.text = "What's happening?"
        placeholderLabel.font = UIFont(name: UIConstants.getTextFontNameLight(), size: 26)
        placeholderLabel.textColor = UIConstants.twitterLightGray
        
        composeTextView.addSubview(placeholderLabel)

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
        setTweetButton(ready: isReadyToTweet)
        
        tweetButton.addTarget(self, action: #selector(sendTweet), for: .touchUpInside)
        
        customView.addSubview(tweetButton)
        
        if replyingTweet != nil {
            let replyText = "@\(replyingTweet!.sender!.screenname!)" + " "
            composeTextView.text = replyText
            placeholderLabel.isHidden = true
            setCharactersLeftLabel(left: (140 - replyText.characters.count))
            setTweetButton(ready: true)
        }
        
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
            isReadyToTweet = false
            tweetButton.backgroundColor = UIColor.white
            tweetButton.setTitleColor(UIConstants.twitterDarkGray, for: .normal)
            tweetButton.layer.borderColor = UIConstants.twitterDarkGray.cgColor
            tweetButton.layer.borderWidth = 0.5
            tweetButton.isUserInteractionEnabled = false
        } else {
            isReadyToTweet = true
            tweetButton.backgroundColor = UIConstants.twitterPrimaryBlue
            tweetButton.setTitleColor(UIColor.white, for: .normal)
            tweetButton.layer.borderWidth = 0
            tweetButton.isUserInteractionEnabled = true
        }
    }
    
    func sendTweet() {
        composeTextView.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
        
        let newTweet = Tweet(dictionary: Dictionary<String, AnyObject>())
        newTweet.sender = User.currentUser
        newTweet.originalComposer = User.currentUser
        newTweet.text = composeTextView.text
        newTweet.createdAt = Date()
        newTweet.retweetCount = 0
        newTweet.favoriteCount = 0
        
        let userInfo:[String: Tweet] = ["tweet": newTweet]
        
        NotificationCenter.default.post(name: UserEventEnum.newTweet.notification, object: nil, userInfo: userInfo)
        
        TwiSwiftClient.sharedInstance?.update(status: composeTextView.text, completionHandler: { (tweet: Tweet?, error: Error?) in
            
        })
    }
    
    // MARK: - Text View delegate methods
    func textViewDidChange(_ textView: UITextView) {
        let currentCount = textView.text.characters.count
        
        if (currentCount > 0) {
            placeholderLabel.isHidden = true
        } else {
            placeholderLabel.isHidden = false
        }
        
        let charactersLeft = 140 - currentCount
        setCharactersLeftLabel(left: charactersLeft)
        
        if (isReadyToTweet) {
            if (charactersLeft < 0 || charactersLeft > 139) {
                setTweetButton(ready: false)
            }
        } else {
            if (charactersLeft < 140 && charactersLeft > -1) {
                setTweetButton(ready: true)
            }
        }
    }

}
