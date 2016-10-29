//
//  TweetCell.swift
//  TwiSwift
//
//  Created by James Zhou on 10/28/16.
//  Copyright © 2016 James Zhou. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var topRTImageView: UIImageView!
    
    @IBOutlet weak var topRTLabel: UILabel!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var tweetTextLabel: UILabel! //
    
    @IBOutlet weak var bottomRTImageView: UIImageView!
    
    @IBOutlet weak var bottomLikeImageView: UIImageView!
    
    @IBOutlet weak var bottomReplyImageView: UIImageView!
    
    
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

            }
            
            
            if let text = tweet.text {
                tweetTextLabel.text = text
            }
            
            
            
            
            
            
        }
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
