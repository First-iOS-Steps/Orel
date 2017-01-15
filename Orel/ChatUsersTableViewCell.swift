//
//  ChatUsersTableViewCell.swift
//  Orel
//
//  Created by Etjen Ymeraj on 4/10/16.
//  Copyright © 2016 Etjen Ymeraj. All rights reserved.
//

import UIKit

class ChatUsersTableViewCell: UITableViewCell {

    @IBOutlet weak var profileNameLabel: UILabel!
    
    @IBOutlet weak var profileImg: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        let theWidth = UIScreen.main.bounds.width
        
        contentView.frame = CGRect(x: 0, y: 0, width: theWidth, height: 120)
        
        profileImg.center = CGPoint(x: 60, y: 60)
        profileImg.layer.cornerRadius = profileImg.frame.size.width/2
        profileImg.clipsToBounds = true
        profileNameLabel.center = CGPoint(x: 230, y: 55)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
