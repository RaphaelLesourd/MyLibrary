//
//  NewBookPresenting.swift
//  MyLibrary
//
//  Created by Birkyboy on 27/01/2022.
//

import Foundation

protocol NewBookPresenting {
    var view: NewBookPresenterView? { get set }
    var mainView: NewBookControllerSubViews? { get set }
    var book: Item? { get set }
    var bookCategories: [String] { get set }
    var bookDescription: String? { get set }
    var isEditing: Bool { get set }
    var language: String? { get set }
    var currency: String? { get set }
    func displayBook()
    func saveBook(with imageData: Data)
    func setBookLanguage(with code: String?)
    func setBookCurrency(with code: String?)
}
