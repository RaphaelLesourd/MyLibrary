//
//  Grid.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/12/2021.
//

import UIKit

enum GridItemSize: CGFloat, CaseIterable {
    case large = 0.5
    case medium = 0.33333
    case small = 0.25
    
    var title: String {
        switch self {
        case .large:
            return Text.ListMenu.large
        case .medium:
            return Text.ListMenu.medium
        case .small:
            return Text.ListMenu.small
        }
    }
    
    var image: UIImage {
        switch self {
        case .large:
            return Images.LayoutMenu.gridHalfLayout
        case .medium:
            return Images.LayoutMenu.gridThirdLayout
        case .small:
            return Images.LayoutMenu.gridQuarterLayout
        }
    }
}

