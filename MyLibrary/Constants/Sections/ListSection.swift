//
//  ListSection.swift
//  MyLibrary
//
//  Created by Birkyboy on 24/01/2022.
//

enum ListSection: Int, CaseIterable {
    case favorite
    case others
    
    var headerTitle: String {
        switch self {
        case .favorite:
            return "FAVORITES".uppercased()
        case .others:
            return "OTHERS".uppercased()
        }
    }
    
    var footerTitle: String {
        switch self {
        case .favorite:
            return "Swipe left to remove from favorite"
        case .others:
            return Text.SectionTitle.listFooter
        }
    }
}
