//
//  Assets.swift
//  MyLibrary
//
//  Created by Birkyboy on 26/10/2021.
//

import UIKit

enum Images {
    
    private static let configuration = UIImage.SymbolConfiguration(pointSize: 23, weight: .regular, scale: .large)
    
    static let scanBarcode = UIImage(systemName: "viewfinder.circle.fill", withConfiguration: Images.configuration)
    static let editBookIcon = UIImage(systemName: "pencil.circle", withConfiguration: Images.configuration)
    static let gridLayoutMenu = UIImage(systemName: "ellipsis.circle.fill", withConfiguration: Images.configuration)
    
    static let welcomeScreen = UIImage(named: "welcomeScreenImage")
    static let homeIcon = UIImage(systemName: "house.fill")
    static let openBookIcon = UIImage(systemName: "book.fill")
    static let booksIcon = UIImage(systemName: "books.vertical.fill")
    static let searchIcon = UIImage(systemName: "magnifyingglass")
    static let accountIcon = UIImage(systemName: "person.fill")
    static let newBookIcon = UIImage(systemName: "plus.circle.fill")
    static let emptyStateBookImage = UIImage(named: "cover")
    static let favoriteImage = UIImage(systemName: "heart.fill")
    static let editCircleIcon = UIImage(systemName: "pencil.circle.fill")!
    static let addIcon = UIImage(systemName: "plus")
    static let commentIcon = UIImage(systemName: "plus.bubble")
    static let trashCircleIcon = UIImage(systemName: "trash.circle.fill")!
    static let gridHalfLayout = UIImage(systemName: "square.grid.2x2.fill")!
    static let gridThirdLayout = UIImage(systemName: "square.grid.3x2.fill")!
    static let gridQuarterLayout = UIImage(systemName: "square.grid.4x3.fill")!
    static let gridFifthLayout = UIImage(systemName: "square.grid.3x3.fill")!
}
