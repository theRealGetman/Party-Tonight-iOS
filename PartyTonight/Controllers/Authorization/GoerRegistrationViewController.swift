//
//  GoerRegistrationViewController.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 18.11.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import UIKit
import RxSwift
class GoerRegistrationViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    let disposeBag = DisposeBag();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModel = GoerRegistrationViewModel(
            input: (
                username: nameTextField.rx.text.orEmpty.asObservable(),
                address: addressTextField.rx.text.orEmpty.asObservable(),
                birthday: birthdayTextField.rx.text.orEmpty.asObservable(),
                email: emailTextField.rx.text.orEmpty.asObservable(),
                password: passwordTextField.rx.text.orEmpty.asObservable(),
                signupTaps: signupButton.rx.tap.asObservable()
            ),
            API: (APIManager.sharedAPI)
        )
        
        
        
        addBindings(to: viewModel);
        
        setTextFieldInsets()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addBindings(to viewModel: GoerRegistrationViewModel) {
        //test
        viewModel.userToken.subscribe(onNext: { (token) in
            
            switch token {
            case .Success(let token):
                print("User registered: \(token)")
                APIManager.sharedAPI.userToken = token
                self.goToGoerScreen()
            case .Failure(let error):
                 print("Goer error \(error.localizedDescription)")
                if let e = error as? APIError{
                   
                    if e.description.range(of:"401") != nil{
                        DefaultWireframe.presentAlert("Check your email for registration and confirm your account.", completion: { action in self.goToGoerLoginScreen()  })
                    } else if e.description.range(of:"500") != nil{
                        DefaultWireframe.presentAlert("Internal server error. Please, contact our administrator to verify your account manually")
                    }else{
                        DefaultWireframe.presentAlert("Wrong input data, please, change it\n\(e.description)")
                        return
                    }

                    
                    
                } else if let e = error as? ValidationResult{
                    DefaultWireframe.presentAlert(e.description)
                }
                
                break
            }
        }, onError: { (error) in
            print("Caught an error: \(error)")
        }, onCompleted:{
            print("completed")
        })
            .addDisposableTo(disposeBag)
        
        
    }
    
    private func goToGoerLoginScreen(){
        performSegue(withIdentifier: "goerLoginScreenSegue", sender: nil)
    }
    
    
    private func goToGoerScreen(){
        if let goerNavVC = self.storyboard?.instantiateViewController(withIdentifier: "GoerNavVC") as? GoerNavController{
            present(goerNavVC, animated: true, completion: nil)
        }
    }
    
    func setTextFieldInsets(){
        
        nameTextField.attributedPlaceholder = NSAttributedString(string:"Name", attributes:[NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Aguda-Regular2", size: 18.0)! ])
        
        addressTextField.attributedPlaceholder = NSAttributedString(string:"Address", attributes:[NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Aguda-Regular2", size: 18.0)! ])
        
        birthdayTextField.attributedPlaceholder = NSAttributedString(string:"Birthday", attributes:[NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Aguda-Regular2", size: 18.0)! ])
        
        emailTextField.attributedPlaceholder = NSAttributedString(string:"E-mail", attributes:[NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Aguda-Regular2", size: 18.0)! ])
        
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
