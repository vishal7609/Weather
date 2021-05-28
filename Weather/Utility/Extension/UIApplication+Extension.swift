//
//  UIApplication+Extension.swift
//  Weather
//
//  Created by Kumar,Vishal on 29/05/21.
//

import Foundation
import UIKit

extension UIApplication {
    /// Getting top view controller from uiapplication
    /// - Parameter rootViewController: optional root view controller
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) ->
        UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        // For Tab bar
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        // for presented view controller
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
