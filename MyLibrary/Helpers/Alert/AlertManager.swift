//
//  AlertManager.swift
//  MyLibrary
//
//  Created by Birkyboy on 07/12/2021.
//

import UIKit
import Bauly

class AlertManager {
    /// Simple Alert with and Ok and Cancel button.
    /// - Parameters:
    ///  - title: Title message String
    ///  - message: message String
    ///  - withCancel: Bool to chosse if a cancel button is to be displayed
    ///  - on: UIViewController where the alert is presented on
    ///  - cancelHandler: Closure to do something when the Cancel button is pressed
    ///  - actionHanfler: Closure to do something when the Ok button is pressed
    static func presentAlert(title: String,
                             message: String,
                             cancel: Bool = false,
                             cancelHandler: ((UIAlertAction) -> Void)? = nil,
                             actionHandler: ((UIAlertAction) -> Void)?) {

        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: Text.ButtonTitle.okTitle,
                                   style: .default,
                                   handler: actionHandler)
        alert.addAction(action)
        if cancel {
            let cancelAction = UIAlertAction(title: Text.ButtonTitle.cancel,
                                             style: .cancel,
                                             handler: cancelHandler)
            alert.addAction(cancelAction)
        }
        let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        if var topController = window?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.present(alert, animated: true, completion: nil)
        }
    }

    /// Present an aler Banner
    /// - Parameters:
    /// - type: Type of banner (.error, .success, or .customMessage type)
    /// - subtitle:  Optional subtitle string, empty by default.
    static func presentAlertBanner(as type: AlertBannerType, subtitle: String? = "") {
        DispatchQueue.main.async {
            Bauly.shared.forcePresent(configurationHandler: { bauly in
                bauly.title = type.message
                bauly.subtitle = subtitle
            }, duration: 1, dismissAfter: 2, feedbackStyle: .medium)
        }
    }
}
