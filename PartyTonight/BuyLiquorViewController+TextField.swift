//
//  BuyLiquorViewController+TextField.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 04.02.17.
//  Copyright © 2017 Igor Kasyanenko. All rights reserved.
//

import Foundation
import UIKit
extension BuyLiquorViewController: UITextFieldDelegate{
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let superView = textField.superview?.superview?.superview as? LiquorView {
            self.popover(sourceView: superView, data: bottles)
        }

       
//        switch (textField) {
//        case locationTextField:
//            performSegue(withIdentifier: "ChooseLocationSegue", sender: textField)
//            
//        case dateAndTimeTextField:
//            performSegue(withIdentifier: "createEventDatetimePopover", sender: textField)
//            
//        default:
//            return true;
//            
//        }
        
              
        return false;
}
}


