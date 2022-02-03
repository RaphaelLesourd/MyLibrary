//
//  NewBookPresenterView.swift
//  MyLibrary
//
//  Created by Birkyboy on 27/01/2022.
//

protocol NewBookPresenterView: AnyObject {
    func toggleSaveButtonActivityIndicator(to play: Bool)
    func returnToPreviousVC()
    func displayBook(with model: NewBookUI)
    func displayLanguage(with language: String)
    func displayCurrencyView(with currency: String)
    func clearData()
}
