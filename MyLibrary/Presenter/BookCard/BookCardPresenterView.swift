//
//  BookCardPresenterView.swift
//  MyLibrary
//
//  Created by Birkyboy on 26/01/2022.
//
import Foundation

protocol BookCardPresenterView: AcitivityIndicatorProtocol, AnyObject {
    func dismissController()
    func playRecommendButtonIndicator(_ play: Bool)
    func displayBook(with data: BookCardRepresentable)
    func displayCategories(with list: NSAttributedString)
}
