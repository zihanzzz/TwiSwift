//
//  TweetCell.swift
//  TwiSwift
//
//  Created by James Zhou on 10/28/16.
//  Copyright © 2016 James Zhou. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var topRTImageView: UIImageView! //
    
    @IBOutlet weak var topRTLabel: UILabel!
    
    @IBOutlet weak var avatarImageView: UIImageView! //
    
    @IBOutlet weak var nameLabel: UILabel! //
    
    @IBOutlet weak var usernameLabel: UILabel! //
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var tweetTextLabel: UILabel! //
    
    @IBOutlet weak var bottomRTImageView: UIImageView! //
    
    @IBOutlet weak var bottomLikeImageView: UIImageView! //
    
    @IBOutlet weak var bottomReplyImageView: UIImageView! //
    
    
    var tweet: Tweet! {
        didSet {
            
            if let user = tweet.originalComposer {

                avatarImageView.layer.cornerRadius = 3.0
                avatarImageView.layer.masksToBounds = true
                if let normalImageUrl = user.profileImageUrl {
                    let largeImageUrl = normalImageUrl.replacingOccurrences(of: "normal", with: "200x200")
                    if let url = URL(string: largeImageUrl) {
                        avatarImageView.setImageWith(url)
                    }
                }
                
                if let name = user.name {
                    nameLabel.text = name
                }
                
                if let username = user.screenname {
                    usernameLabel.text = "@\(username)"
                }
                
                
                if (tweet.isRetweeted() && tweet.sender != nil) {
                    
                    if let senderName = tweet.sender?.name! {
                        topRTLabel.text = "\(senderName) Retweeted"
                    }

                    
                } else {
                    topRTImageView.isHidden = true
                    topRTLabel.isHidden = true
                }
            }
            
            if let date = tweet.createdAt {
                
                
                
                timeLabel.text = UIConstants.getTimeLabel(date: date)
                
            }
            
            if let text = tweet.text {
                tweetTextLabel.text = text
            }
            
            
            topRTImageView.image = UIImage(named: "retweet")
            bottomRTImageView.image = UIImage(named: "retweet")
            bottomLikeImageView.image = UIImage(named: "like")
            bottomReplyImageView.image = UIImage(named: "reply")
            
            setUpLabelAppearances()
        }
    }
    
    func setUpLabelAppearances() {
        
        for label in [topRTLabel, usernameLabel, timeLabel] {
            label?.textColor = UIConstants.twitterLightGray
            label?.font = UIFont(name: UIConstants.getTextFontNameLight(), size: 14)
        }
        
        nameLabel.textColor = UIColor.black
        nameLabel.font = UIFont(name: UIConstants.getTextFontNameBold(), size: 15)
        
        tweetTextLabel.textColor = UIColor.black
        tweetTextLabel.font = UIFont(name: UIConstants.getTextFontNameLight(), size: 18)
    }
    
    func clearCellState() {
        avatarImageView.image = nil
        topRTImageView.isHidden = false
        topRTLabel.isHidden = false
        
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
