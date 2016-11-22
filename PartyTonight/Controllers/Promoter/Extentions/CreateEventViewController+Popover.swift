//
//  CreateEventViewController+Popover.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 16.11.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import Foundation
import UIKit

extension CreateEventViewController: UIPopoverPresentationControllerDelegate{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    
    
}
