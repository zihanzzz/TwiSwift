//
//  FollowingButton.swift
//  TwiSwift
//
//  Created by James Zhou on 11/6/16.
//  Copyright © 2016 James Zhou. All rights reserved.
//

import UIKit

class FollowingButton: UIButton {
    
    var isFollowing: Bool?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        
        self.layer.borderColor = UIConstants.twitterPrimaryBlue.cgColor
        self.layer.borderWidth = 1
        
        self.titleLabel?.font = UIFont(name: UIConstants.getTextFontNameBold(), size: 16)
    }
    
    func setUpFollowingAppearance() {
        isFollowing = true
        UIView.animate(withDuration: 0.1, animations: {
            self.setTitle("Following", for: .normal)
            self.setTitleColor(UIColor.white, for: .normal)
            self.backgroundColor = UIConstants.twitterPrimaryBlue
        })
    }
    
    func setUpToFollowAppearance() {
        isFollowing = false
        UIView.animate(withDuration: 0.1, animations: {
            self.setTitle("Follow", for: .normal)
            self.setTitleColor(UIConstants.twitterPrimaryBlue, for: .normal)
            self.backgroundColor = UIColor.white
        })
    }
}
