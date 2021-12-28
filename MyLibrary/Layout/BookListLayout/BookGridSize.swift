//
//  BookGridSize.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/12/2021.
//

import UIKit

enum BookGridSize: CGFloat, CaseIterable {
    case large = 0.5
    case medium = 0.33333
    case small = 0.25
    case extraSmall = 0.13
    
    var title: String {
        switch self {
        case .large:
            return Text.ListMenu.large
        case .medium:
            return Text.ListMenu.medium
        case .small:
            return Text.ListMenu.small
        case .extraSmall:
            return Text.ListMenu.xsmall
        }
    }
    
    var image: UIImage {
        switch self {
        case .large:
            return Images.LayoutMenu.gridLargeLayout
        case .medium:
            return Images.LayoutMenu.gridMediumLayout
        case .small:
            return Images.LayoutMenu.gridSmallLayout
        case .extraSmall:
            return Images.LayoutMenu.gridExtraSmallLayout
        }
    }
}
