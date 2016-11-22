//
//  GoerLoginViewController.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 18.11.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import UIKit

class GoerLoginViewController: UIViewController {


    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

         setTextFieldInsets()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setTextFieldInsets(){
        loginTextField.leftView = UIView(frame:CGRect(x: 0, y: 0, width: 60, height: 30))
        loginTextField.leftViewMode = UITextFieldViewMode.always
        loginTextField.attributedPlaceholder = NSAttributedString(string:"E-mail",
                                                                  attributes:[NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Aguda-Regular2", size: 18.0)! ])
        
        passwordTextField.leftView = UIView(frame:CGRect(x: 0, y: 0, width: 60, height: 30))
        passwordTextField.leftViewMode = UITextFieldViewMode.always
        passwordTextField.attributedPlaceholder = NSAttributedString(string:"Password",
                                                                     attributes:[NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Aguda-Regular2", size: 18.0)! ])
        
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
