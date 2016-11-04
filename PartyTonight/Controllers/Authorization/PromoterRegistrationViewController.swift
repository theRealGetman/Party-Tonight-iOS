//
//  PromoterRegistrationViewController.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 30.10.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import UIKit
import RxSwift

class PromoterRegistrationViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var billingInfoTextField: UITextField!
    
    @IBOutlet weak var emergencyContactTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signupButton: UIButton!
    
    let disposeBag = DisposeBag();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModel = RegistrationViewModel(
            input: (
                username: nameTextField.rx.text.orEmpty.asObservable(),
                phone: phoneNumberTextField.rx.text.orEmpty.asObservable(),
                email: emailTextField.rx.text.orEmpty.asObservable(),
                billingInfo: billingInfoTextField.rx.text.orEmpty.asObservable(),
                emergencyContact: emergencyContactTextField.rx.text.orEmpty.asObservable(),
                password: passwordTextField.rx.text.orEmpty.asObservable(),
                signupTaps: signupButton.rx.tap.asObservable()
            ),
            API: (APIManager.sharedAPI)
        )
        
        addBindings(to: viewModel)
        
        setTextFieldInsets()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addBindings(to viewModel: RegistrationViewModel) {
        //test
        viewModel.userToken
            .subscribe(onNext: { (user) in
                print("User registered: \(user)")
                }, onError: { (error) in
                    print("Caught an error: \(error)")
            } )
            .addDisposableTo(disposeBag)
    }
    
    
    func setTextFieldInsets(){
        nameTextField.attributedPlaceholder = NSAttributedString(string:"Name", attributes:[NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Aguda-Regular2", size: 18.0)! ])
        
        phoneNumberTextField.attributedPlaceholder = NSAttributedString(string:"Phone number", attributes:[NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Aguda-Regular2", size: 18.0)! ])
        
        emailTextField.attributedPlaceholder = NSAttributedString(string:"E-mail", attributes:[NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Aguda-Regular2", size: 18.0)! ])
        
        billingInfoTextField.attributedPlaceholder = NSAttributedString(string:"Billing info", attributes:[NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Aguda-Regular2", size: 18.0)! ])
        
        emergencyContactTextField.attributedPlaceholder = NSAttributedString(string:"Emergency contact", attributes:[NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Aguda-Regular2", size: 18.0)! ])
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string:"Password", attributes:[NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Aguda-Regular2", size: 18.0)! ])
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
