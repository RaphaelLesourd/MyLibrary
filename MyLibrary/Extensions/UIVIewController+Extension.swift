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
    public func presentAlertBanner(as type: AlertBannerType, subtitle: String = "") {
        Bauly.shared.forcePresent(configurationHandler: { bauly in
            bauly.title = type.message
            bauly.subtitle = subtitle
        }, duration: 1, dismissAfter: 2, feedbackStyle: .medium)
    }
    
    // MARK: - Navigation
    func showBookDetails(with book: Item, searchType: SearchType) {
        let bookCardVC = BookCardViewController(book: book)
        bookCardVC.hidesBottomBarWhenPushed = true
        bookCardVC.searchType = searchType
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
