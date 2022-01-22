//
//  NewBookPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 21/01/2022.
//

import Foundation
import UIKit

struct NewBookRepresentable {
    let title: String
    let authors: String
    let rating: Int
    let publisher: String
    let publishedDate: String
    let price: String
    let isbn: String
    let pages: String
    let coverImage:String
}

protocol NewBookPresenterView: AnyObject {
    func showSaveButtonActicityIndicator(_ show: Bool)
    func returnToPreviousController()
    func clearData()
    func displayBook(with model: NewBookRepresentable)
}

class NewBookPresenter {
    
    weak var view: NewBookPresenterView?
    var isEditing = false
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
        let data = NewBookRepresentable(title: book.volumeInfo?.title?.capitalized ?? "",
                                        authors: book.volumeInfo?.authors?.joined(separator: ", ") ?? "",
                                        rating: book.volumeInfo?.ratingsCount ?? 0,
                                        publisher: book.volumeInfo?.publisher?.capitalized ?? "",
                                        publishedDate: formatter.formatDateToYearString(for: book.volumeInfo?.publishedDate),
                                        price: String(book.saleInfo?.retailPrice?.amount ?? 0),
                                        isbn: book.volumeInfo?.industryIdentifiers?.first?.identifier ?? "",
                                        pages: String(book.volumeInfo?.pageCount ?? 0),
                                        coverImage: book.volumeInfo?.imageLinks?.thumbnail ?? "")
        view?.displayBook(with: data)
    }
}
