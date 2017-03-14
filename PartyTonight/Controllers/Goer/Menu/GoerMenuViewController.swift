//
//  GoerMenuViewController.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 12.03.17.
//  Copyright © 2017 Igor Kasyanenko. All rights reserved.
//

import UIKit

class GoerMenuViewController: UIViewController {
    
    @IBAction func contactUsButtonTouched(_ sender: UIButton) {
        contactUsAlert()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
