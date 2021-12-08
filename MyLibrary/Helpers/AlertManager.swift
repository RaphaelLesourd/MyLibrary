//
//  AlertManager.swift
//  MyLibrary
//
//  Created by Birkyboy on 07/12/2021.
//

import UIKit
import Bauly

class AlertManager {
    
    static func presentAlert(withTitle title: String,
                             message: String,
                             withCancel: Bool = false,
                             on controller: UIViewController,
                             cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                             actionHandler: ((UIAlertAction) -> Void)?) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: actionHandler))
            if withCancel {
                alertController.addAction(UIAlertAction(title: "Annulez", style: .cancel, handler: cancelHandler))
            }
            controller.present(alertController, animated: true)
        }
    }
    
    static func showInputDialog(title: String? = nil,
                                subtitle: String? = nil,
                                actionTitle: String? = "Ajouter",
                                cancelTitle: String? = "Annuler",
                                inputText: String? = nil,
                                inputPlaceholder: String? = nil,
                                inputKeyboardType: UIKeyboardType = UIKeyboardType.default,
                                on controller: UIViewController,
                                cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                                actionHandler: ((_ text: String?) -> Void)? = nil) {
        
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
    
    // MARK: - Banner
    static func presentAlertBanner(as type: AlertBannerType, subtitle: String = "") {
        DispatchQueue.main.async {
            Bauly.shared.forcePresent(configurationHandler: { bauly in
                bauly.title = type.message
                bauly.subtitle = subtitle
            }, duration: 1, dismissAfter: 2, feedbackStyle: .medium)
        }
    }
}
