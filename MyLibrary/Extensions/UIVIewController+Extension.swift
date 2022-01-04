//
//  UIVIewController+Extension.swift
//  MyLibrary
//
//  Created by Birkyboy on 24/10/2021.
//

import UIKit
import Bauly

extension UIViewController {
    
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
    /// Shows UIActivity indicator
    ///  - Parameters:
    ///  - indicator: Passed in UIActivityIndicatorView
    func showIndicator(_ indicator: UIActivityIndicatorView) {
        indicator.startAnimating()
    }
    /// Hides UIActivity indicator
    ///  - Parameters:
    ///  - indicator: Passed in UIActivityIndicatorView
    ///  - Note: The animation stops with  delay of 0.3 to allow the user time to see very short acities.
    func hideIndicator(_ indicator: UIActivityIndicatorView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            indicator.stopAnimating()
        }
    }
    
    // MARK: - Keyboard
    /// Dismiss keyboard when the UIViewcontroller view is tapped
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self,action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
