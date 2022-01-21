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
    func clearData()
}

class NewBookPresenter {
    
    weak var view: NewBookPresenterView?
    var isEditing = false
    private var libraryService: LibraryServiceProtocol
    
    init(libraryService: LibraryServiceProtocol) {
        self.libraryService = libraryService
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
}
