//
//  UIVIewController+Extension.swift
//  MyLibrary
//
//  Created by Birkyboy on 24/10/2021.
//

import Foundation
import UIKit

extension UIViewController {
    
    @objc func showBookDetails() {
        let bookCardVC = BookCardViewController()
        navigationController?.pushViewController(bookCardVC, animated: true)
    }
    
    func addScannerButton() {
        let infoButton = UIBarButtonItem(image: UIImage(systemName: "barcode.viewfinder"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(showScannerController))
        navigationItem.rightBarButtonItem = infoButton
    }
    
    // MARK: - Navigation
    @objc func showScannerController() {
        print("Scanning")
    }
}
