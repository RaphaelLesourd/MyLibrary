//
//  CategoriesFormatter.swift
//  MyLibrary
//
//  Created by Birkyboy on 26/12/2021.
//

import UIKit

class CategoriesFormatter {

    /// Convert a list of CategoryDTO to a Attributed sting with and icon tinted with the category color.
    /// - Parameters:
    /// - categories: Arry of CategoryDTO
    /// - returns: NSattibuted sting of all the categories with an icon.
    func formattedString(for categories: [CategoryDTO]) -> NSAttributedString {
        let text = NSMutableAttributedString()
        categories.forEach {
            let attachment = imageStringAttachment(for: $0.color, size: 11)
            let imgString = NSAttributedString(attachment: attachment)
            let name = $0.name.uppercased()
            text.append(imgString)
            text.append(NSAttributedString(string: "\u{00a0}\(name)    "))
        }
        return text
    }
    /// Create an icon to attch to the category name and give the icon a tint corresponding to the categorie color property.
    /// - Parameters:
    ///  - color: Hex String value of the color.
    ///  - size: CGFloat value of the icon desired size.
    ///  - returns: NStextAttachment to attach the the category name.
    private func imageStringAttachment(for color: String, size: CGFloat) -> NSTextAttachment {
        let color = UIColor(hexString: color)
        let image = Images.ButtonIcon.selectedCategoryBadge.withTintColor(color)
        let attachment = NSTextAttachment()
        attachment.bounds = CGRect(x: 0, y: 0, width: size, height: size)
        attachment.image = image
        return attachment
    }
}
