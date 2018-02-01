//
//  LocationTableViewCell.swift
//  Location Managers Check List New
//
//  Created by Zachary Quemore on 7/30/17.
//  Copyright © 2017 Zachary Quemore. All rights reserved.
//

import UIKit


class LocationTableViewCell: UITableViewCell {

    @IBOutlet var PregressBar: UIProgressView!
    @IBOutlet var LocationNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
