//
//  DateTimePickerViewController.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 16.11.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import UIKit

class DateTimePickerViewController: UIViewController {
    @IBOutlet weak var datePicker: UIDatePicker!

    @IBAction func applyButtonTouched(_ sender: UIButton) {
        delegate?.userDidChooseDateTime(date: datePicker.date)
        self.dismiss(animated: true, completion: nil)
    }
    
 
    weak var delegate: DataEnteredDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.minimumDate = Date();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
