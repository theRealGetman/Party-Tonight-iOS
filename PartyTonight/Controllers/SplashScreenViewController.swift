//
//  SplashScreenViewController.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 22.11.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {

    @IBOutlet weak var getStartedButton: UIButton!
    let blur = UIVisualEffectView(effect: UIBlurEffect(style:
        UIBlurEffectStyle.light))
    override func viewDidLoad() {
        super.viewDidLoad()
       
        blur.frame = CGRect(x: getStartedButton.bounds.origin.x+2, y: getStartedButton.bounds.origin.y+2, width: getStartedButton.bounds.width-4, height: getStartedButton.bounds.height-4)
        blur.isUserInteractionEnabled = false //This allows touches to forward to the button.
        getStartedButton.insertSubview(blur, at: 0)
    }
    
    override func viewDidLayoutSubviews() {
        blur.frame = CGRect(x: getStartedButton.bounds.origin.x+2, y: getStartedButton.bounds.origin.y+2, width: getStartedButton.bounds.width-4, height: getStartedButton.bounds.height-4)
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
