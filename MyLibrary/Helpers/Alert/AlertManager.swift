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
    static func presentAlert(withTitle title: String,
                             message: String,
                             withCancel: Bool = false,
                             on controller: UIViewController,
                             cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                             actionHandler: ((UIAlertAction) -> Void)?) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: Text.ButtonTitle.okTitle, style: .default, handler: actionHandler))
            if withCancel {
                alertController.addAction(UIAlertAction(title: Text.ButtonTitle.cancel, style: .cancel, handler: cancelHandler))
            }
            controller.present(alertController, animated: true)
        }
    }
    /// Alert with  and Input textfield and Ok and Cancel button.
    /// - Parameters:
    ///  - title: Title message String
    ///  - message: Message String
    ///  - actionTitle: Ok button string title
    ///  - cancelTitle: Cancel button string title
    ///  - inputText: Textfield value
    ///  - inputPlaceHolder: Textfield placeholder text
    ///  - inputKeyboardType: Textfield keyboard type
    ///  - on: UIViewController where the alert is presented on
    ///  - cancelHandler: Closure to do something when the Cancel button is pressed
    ///  - actionHanfler: Closure to do something when the Ok button is pressed
    static func showInputDialog(title: String? = nil,
                                subtitle: String? = nil,
                                actionTitle: String? = Text.ButtonTitle.add,
                                cancelTitle: String? = Text.ButtonTitle.cancel,
                                inputText: String? = nil,
                                inputPlaceholder: String? = nil,
                                inputKeyboardType: UIKeyboardType = UIKeyboardType.default,
                                on controller: UIViewController,
                                cancelHandler: ((UIAlertAction) -> Void)? = nil,
                                actionHandler: ((_ text: String?) -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
            alert.addTextField { (textfield: UITextField) in
                textfield.text = inputText
                textfield.placeholder = inputPlaceholder
                textfield.keyboardType = inputKeyboardType
                textfield.autocapitalizationType = .sentences
            }
            alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { _ in
                guard let textField =  alert.textFields?.first else {
                    actionHandler?(nil)
                    return
                }
                actionHandler?(textField.text)
            }))
            alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
            controller.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Banner
    /// Present an aler Banner
    /// - Parameters:
    /// - type: Type of banner (.error, .success, or .customMessage type)
    /// - subtitle:  Optional subtitle string, empty by default.
    static func presentAlertBanner(as type: AlertBannerType, subtitle: String = "") {
        DispatchQueue.main.async {
            Bauly.shared.forcePresent(configurationHandler: { bauly in
                bauly.title = type.message
                bauly.subtitle = subtitle
            }, duration: 1, dismissAfter: 2, feedbackStyle: .medium)
     }
    }
}
