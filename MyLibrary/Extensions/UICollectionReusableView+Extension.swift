//
//  UICollectionReusableView+Extension.swift
//  MyLibrary
//
//  Created by Birkyboy on 31/10/2021.
//

import Foundation
import UIKit

extension UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
