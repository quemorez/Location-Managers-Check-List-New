//
//  chatTableViewCell.swift
//  Location Managers Check List New
//
//  Created by Zachary Quemore on 7/29/17.
//  Copyright © 2017 Zachary Quemore. All rights reserved.
//

import UIKit

class chatTableViewCell: UITableViewCell {

    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var dateTimeLabel: UILabel!
   // @IBOutlet var messageView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        messageLabel.layer.cornerRadius = 5
        messageLabel.clipsToBounds = true
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

