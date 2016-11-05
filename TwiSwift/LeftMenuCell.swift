//
//  LeftMenuCell.swift
//  TwiSwift
//
//  Created by James Zhou on 11/4/16.
//  Copyright © 2016 James Zhou. All rights reserved.
//

import UIKit

class LeftMenuCell: UITableViewCell {

    @IBOutlet weak var menuImageView: UIImageView!
    
    @IBOutlet weak var menuLabel: UILabel!
    
    func setUpMenu(menuText: String, menuImageName: String) {
        
        menuImageView.image = UIImage(named: menuImageName)
        
        menuLabel.text = menuText
        menuLabel.textColor = UIColor.white
        menuLabel.font = UIFont(name: UIConstants.getTextFontNameLight(), size: 25)
        
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
