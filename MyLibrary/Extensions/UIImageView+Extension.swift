//
//  UIImageView+Extension.swift
//  MyLibrary
//
//  Created by Birkyboy on 28/11/2021.
//

import UIKit
import Kingfisher

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
    
    func getImage(for url: String?, completion: @escaping (UIImage) -> Void) {
        guard let url = url, let imageURL = URL(string: url) else {
            completion(Images.emptyStateBookImage)
            return
        }
        let options: KingfisherOptionsInfo = [.cacheOriginalImage,
                                              .keepCurrentImageWhileLoading,
                                              .callbackQueue(.mainAsync)]
        KingfisherManager.shared.retrieveImage(with: imageURL,
                                               options: options,
                                               completionHandler: { (response) in
            switch response {
            case .success(let value):
                completion(value.image)
            case .failure(_):
                completion(Images.emptyStateBookImage)
            }
        })
    }
}
