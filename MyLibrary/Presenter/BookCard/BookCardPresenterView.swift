//
//  BookCardPresenterView.swift
//  MyLibrary
//
//  Created by Birkyboy on 26/01/2022.
//
import Foundation

protocol BookCardPresenterView: AcitivityIndicatorProtocol, AnyObject {
    func dismissController()
    func toggleRecommendButtonIndicator(on play: Bool)
    func displayBook(with data: BookCardUI)
    func displayCategories(with list: NSAttributedString)
    func toggleRecommendButton(as recommended: Bool)
    func toggleFavoriteButton(as favorite: Bool)
}
