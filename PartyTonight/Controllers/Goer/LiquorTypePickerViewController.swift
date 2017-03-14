//
//  LiquorTypePickerViewController.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 04.02.17.
//  Copyright © 2017 Igor Kasyanenko. All rights reserved.
//

import UIKit
import RxSwift
class LiquorTypePickerViewController: UIViewController,UIPopoverPresentationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    

    @IBAction func applyTouched(_ sender: UIButton) {
        delegate?.typeEntity.value = bottleList[picker.selectedRow(inComponent: 0)]
        delegate?.typeTextField.text = delegate?.typeEntity.value?.type
        dismiss(animated: true, completion: nil)
    }
    
    var bottleList:[Bottle] = [];
    
    @IBOutlet weak var picker: UIPickerView!
    
    weak var delegate: LiquorView?
    //var bottle:Bottle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.dataSource = self;
        picker.delegate = self;
        
        //delegate?.value = Bottle(price: "0", type: "jjjj", available: "99")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return bottleList.count;
    }
    
 
   
 
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return bottleList[row].type
    }
    
    
    
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
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
