//
//  UIVIewController+Extension.swift
//  MyLibrary
//
//  Created by Birkyboy on 24/10/2021.
//

import Foundation
import UIKit
import Bauly

extension UIViewController {
    
    // MARK: - Alert
    func presentAlert(withTitle title: String, message: String, withCancel: Bool = false, actionHandler: ((UIAlertAction) -> Void)?) {
      DispatchQueue.main.async {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: actionHandler))
          if withCancel {
              alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
          }
        self.present(alertController, animated: true)
      }
    }
    
    func showInputDialog(title: String? = nil,
                         subtitle: String? = nil,
                         actionTitle: String? = "Ajouter",
                         cancelTitle: String? = "Annuler",
                         inputText: String? = nil,
                         inputPlaceholder: String? = nil,
                         inputKeyboardType: UIKeyboardType = UIKeyboardType.default,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textfield: UITextField) in
            textfield.text                   = inputText
            textfield.placeholder            = inputPlaceholder
            textfield.keyboardType           = inputKeyboardType
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
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Banner
    public func presentAlertBanner(as type: AlertBannerType, subtitle: String = "") {
        Bauly.shared.forcePresent(configurationHandler: { bauly in
            bauly.title = type.message
            bauly.subtitle = subtitle
        }, duration: 1, dismissAfter: 2, feedbackStyle: .medium)
    }
    
    // MARK: - Navigation
    func showBookDetails(for book: Item, searchType: SearchType) {
        let bookCardVC = BookCardViewController(libraryService: LibraryService(),
                                                recommandationService: RecommandationService())
        bookCardVC.hidesBottomBarWhenPushed = true
        bookCardVC.searchType = searchType
        bookCardVC.book = book
        navigationController?.pushViewController(bookCardVC, animated: true)
    }
 
    // MARK: - NavigationController
    func makeNavigationBarClear() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func restoreNavigationDefaultBar() {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }
    
    // MARK: - Activity Indicator
    func showIndicator(_ indicator: UIActivityIndicatorView) {
        indicator.startAnimating()
    }

    func hideIndicator(_ indicator: UIActivityIndicatorView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            indicator.stopAnimating()
        }
    }
}
