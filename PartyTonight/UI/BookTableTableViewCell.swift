//
//  BookTableTableViewCell.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 04.05.17.
//  Copyright © 2017 Igor Kasyanenko. All rights reserved.
//

import UIKit

class BookTableTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
  
    @IBOutlet weak var isChosenButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
