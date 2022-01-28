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
    func updateLanguageView(with language: String)
    func updateCurrencyView(with currency: String)
    func clearData()
}
