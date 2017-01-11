//
//  GoerLoginViewController.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 18.11.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import UIKit
import RxSwift
class GoerLoginViewController: UIViewController {


    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let disposeBag = DisposeBag();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewModel = LoginViewModel(
            input: (
                email: loginTextField.rx.text.orEmpty.asObservable(),
                password: passwordTextField.rx.text.orEmpty.asObservable(),
                loginTaps: loginButton.rx.tap.asObservable()
            ),
            API: (APIManager.sharedAPI)
        )
        
        addBindings(to: viewModel)
        
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
    
    
    func addBindings(to viewModel: LoginViewModel) {
        viewModel.userToken.subscribe(onNext: { (token) in
            switch token {
            case .Success(let token):
                print("User signed: \(token.token)")
                APIManager.sharedAPI.userToken = token
                self.goToGoerScreen()
            case .Failure(let error):
                print(error)
                if let e = error as? APIError{
                    DefaultWireframe.presentAlert(e.description)
                } else if let e = error as? ValidationResult{
                    DefaultWireframe.presentAlert(e.description)
                }
            }
        }, onError: { (error) in
            print("Caught an error: \(error)")
        }, onCompleted:{
            print("completed")
        }).addDisposableTo(disposeBag)
    }
    
    private func goToGoerScreen(){
        if let goerNavVC = self.storyboard?.instantiateViewController(withIdentifier: "GoerNavVC") as? GoerNavController{
            present(goerNavVC, animated: true, completion: nil)
        }
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
