//
//  EventTableViewCell.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 08.11.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var tintView: UIView!
    //@IBOutlet weak var bgImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
                
        bgImageView.layer.cornerRadius = 20
        bgImageView.layer.masksToBounds = true
        
        tintView.layer.cornerRadius = 20
        tintView.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    override func layoutSubviews() {
//        let f = contentView.frame
//        let fr = UIEdgeInsetsInsetRect(f, UIEdgeInsetsMake(10, 10, 10, 10))
//        contentView.frame = fr
//    }
//    
}
