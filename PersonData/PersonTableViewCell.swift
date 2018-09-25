//
//  PersonTableViewCell.swift
//  PersonData
//
//  Created by Jan  on 08.04.2018.
//  Copyright © 2018 Jan . All rights reserved.
//

import UIKit

class PersonTableViewCell: UITableViewCell {
  
    @IBOutlet var navnLabel: UILabel!
    @IBOutlet var adresseLabel: UILabel!
    @IBOutlet var fodselsLabel: UILabel!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
