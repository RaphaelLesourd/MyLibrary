//
//  NewBookPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 21/01/2022.
//
import Foundation

protocol NewBookPresenterView: AnyObject {
    func showSaveButtonActicityIndicator(_ show: Bool)
    func returnToPreviousController()
    func displayBook(with model: NewBookRepresentable)
    func updateLanguageView(with language: String)
    func updateCurrencyView(with currency: String)
    func clearData()
}

class NewBookPresenter {
    
    weak var view: NewBookPresenterView?
    var isEditing = false
    var language: String? {
        didSet {
            let data = formatter.formatCodeToName(from: language, type: .languages)
            view?.updateLanguageView(with: data.capitalized)
        }
    }
    var currency: String? {
        didSet {
            let data = formatter.formatCodeToName(from: currency, type: .currency)
            view?.updateCurrencyView(with: data.uppercased())
        }
    }
    private let libraryService: LibraryServiceProtocol
    private let formatter: Formatter
    
    init(libraryService: LibraryServiceProtocol,
         formatter: Formatter) {
        self.libraryService = libraryService
        self.formatter = formatter
    }
    
    func saveBook(with book: Item, and imageData: Data) {
        view?.showSaveButtonActicityIndicator(true)
        
        libraryService.createBook(with: book, and: imageData) { [weak self] error in
            guard let self = self else { return }
            
            self.view?.showSaveButtonActicityIndicator(false)
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            AlertManager.presentAlertBanner(as: .success, subtitle: Text.Book.bookSaved)
            self.isEditing ? self.view?.returnToPreviousController() : self.view?.clearData()
        }
    }
   
    func configure(with book: Item) {
        language = formatter.formatCodeToName(from: book.volumeInfo?.language, type: .languages)
        currency = formatter.formatCodeToName(from: book.saleInfo?.retailPrice?.currencyCode, type: .currency)
        let data = NewBookRepresentable(title: book.volumeInfo?.title?.capitalized ?? "",
                                        authors: book.volumeInfo?.authors?.joined(separator: ", ") ?? "",
                                        rating: book.volumeInfo?.ratingsCount ?? 0,
                                        publisher: book.volumeInfo?.publisher?.capitalized ?? "",
                                        publishedDate: formatter.formatDateToYearString(for: book.volumeInfo?.publishedDate),
                                        price: String(book.saleInfo?.retailPrice?.amount ?? 0),
                                        isbn: book.volumeInfo?.industryIdentifiers?.first?.identifier ?? "",
                                        pages: String(book.volumeInfo?.pageCount ?? 0),
                                        coverImage: book.volumeInfo?.imageLinks?.thumbnail ?? "",
                                        language: language ?? "",
                                        currency: currency ?? "")
        view?.displayBook(with: data)
    }
}
