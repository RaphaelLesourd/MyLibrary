//
//  Assets.swift
//  MyLibrary
//
//  Created by Birkyboy on 26/10/2021.
//

import UIKit

enum Images {
    static let welcomeScreen = UIImage(named: "welcomeScreenImage")
    static let emptyStateBookImage = UIImage(named: "cover")!
    static let commentViewBackground = UIImage(named: "commentBubbleBG")
    
    enum NavIcon {
        private static let configuration = UIImage.SymbolConfiguration(pointSize: 21, weight: .regular, scale: .large)
        
        static let scanBarcode = UIImage(systemName: "viewfinder", withConfiguration: Images.NavIcon.configuration)
        static let editBookIcon = UIImage(systemName: "square.and.pencil", withConfiguration: Images.NavIcon.configuration)
        static let gridLayoutMenu = UIImage(systemName: "ellipsis", withConfiguration: Images.NavIcon.configuration)
        static let addIcon = UIImage(systemName: "plus.circle.fill", withConfiguration: Images.NavIcon.configuration)
        static let accountIcon = UIImage(systemName: "person.fill", withConfiguration: Images.NavIcon.configuration)
    }
    
    enum LayoutMenu {
        static let gridExtraLargeLayout = UIImage(systemName: "square.fill")!
        static let gridLargeLayout = UIImage(systemName: "square.grid.2x2.fill")!
        static let gridMediumLayout = UIImage(systemName: "square.grid.3x2.fill")!
        static let gridSmallLayout = UIImage(systemName: "square.grid.3x3.fill")!
        static let gridExtraSmallLayout = UIImage(systemName: "square.grid.4x3.fill")!
    }
    
    enum TabBarIcon {
        static let homeIcon = UIImage(systemName: "house.fill")!
        static let booksIcon = UIImage(systemName: "books.vertical.fill") ?? UIImage(systemName: "book.fill")!
        static let accountIcon = UIImage(systemName: "person.fill")!
        static let newBookIcon = UIImage(systemName: "plus.circle.fill")!
        static let openBookIcon = UIImage(systemName: "book.fill")!
    }
    
    enum ContextMenuIcon {
        static let editCircleIcon = UIImage(systemName: "square.and.pencil")!
        static let trashCircleIcon = UIImage(systemName: "trash.fill")!
    }
    
    enum ButtonIcon {
        static let favorite = UIImage(systemName: "heart.fill")
        static let lightBulbOn = UIImage(systemName: "lightbulb.slash.fill")
        static let lightBulbOff = UIImage(systemName: "lightbulb.fill")
        static let selectedCategoryBadge = UIImage(systemName: "circle.inset.filled") ?? UIImage(systemName: "checkmark.circle.fill")!
        static let categoryBadge = UIImage(systemName: "circle.fill")
        static let feedBack = UIImage(systemName: "envelope.badge.fill")!
        static let save = UIImage(systemName: "arrow.down.doc.fill")!
        static let done = UIImage(systemName: "hand.tap.fill")!
        static let chat = UIImage(systemName: "bubble.left.and.bubble.right.fill")!
        static let search = UIImage(systemName: "magnifyingglass")!
        static let rightChevron = UIImage(systemName: "chevron.forward")!
    }
    
    enum Onboarding {
        static let referencing = UIImage(named: "screen1")!
        static let searching = UIImage(named: "screen2")!
        static let sharing = UIImage(named: "screen3")!
    }
}
