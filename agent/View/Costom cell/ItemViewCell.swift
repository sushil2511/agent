//
//  ItemViewCell.swift
//  agent
//
//  Created by Sushil Shinde on 30/10/18.
//  Copyright © 2018 Sushil Shinde. All rights reserved.
//

import UIKit

class ItemViewCell: UITableViewCell {

	@IBOutlet weak var countryCode: UILabel!
	@IBOutlet weak var countryName: UILabel!
	@IBOutlet weak var continentName: UILabel!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
