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
    func showIndicator(_ indicator: UIActivityIndicatorView) {
        indicator.startAnimating()
    }

    func hideIndicator(_ indicator: UIActivityIndicatorView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            indicator.stopAnimating()
        }
    }
    
    // MARK: - Keyboard
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self,action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
