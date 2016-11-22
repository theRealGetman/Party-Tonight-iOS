//
//  UIApplication+TopViewController.swift
//  PartyTonight
//
//  Created by Igor Kasyanenko on 18.11.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    class func topViewController(baseViewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let navigationController = baseViewController as? UINavigationController {
            return topViewController(baseViewController: navigationController.visibleViewController)
        }
        
        if let tabBarViewController = baseViewController as? UITabBarController {
            
            let moreNavigationController = tabBarViewController.moreNavigationController
            
            if let topViewController1 = moreNavigationController.topViewController, topViewController1.view.window != nil {
                return topViewController(baseViewController: topViewController1)
            } else if let selectedViewController = tabBarViewController.selectedViewController {
                return topViewController(baseViewController: selectedViewController)
            }
        }
        
        if let splitViewController = baseViewController as? UISplitViewController, splitViewController.viewControllers.count == 1 {
            return topViewController(baseViewController: splitViewController.viewControllers[0])
        }
        
        if let presentedViewController = baseViewController?.presentedViewController {
            return topViewController(baseViewController: presentedViewController)
        }
        
        return baseViewController
    }
}
