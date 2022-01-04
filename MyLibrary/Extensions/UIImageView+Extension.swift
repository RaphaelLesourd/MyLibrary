//
//  UIImageView+Extension.swift
//  MyLibrary
//
//  Created by Birkyboy on 28/11/2021.
//

import UIKit

extension UIImageView {
    /// Add a fade gradient to a UIimageView from clear to any color.
    /// - Parameters:
    /// - color: Ending color of the gradient
    func addFadeGradientFromClear(to color: UIColor = .viewControllerBackgroundColor) {
        let gradientLayer = CAGradientLayer()
        self.layer.sublayers?.removeAll()
        gradientLayer.removeFromSuperlayer()
        gradientLayer.type = .axial
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0).cgColor, color.cgColor]
        gradientLayer.locations = [0.2, 1]
        gradientLayer.frame =  self.bounds
        self.layer.addSublayer(gradientLayer)
    }
}
