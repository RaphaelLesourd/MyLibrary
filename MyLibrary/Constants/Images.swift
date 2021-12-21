//
//  Assets.swift
//  MyLibrary
//
//  Created by Birkyboy on 26/10/2021.
//

import UIKit

enum Images {
    
    static let welcomeScreen = UIImage(named: "welcomeScreenImage")
    static let emptyStateBookImage = UIImage(named: "cover")
    
    enum NavIcon {
        private static let configuration = UIImage.SymbolConfiguration(pointSize: 21, weight: .regular, scale: .large)
        
        static let scanBarcode = UIImage(systemName: "viewfinder.circle.fill", withConfiguration: Images.NavIcon.configuration)
        static let editBookIcon = UIImage(systemName: "pencil.circle.fill", withConfiguration: Images.NavIcon.configuration)
        static let gridLayoutMenu = UIImage(systemName: "ellipsis.circle.fill", withConfiguration: Images.NavIcon.configuration)
        static let addIcon = UIImage(systemName: "plus.circle.fill", withConfiguration: Images.NavIcon.configuration)
    }
    
    enum LayoutMenu {
        static let gridHalfLayout = UIImage(systemName: "square.grid.2x2.fill")!
        static let gridThirdLayout = UIImage(systemName: "square.grid.3x2.fill")!
        static let gridQuarterLayout = UIImage(systemName: "square.grid.4x3.fill")!
    }
    
    enum TabBarIcon {
        static let homeIcon = UIImage(systemName: "house.fill")
        static let booksIcon = UIImage(systemName: "books.vertical.fill")
        static let accountIcon = UIImage(systemName: "person.fill")
        static let newBookIcon = UIImage(systemName: "plus.circle.fill")
        static let openBookIcon = UIImage(systemName: "book.fill")
    }
    
    enum EditIcon {
        static let editCircleIcon = UIImage(systemName: "pencil.circle.fill")!
        static let trashCircleIcon = UIImage(systemName: "trash.circle.fill")!
    }
    
    enum ButtonIcon {
        static let favoriteImage = UIImage(systemName: "heart.fill")
    }
}
