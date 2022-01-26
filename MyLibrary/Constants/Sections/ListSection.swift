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
            return ""
        case .others:
            return Text.SectionTitle.listFooter
        }
    }
    
    var tag: Int {
        switch self {
        case .favorite:
            return 0
        case .others:
            return 1
        }
    }
}
