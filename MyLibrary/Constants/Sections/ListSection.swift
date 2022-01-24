//
//  ListSection.swift
//  MyLibrary
//
//  Created by Birkyboy on 24/01/2022.
//

enum ListSection: CaseIterable {
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
}
