//
//  GoerMenuViewController.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 12.03.17.
//  Copyright © 2017 Igor Kasyanenko. All rights reserved.
//

import UIKit
import RxSwift

class GoerMenuViewController: UIViewController {
    
    let disposeBag = DisposeBag();
    
    @IBAction func contactUsButtonTouched(_ sender: UIButton) {
        contactUsAlert()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func logoutButtonTouched(_ sender: UIBarButtonItem) {
        logout()
    }
    @IBAction func callACabButtonTouched(_ sender: UIButton) {
        callACabUsingUber()
    }
    
    private func callACabUsingUber(){
        
//        let uberUrlString = String(format:"uber://?client_id=YOUR_CLIENT_ID&action=setPickup&pickup=my_location&dropoff[formatted_address]=%@","")
 
        if let uberURL = URL(string:"uber://"), let  appStoreURL = URL(string:"itms-apps://itunes.apple.com/us/app/uber/id368677368?mt=8"){
            if (UIApplication.shared.canOpenURL(uberURL))
            {
                UIApplication.shared.openURL(uberURL);
            }
            else
            {
                UIApplication.shared.openURL(appStoreURL);
            }
        }else{
            //
        }
    }
    
    private func goToGoerPromoterMenu(){
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "GoerPromoterMenu") {
            present(vc, animated: true, completion: nil)
        }
    }
    
    private func logout(){
        SharedCart.shared.clear()
        
        APIManager.sharedAPI.logout().subscribe(onNext: { (result) in
            self.goToGoerPromoterMenu()
        }, onError: { (error) in
            DefaultWireframe.presentAlert("\(error)", completion: { (action) in
                self.goToGoerPromoterMenu()
            })
        }, onCompleted: {
            
        }) {
            
            }.addDisposableTo(disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func contactUsAlert(){
        let alertController = UIAlertController(title: "Contact Us", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        var contactUs = "";
        do {
            contactUs = try String(contentsOf: Bundle.main.url(forResource: "ContactUs", withExtension:"txt")!)
        }catch {}
        
        let agreeAction = UIAlertAction(title: "Ok", style: .default, handler: {(alert: UIAlertAction!) in
        })
        alertController.addAction(agreeAction)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        let messageText = NSMutableAttributedString(
            string: contactUs,
            attributes: [
                NSParagraphStyleAttributeName: paragraphStyle,
                NSFontAttributeName: UIFont.systemFont(ofSize: 13.0)
            ]
        )
        alertController.setValue(messageText, forKey: "attributedMessage")
        self.present(alertController, animated: true, completion: nil)
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
