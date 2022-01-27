//
//  BookCardPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 21/01/2022.
//

import Foundation

class BookCardPresenter {
    
    // MARK: - Properties
    weak var view: BookCardPresenterView?
    var book: Item?
    
    private let libraryService: LibraryServiceProtocol
    private let recommendationService: RecommendationServiceProtocol
    private let categoryService: CategoryServiceProtocol
    private let formatter: Formatter
    private let categoryFormatter: CategoriesFormatter
    
    // MARK: - Initializer
    init(libraryService: LibraryServiceProtocol,
         recommendationService: RecommendationServiceProtocol,
         categoryService: CategoryServiceProtocol,
         formatter: Formatter,
         categoryFormatter: CategoriesFormatter) {
        self.libraryService = libraryService
        self.recommendationService = recommendationService
        self.categoryService = categoryService
        self.formatter = formatter
        self.categoryFormatter = categoryFormatter
    }
    
    /// Add current book to the recommended collection in the database
    private func addToRecommendedBooks() {
        guard let book = book else { return }
        view?.playRecommendButtonIndicator(true)
        recommendationService.addToRecommandation(for: book) { [weak self] error in
            self?.view?.playRecommendButtonIndicator(false)
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
    /// Remove current book to the recommended collection in the database
    private func removeFromRecommendedBooks() {
        guard let book = book else { return }
        recommendationService.removeFromRecommandation(for: book) { [weak self] error in
            self?.view?.playRecommendButtonIndicator(false)
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
}
extension BookCardPresenter: BookCardPresenting {
   
    func deleteBook() {
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
    
    /// Fetch the current book from the database.
    /// Typically used to update the current book changes.
    func updateBook() {
        guard let bookID = book?.bookID,
              let ownerID = book?.ownerID else { return }
        view?.showActivityIndicator()
        
        libraryService.getBook(for: bookID, ownerID: ownerID) { [weak self] result in
            self?.view?.stopActivityIndicator()
            switch result {
            case .success(let book):
                self?.book = book
                self?.convertToBookRepresentable(from: book)
                self?.fetchCategoryNames()
            case .failure(let error):
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
    
    /// Fetch the category names for the current book.
    func fetchCategoryNames() {
        guard let categoryIds = book?.category,
              let bookOwnerID = book?.ownerID else { return }
        categoryService.getBookCategories(for: categoryIds, bookOwnerID: bookOwnerID) { [weak self] categories in
            let categories = categories.sorted { $0.name.lowercased() < $1.name.lowercased() }
            self?.formatCategoryList(with: categories)
        }
    }
    
    /// Format and set the category label from an array of CategoryModel to NSAttributtedString.
    /// Inludes the category name and a tinted icon with the category color.
    /// - Parameters: - categories: Array of CategoryModel
    func formatCategoryList(with categories: [CategoryModel]) {
        let string = categoryFormatter.formattedString(for: categories)
        view?.displayCategories(with: string)
    }
   
    /// Convert a book from Item entity to BookCard representable
    /// - Parameters: Item object of the current book.
    func convertToBookRepresentable(from book: Item) {
        let language = formatter.formatCodeToName(from: book.volumeInfo?.language, type: .languages).capitalized
        let publishedDate = formatter.formatDateToYearString(for: book.volumeInfo?.publishedDate)
        let currency = book.saleInfo?.retailPrice?.currencyCode
        let value = book.saleInfo?.retailPrice?.amount
        let price = formatter.formatDoubleToPrice(with: value, currencyCode: currency)
        
        let data = BookCardRepresentable(title: book.volumeInfo?.title?.capitalized,
                            authors: book.volumeInfo?.authors?.joined(separator: ", "),
                            rating: book.volumeInfo?.ratingsCount,
                            description: book.volumeInfo?.volumeInfoDescription,
                            isbn: book.volumeInfo?.industryIdentifiers?.first?.identifier,
                            language: language,
                            publisher: book.volumeInfo?.publisher?.capitalized,
                            publishedDate: publishedDate,
                            pages: book.volumeInfo?.pageCount,
                            price: price,
                            image: book.volumeInfo?.imageLinks?.thumbnail)
        view?.displayBook(with: data)
    }
    
    /// Update status for either Favorite or Recommended book.
    /// - Parameters
    /// - state: Boolean value to represent state of the status
    /// - documentKey: DocumentKey type for the status to update, tpyically .favorite or .recommended
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
  
    /// Call for the proper methods when the reommenBook button it tapped.
    /// - Parameters: Boolean value
    func recommendBook(_ recommend: Bool) {
        guard recommend == false else {
            addToRecommendedBooks()
            return
        }
        removeFromRecommendedBooks()
    }
}
