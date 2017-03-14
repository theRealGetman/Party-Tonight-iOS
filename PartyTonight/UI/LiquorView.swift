//
//  LiquorView.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 04.02.17.
//  Copyright © 2017 Igor Kasyanenko. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
class LiquorView:UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var stackView: UIStackView!
    
    
    @IBOutlet weak var typeTextField: UITextField!
    var typeEntity: Variable<Bottle?> = Variable<Bottle?>(nil)
    
    
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
        
        let nib = UINib(nibName: "LiquorView", bundle: nil)
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
        typeTextField.attributedPlaceholder = NSAttributedString(string:"Bottle type", attributes:[NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Aguda-Regular2", size: 18.0)! ])
        
        priceTextField.attributedPlaceholder = NSAttributedString(string:"Bottle price", attributes:[NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Aguda-Regular2", size: 18.0)! ])
        
        quantityTextField.attributedPlaceholder = NSAttributedString(string:"Quantity", attributes:[NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Aguda-Regular2", size: 18.0)! ])
        
    }
    
    
    
    

}


