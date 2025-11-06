//
//  AlertHelper.swift
//  RickNMorty
//
//  Created by Kazuha on 31/10/25.
//

import UIKit

/// A reusable alert helper for displaying alert dialogs throughout your project
class AlertHelper {
    
    /// Shows an alert dialog with customizable title, message, and actions
    /// - Parameters:
    ///   - viewController: The view controller that will present the alert
    ///   - title: The title of the alert (optional)
    ///   - message: The message body of the alert (optional)
    ///   - primaryActionTitle: Title for the primary button (default: "OK")
    ///   - primaryActionStyle: Style for the primary button (default: .default)
    ///   - primaryActionHandler: Closure to execute when primary button is tapped (optional)
    ///   - secondaryActionTitle: Title for the secondary button (optional, if nil only one button is shown)
    ///   - secondaryActionStyle: Style for the secondary button (default: .cancel)
    ///   - secondaryActionHandler: Closure to execute when secondary button is tapped (optional)
    static func showAlert(
        on viewController: UIViewController,
        title: String? = nil,
        message: String? = nil,
        primaryActionTitle: String = "OK",
        primaryActionStyle: UIAlertAction.Style = .default,
        primaryActionHandler: ((UIAlertAction) -> Void)? = nil,
        secondaryActionTitle: String? = nil,
        secondaryActionStyle: UIAlertAction.Style = .cancel,
        secondaryActionHandler: ((UIAlertAction) -> Void)? = nil
    ) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        // Add primary action
        let primaryAction = UIAlertAction(
            title: primaryActionTitle,
            style: primaryActionStyle,
            handler: primaryActionHandler
        )
        alertController.addAction(primaryAction)
        
        if let secondaryTitle = secondaryActionTitle {
            let secondaryAction = UIAlertAction(
                title: secondaryTitle,
                style: secondaryActionStyle,
                handler: secondaryActionHandler
            )
            alertController.addAction(secondaryAction)
        }
        alertController.preferredAction = primaryAction
        alertController.view.tintColor = .appAccent
        
        viewController.present(alertController, animated: true)
    }
}
