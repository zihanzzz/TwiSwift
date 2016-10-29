//
//  TweetCell.swift
//  TwiSwift
//
//  Created by James Zhou on 10/28/16.
//  Copyright © 2016 James Zhou. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var topRTImageView: UIImageView? //
    
    @IBOutlet weak var topRTLabel: UILabel?
    
    @IBOutlet weak var avatarImageView: UIImageView? //
    
    @IBOutlet weak var nameLabel: UILabel? //
    
    @IBOutlet weak var usernameLabel: UILabel? //
    
    @IBOutlet weak var timeAgoLabel: UILabel?
    
    @IBOutlet weak var tweetTextLabel: UILabel? //
    
    @IBOutlet weak var bottomRTImageView: UIImageView? //
    
    @IBOutlet weak var bottomLikeImageView: UIImageView? //
    
    @IBOutlet weak var bottomReplyImageView: UIImageView? //
    
    @IBOutlet weak var timestampLabel: UILabel?
    
    
    var isLiked: Bool = false
    
    var tweet: Tweet! {
        didSet {
            
            if let user = tweet.originalComposer {

                avatarImageView?.layer.cornerRadius = 3.0
                avatarImageView?.layer.masksToBounds = true
                if let normalImageUrl = user.profileImageUrl {
                    let largeImageUrl = normalImageUrl.replacingOccurrences(of: "normal", with: "200x200")
                    if let url = URL(string: largeImageUrl) {
                        avatarImageView?.setImageWith(url)
                    }
                }
                
                if let name = user.name {
                    nameLabel?.text = name
                }
                
                if let username = user.screenname {
                    usernameLabel?.text = "@\(username)"
                }
                
                
                if (tweet.isRetweeted() && tweet.sender != nil) {
                    if let senderName = tweet.sender?.name! {
                        topRTLabel?.text = "\(senderName) Retweeted"
                    }
                } else {
                    topRTImageView?.isHidden = true
                    topRTLabel?.isHidden = true
                }
            }
            
            if let date = tweet.createdAt {
                timeAgoLabel?.text = UIConstants.getTimeAgoLabel(date: date)
                timestampLabel?.text = UIConstants.getTimeStampLabel(date: date)
            }
            
            if let text = tweet.text {
                tweetTextLabel?.text = text
            }

            topRTImageView?.image = UIImage(named: "retweet")
            bottomRTImageView?.image = UIImage(named: "retweet")
            
            isLiked = tweet.favorited ?? false
            
            if (!isLiked) {
                setLikeImage(selected: false)
            } else {
                setLikeImage(selected: true)
            }
            bottomReplyImageView?.image = UIImage(named: "reply")
            
            setUpLabelAppearances()
        }
    }
    
    func setUpLabelAppearances() {
        
        for label in [topRTLabel, usernameLabel, timeAgoLabel, timestampLabel] {
            label?.textColor = UIConstants.twitterLightGray
            label?.font = UIFont(name: UIConstants.getTextFontNameLight(), size: 14)
        }
        
        nameLabel?.textColor = UIColor.black
        nameLabel?.font = UIFont(name: UIConstants.getTextFontNameBold(), size: 15)
        
        tweetTextLabel?.textColor = UIColor.black
        tweetTextLabel?.font = UIFont(name: UIConstants.getTextFontNameLight(), size: 18)
    }
    
    func clearCellState() {
        avatarImageView?.image = nil
        topRTImageView?.isHidden = false
        topRTLabel?.isHidden = false
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        let singleTap0 = UITapGestureRecognizer(target: self, action: #selector(bottomButton0Tapped))
        singleTap0.numberOfTapsRequired = 1
        bottomRTImageView?.isUserInteractionEnabled = true
        bottomRTImageView?.addGestureRecognizer(singleTap0)
        
        let singleTap1 = UITapGestureRecognizer(target: self, action: #selector(bottomButton1Tapped))
        singleTap1.numberOfTapsRequired = 1
        bottomLikeImageView?.isUserInteractionEnabled = true
        bottomLikeImageView?.addGestureRecognizer(singleTap1)
        
        let singleTap2 = UITapGestureRecognizer(target: self, action: #selector(bottomButton2Tapped))
        singleTap2.numberOfTapsRequired = 1
        bottomReplyImageView?.isUserInteractionEnabled = true
        bottomReplyImageView?.addGestureRecognizer(singleTap2)
    }
    
    // RT
    func bottomButton0Tapped() {
        
    }
    
    // Like
    func bottomButton1Tapped() {
        toggleLikeButton()
    }
    
    // Reply
    func bottomButton2Tapped() {
        
    }
    
    func toggleLikeButton() {
        
        if (!isLiked) {
            UIView.animate(withDuration: 0.1, animations: {
                
                self.bottomLikeImageView?.transform = CGAffineTransform(scaleX: 4, y: 4)
                self.setLikeImage(selected: true)
                
            }, completion: { (finish) in
                
                UIView.animate(withDuration: 0.1, animations: { 
                    self.bottomLikeImageView?.transform = CGAffineTransform(scaleX: 1, y: 1)
                })
            })
            
            TwiSwiftClient.sharedInstance?.createFavorite(tweet: self.tweet, completionHandler: { (finish: Bool?) in
                if (!finish!) {
                    self.setLikeImage(selected: false)
                }
            })
        } else {
            setLikeImage(selected: false)
            TwiSwiftClient.sharedInstance?.destroyFavorite(tweet: self.tweet, completionHandler: { (finish: Bool?) in
                if (!finish!) {
                    self.setLikeImage(selected: true)
                }
            })
        }
        isLiked = !isLiked
    }
    
    func setLikeImage(selected: Bool) {
        if (selected) {
            bottomLikeImageView?.image = UIImage(named: "like-selected")
        } else {
            bottomLikeImageView?.image = UIImage(named: "like-unselected")
        }
    }
    

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
