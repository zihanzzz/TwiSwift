//
//  TweetNumbersCell.swift
//  TwiSwift
//
//  Created by James Zhou on 10/29/16.
//  Copyright © 2016 James Zhou. All rights reserved.
//

import UIKit

class TweetNumbersCell: UITableViewCell {
    
    @IBOutlet weak var rtCountLabel: UILabel!
    
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    @IBOutlet weak var retweetLabel: UILabel!
    
    @IBOutlet weak var favoriteLabel: UILabel!
    
    var tweet: Tweet! {
        didSet {
            
            if let rtCount = tweet.retweetCount {
                rtCountLabel.text = "\(rtCount)"
                if rtCount == 1 {
                    retweetLabel.text = "RETWEET"
                } else {
                    retweetLabel.text = "RETWEETS"
                }
            }
            
            if let favCount = tweet.favoriteCount {
                favoriteCountLabel.text = "\(favCount)"
                if favCount == 1 {
                    favoriteLabel.text = "FAVORITE"
                } else {
                    favoriteLabel.text = "FAVORITES"
                }
            }
            
            for label in [rtCountLabel, favoriteCountLabel] {
                label?.font = UIFont(name: UIConstants.getTextFontNameBold(), size: 16)
                label?.textColor = UIColor.black
                label?.adjustsFontSizeToFitWidth = true
            }
            
            for label in [retweetLabel, favoriteLabel] {
                label?.font = UIFont(name: UIConstants.getTextFontNameLight(), size: 16)
                label?.textColor = UIConstants.twitterLightGray
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
