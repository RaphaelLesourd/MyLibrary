//
//  BookCardMainViewDelegate.swift
//  MyLibrary
//
//  Created by Birkyboy on 28/12/2021.
//

protocol BookCardMainViewDelegate: AnyObject {
    func toggleBookRecommendation()
    func presentDeleteBookAlert()
    func toggleFavoriteBook()
    func presentCommentsViewController()
    func displayBookCover()
}
