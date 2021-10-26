//
//  UIVIewController+Extension.swift
//  MyLibrary
//
//  Created by Birkyboy on 24/10/2021.
//

import Foundation
import UIKit

extension UIViewController {
    
    // MARK: - Alert
    func presentAlert(withTitle title: String, message: String, actionHandler: ((UIAlertAction) -> Void)?) {
      DispatchQueue.main.async {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: actionHandler))
        self.present(alertController, animated: true)
      }
    }
    
    // MARK: - NavigationBar
    func addNewBookButton() {
        let infoButton = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(showNewBookController))
        navigationItem.rightBarButtonItem = infoButton
    }
    
    // MARK: - Navigation
    @objc func showNewBookController() {
        let newBookController = WelcomeViewController()
        newBookController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(newBookController, animated: true)
    }
    
    @objc func showBookDetails() {
        let bookCardVC = BookCardViewController()
        bookCardVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(bookCardVC, animated: true)
    }
    
    // MARK: - Keyboard
    func addKeyboardDismissGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard() {
            view.endEditing(true)
    }

    // MARK: - Activity Indicator
    func showIndicator(_ indicator: UIActivityIndicatorView) {
        let barButton = UIBarButtonItem(customView: indicator)
        self.navigationItem.setRightBarButton(barButton, animated: true)
        indicator.startAnimating()
    }

    func hideIndicator(_ indicator: UIActivityIndicatorView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            indicator.stopAnimating()
            self.navigationItem.setRightBarButton(nil, animated: true)
        }
    }
}
