//
//  CategoriesFormatter.swift
//  MyLibrary
//
//  Created by Birkyboy on 26/12/2021.
//

import UIKit

class CategoriesFormatter {
    
    func formattedString(for categories: [CategoryModel]) -> NSAttributedString {
        let text = NSMutableAttributedString()
        categories.forEach {
            let attachment = imageStringAttachment(for: $0, size: 11)
            let imgString = NSAttributedString(attachment: attachment)
            let name = $0.name?.uppercased() ?? ""
            text.append(imgString)
            text.append(NSAttributedString(string: "\u{00a0}\(name)    "))
        }
        return text
    }
    
    private func imageStringAttachment(for category: CategoryModel, size: CGFloat) -> NSTextAttachment {
        let color = UIColor(hexString: category.color ?? "FFFFFF")
        let image = Images.ButtonIcon.selectedCategoryBadge.withTintColor(color)
        let attachment = NSTextAttachment()
        attachment.bounds = CGRect(x: 0, y: 0, width: size, height: size)
        attachment.image = image
        return attachment
    }
}
