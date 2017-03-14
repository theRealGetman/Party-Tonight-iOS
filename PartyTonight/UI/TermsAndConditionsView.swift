//
//  TermsAndConditionsView.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 12.03.17.
//  Copyright © 2017 Igor Kasyanenko. All rights reserved.
//

import UIKit

class TermsAndConditionsView: UIView {
    @IBOutlet var contentView: UIView!

    @IBOutlet weak var textView: UITextView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect)  {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        
        self.backgroundColor = UIColor.clear;
        
        let nib = UINib(nibName: "TermsAndConditionsView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds

        heightAnchor.constraint(equalToConstant: bounds.height).isActive = true
        addSubview(contentView)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
    }
    


}
