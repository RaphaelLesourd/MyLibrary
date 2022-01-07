//
//  Constants.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit

extension UIColor {
    
    /// Convert HEX string to UIColorr
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let alpha, red, green, blue: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: CGFloat(alpha) / 255)
    }
    
    // App colors
    static let viewControllerBackgroundColor: UIColor = .secondarySystemBackground
    static let cellBackgroundColor: UIColor = UIColor.label.withAlphaComponent(0.04)
    static let appTintColor: UIColor = UIColor(named: "AccentColor") ?? .systemOrange
    static let ratingColor: UIColor = .systemOrange
    static let favoriteColor: UIColor = .systemPink
    static let notFavorite: UIColor = .white
}
