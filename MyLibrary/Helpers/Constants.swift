//
//  Constants.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import Foundation

/// Enum giving name to each section of the HomeController CollectionView for better readability
enum HomeCollectionViewSections: Int, CaseIterable {
    case categories
    case newEntry
    case favorites
    case recommanding
}

enum SearchCollectionViewSections: Int, CaseIterable {
    case librarySearch
    case apiSearch
}
