//
//  TypePriceQuantityView.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 10.11.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import UIKit

class TypePriceQuantityView: UIView {
    @IBOutlet var contentView: UIView!

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var typeTextField: UITextField!
    
    
    @IBOutlet weak var priceTextField: UITextField!
    
    @IBOutlet weak var quantityTextField: UITextField!
    override func draw(_ rect: CGRect) {
        
    }
    
    
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
        
        let nib = UINib(nibName: "TypePriceQuantityView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        
       // widthAnchor.constraint(equalToConstant: bounds.width).isActive = true
        heightAnchor.constraint(equalToConstant: bounds.height).isActive = true
        //heightAnchor.constraint(equalTo: stackView.heightAnchor, constant: 1)
        //alignmentRectInsets.bottom = 20;
        //contentView.frame = CGRect(x: 0, y: 0, width: 100, height: 100);
        addSubview(contentView)
        
        // custom initialization logic
        //...
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        setTextFieldPlaceholders()
    }
    
    
    func setTextFieldPlaceholders(){
        typeTextField.attributedPlaceholder = NSAttributedString(string:"Type", attributes:[NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Aguda-Regular2", size: 18.0)! ])
        
        priceTextField.attributedPlaceholder = NSAttributedString(string:"Price", attributes:[NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Aguda-Regular2", size: 18.0)! ])
        
        quantityTextField.attributedPlaceholder = NSAttributedString(string:"Quantity", attributes:[NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Aguda-Regular2", size: 18.0)! ])
        
           }

    

    
}
