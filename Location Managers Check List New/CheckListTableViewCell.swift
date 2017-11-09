//
//  CheckListTableViewCell.swift
//  Location Managers Check List New
//
//  Created by Zachary Quemore on 7/26/17.
//  Copyright © 2017 Zachary Quemore. All rights reserved.
//

import UIKit

class CheckListTableViewCell: UITableViewCell {
    
    var checkAction: ((UITableViewCell) -> Void)?
    
    @IBOutlet var CheckListItemLabel: UILabel!
    
    @IBOutlet var CheckButtonOutlet: UIButton!
    
    @IBAction func CheckButtonAction(_ sender: Any) {
        /*
         if CheckButtonOutlet.isSelected == false {
         CheckButtonOutlet.isSelected = true
         } else {
         CheckButtonOutlet.isSelected = false
         }
        */
        
        checkAction?(self)
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
