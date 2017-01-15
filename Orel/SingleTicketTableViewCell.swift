//
//  SingleTicketTableViewCell.swift
//  Orel
//
//  Created by Etjen Ymeraj on 3/4/16.
//  Copyright © 2016 Etjen Ymeraj. All rights reserved.
//

import UIKit

class SingleTicketTableViewCell: UITableViewCell {

    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var blurImage: UIImageView!
    
    
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    
    @IBOutlet weak var departureLabel: UILabel!
    @IBOutlet weak var returnLabel: UILabel!
    
    var priceLabel: Double = 0.0
    var userLabel: String!
    
    @IBOutlet weak var blur: UIVisualEffectView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
