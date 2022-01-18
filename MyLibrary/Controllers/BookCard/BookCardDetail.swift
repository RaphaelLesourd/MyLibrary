//
//  BookCardDetail.swift
//  MyLibrary
//
//  Created by Birkyboy on 18/01/2022.
//

import UIKit

protocol BookDetail {
    func showBookDetails(for book: Item, searchType: SearchType?, controller: UIViewController)
}

extension BookDetail {
    func showBookDetails(for book: Item, searchType: SearchType?, controller: UIViewController) {
        let bookCardVC = BookCardViewController(book: book,
                                                libraryService: LibraryService(),
                                                recommendationService: RecommandationService())
        bookCardVC.hidesBottomBarWhenPushed = true
        bookCardVC.searchType = searchType
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            let viewController = UINavigationController(rootViewController: bookCardVC)
            controller.present(viewController, animated: true)
        } else {
            controller.navigationController?.show(bookCardVC, sender: nil)
        }
    }
}
