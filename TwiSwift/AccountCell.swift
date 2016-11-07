//
//  AccountCell.swift
//  TwiSwift
//
//  Created by James Zhou on 11/6/16.
//  Copyright © 2016 James Zhou. All rights reserved.
//

import UIKit

class AccountCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    
    var user: User! {
        didSet {
            
            avatarImageView.layer.cornerRadius = 30
            avatarImageView.layer.masksToBounds = true
            
            let largeImageUrl = user.profileImageUrl!.replacingOccurrences(of: "normal", with: "200x200")
            avatarImageView.setImageWith(URL(string: largeImageUrl)!)
            
            nameLabel.text = user.name!
            nameLabel.textColor = UIColor.black
            nameLabel.font = UIFont(name: UIConstants.getTextFontNameBold(), size: 17)
            
            screenNameLabel.text = "@\(user.screenname!)"
            screenNameLabel.textColor = UIConstants.twitterDarkGray
            screenNameLabel.font = UIFont(name: UIConstants.getTextFontNameLight(), size: 15)
            
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
