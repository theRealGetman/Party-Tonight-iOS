//
//  BottlesTablesCell.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 19.11.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import UIKit

class BottlesTablesCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var availableAmountLabel: UILabel!
    
    @IBOutlet weak var purchasedAmountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
