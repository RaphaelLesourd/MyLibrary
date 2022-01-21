//
//  BookCardPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 21/01/2022.
//

import Foundation

protocol BookCardPresenterView: AcitivityIndicatorProtocol, AnyObject {
    func dismissController()
    func playRecommendButtonIndicaor(_ play: Bool)
    func displayData(for book: Item)
    func displayCategories(with list: [CategoryModel])
}

class BookCardPresenter {
    
    weak var view: BookCardPresenterView?
    var book: Item?
    
    private let libraryService: LibraryServiceProtocol
    private let recommendationService: RecommendationServiceProtocol
    private let categoryService: CategoryServiceProtocol
    
    init(libraryService: LibraryServiceProtocol,
         recommendationService: RecommendationServiceProtocol,
         categoryService: CategoryServiceProtocol) {
        self.libraryService = libraryService
        self.recommendationService = recommendationService
        self.categoryService = categoryService
    }
    
    func delete() {
        guard let book = book else { return }
        view?.showActivityIndicator()
        libraryService.deleteBook(book: book) { [weak self] error in
            self?.view?.stopActivityIndicator()
            if let error = error {
                return AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
            }
            AlertManager.presentAlertBanner(as: .success, subtitle: Text.Banner.bookDeleted)
            self?.view?.dismissController()
        }
    }
    
     func updateStatus(state: Bool, documentKey: DocumentKey) {
         guard let bookID = book?.bookID else { return }
        view?.showActivityIndicator()
        
        libraryService.setStatus(to: state, field: documentKey, for: bookID) { [weak self] error in
            self?.view?.stopActivityIndicator()
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
            }
            
        }
    }
  
    func recommnand(_ recommend: Bool) {
        view?.playRecommendButtonIndicaor(true)
        guard recommend == false else {
            addToRecommendedBooks()
            return
        }
        removeFromRecommendedBooks()
    }
    
    func fetchBookUpdate() {
        guard let bookID = book?.bookID,
              let ownerID = book?.ownerID else { return }
        view?.showActivityIndicator()
        
        libraryService.getBook(for: bookID, ownerID: ownerID) { [weak self] result in
            self?.view?.stopActivityIndicator()
            switch result {
            case .success(let book):
                self?.view?.displayData(for: book)
            case .failure(let error):
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
    
    func fetchCategoryNames() {
        guard let categoryIds = book?.category,
              let bookOwnerID = book?.ownerID else { return }
        categoryService.getBookCategories(for: categoryIds, bookOwnerID: bookOwnerID) { [weak self] categories in
            let categories = categories.sorted { $0.name?.lowercased() ?? "" < $1.name?.lowercased() ?? "" }
            self?.view?.displayCategories(with: categories)
        }
    }
    
    // MARK: - Private functions
    private func addToRecommendedBooks() {
        guard let book = book else { return }
        recommendationService.addToRecommandation(for: book) { [weak self] error in
            self?.view?.playRecommendButtonIndicaor(false)
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
    
    private func removeFromRecommendedBooks() {
        guard let book = book else { return }
        recommendationService.removeFromRecommandation(for: book) { [weak self] error in
            self?.view?.playRecommendButtonIndicaor(false)
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
}
