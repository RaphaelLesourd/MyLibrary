//
//  BookCardMainViewDelegate.swift
//  MyLibrary
//
//  Created by Birkyboy on 28/12/2021.
//

protocol BookCardMainViewDelegate: AnyObject {
    func recommandButtonAction()
    func deleteBookAction()
    func favoriteButtonAction()
    func showCommentsViewController()
    func showBookCover()
}
