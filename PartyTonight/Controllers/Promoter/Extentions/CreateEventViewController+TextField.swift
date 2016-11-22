//
//  CreateEventViewController+TextField.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 15.11.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import Foundation
import UIKit
extension CreateEventViewController: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch (textField) {
        case locationTextField:
             performSegue(withIdentifier: "ChooseLocationSegue", sender: textField)
            
        case dateAndTimeTextField:
            performSegue(withIdentifier: "createEventDatetimePopover", sender: textField)
            
        default:
            return true;
            
        }
       
        return false;
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let mapVC = segue.destination as? ChooseLocationViewController{
//            mapVC.delegate = self;
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       //print("prepare")
        switch (segue.identifier) {
        case "createEventDatetimePopover"?:
            if let controller = segue.destination as? DateTimePickerViewController {
                controller.popoverPresentationController!.delegate = self
                controller.preferredContentSize = CGSize(width: 300, height: 300)
                controller.delegate = self;
            }
        default:
            if let mapVC = segue.destination as? ChooseLocationViewController{
                mapVC.delegate = self;
            }
        }
    }
    
    
    func userDidChooseLocation(info: String){
        locationTextField.text = info;
        //for rx
        locationTextField.sendActions(for: .editingDidBegin)
    }
    
    func userDidChooseDateTime(date: Date) {
        dateAndTimeTextField.text = date.string(format: "EEEE, d MMM yyyy HH:mm")
        dateAndTimeTextField.sendActions(for: .editingDidBegin)
    }

}
