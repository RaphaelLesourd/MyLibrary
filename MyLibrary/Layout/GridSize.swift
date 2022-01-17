//
//  BookGridSize.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/12/2021.
//

import UIKit

enum GridSize: CGFloat, CaseIterable {
    
    private static let baseSize: CGFloat =  UIDevice.current.userInterfaceIdiom == .pad ? 0.4 : 1
    
    case extraLarge
    case large
    case medium
    case small
    case extraSmall
    
    var title: String {
        switch self {
        case .extraLarge:
            return Text.ListMenu.extraLarge
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
        case .extraLarge:
            return Images.LayoutMenu.gridExtraLargeLayout
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
    
    var size: CGFloat {
        switch self {
        case .extraLarge:
            return GridSize.baseSize
        case .large:
            return GridSize.baseSize * 0.4
        case .medium:
            return GridSize.baseSize * 0.3
        case .small:
            return GridSize.baseSize * 0.25
        case .extraSmall:
            return GridSize.baseSize * 0.15
        }
    }
}
