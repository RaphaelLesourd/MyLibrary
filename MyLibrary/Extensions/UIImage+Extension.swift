//
//  UIImage+Extension.swift
//  MyLibrary
//
//  Created by Birkyboy on 11/11/2021.
//

import UIKit

extension UIImage {
    
    func resizeImage(_ maxSize: CGFloat = 1000) -> UIImage {
        // adjust for device pixel density
        let maxSizePixels = maxSize / UIScreen.main.scale
        // work out aspect ratio
        let aspectRatio = size.width / size.height
        // variables for storing calculated data
        var width: CGFloat
        var height: CGFloat
        if aspectRatio > 1 {
            // landscape
            width = maxSizePixels
            height = maxSizePixels / aspectRatio
        } else {
            // portrait
            height = maxSizePixels
            width = maxSizePixels * aspectRatio
        }
        // create an image renderer of the correct size
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: floor(width), height: floor(height)),
                                               format: UIGraphicsImageRendererFormat.default())
        // render the image
        let newImage = renderer.image { _ in
            self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        }
        // return the image
        return newImage
    }
    
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    /// Returns the data for the specified image in JPEG format.
    func jpegData(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
    
}
