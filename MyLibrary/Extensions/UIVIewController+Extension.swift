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
    
    // MARK: - Banner
    func presentAlertBanner(as type: AlertBannerType, subtitle: String = "") {
        Bauly.shared.forcePresent(configurationHandler: { bauly in
            bauly.title = type.message
            bauly.subtitle = subtitle
        }, duration: 1, dismissAfter: 2, feedbackStyle: .medium)
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
        let newBookController = NewBookViewController()
        newBookController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(newBookController, animated: true)
    }
    
    @objc func showBookDetails() {
        let bookCardVC = BookCardViewController()
        bookCardVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(bookCardVC, animated: true)
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
