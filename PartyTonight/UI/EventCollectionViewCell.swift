//
//  EventCollectionViewCell.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 09.11.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var bgImageView: UIImageView!

    @IBOutlet weak var tintBgView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        tintBgView.layer.cornerRadius = 8
        tintBgView.layer.masksToBounds = true
        bgImageView.layer.cornerRadius = 8
        bgImageView.layer.masksToBounds = true

        // Initialization code
        
    }

}
