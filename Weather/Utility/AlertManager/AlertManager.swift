//
//  AlertManager.swift
//  Weather
//
//  Created by Kumar,Vishal on 29/05/21.
//

import Foundation
import UIKit

class AlertManager {
    /// Showing Alert
    /// - Parameter title: Title of alert
    /// - Parameter message: Message
    /// - Parameter viewController: View Controller to be shown
    class func showAlert(withTitle title: String, message: String) {
        if let controller = UIApplication.topViewController() {
            let localizedTitle = title
            let localizedMessage = message
            let buttonTitle = "ok"
            let alert = UIAlertController(title: localizedTitle, message: localizedMessage, preferredStyle: .alert)
            let action = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
            alert.addAction(action)
            controller.present(alert, animated: true, completion: nil)
        }
    }
}
