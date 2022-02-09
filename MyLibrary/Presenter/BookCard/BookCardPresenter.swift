//
//  BookCardPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 21/01/2022.
//

import Foundation
import FirebaseAuth

class BookCardPresenter {

    weak var view: BookCardPresenterView?
    var book: ItemDTO? {
        didSet {
            mapToBookUI()
            fetchCategoryNames()
            setBookFavoriteStatus()
            setBookRecommandStatus()
        }
    }
    var isBookEditable: Bool {
        let isConnected = Networkconnectivity.shared.isReachable == true
        let isBookOwner = book?.ownerID == currentUserID
        return (isConnected && isBookOwner == true)
    }
    var recommended = false {
        didSet {
            view?.toggleRecommendButton(as: recommended)
        }
    }
    var favoriteBook = false {
        didSet {
            view?.toggleFavoriteButton(as: favoriteBook)
        }
    }
    var currentUserID = Auth.auth().currentUser?.uid
    private let libraryService: LibraryServiceProtocol
    private let recommendationService: RecommendationServiceProtocol
    private let categoryService: CategoryServiceProtocol
    private let formatter: Formatter
    private let categoryFormatter: CategoriesFormatter

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

    // MARK: - Internal functions
    func deleteBook() {
        guard let book = book else { return }
        view?.startActivityIndicator()
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
    func fetchBookUpdate() {
        guard let bookID = book?.bookID,
              let ownerID = book?.ownerID else { return }
        view?.startActivityIndicator()
        
        libraryService.getBook(for: bookID, ownerID: ownerID) { [weak self] result in
            self?.view?.stopActivityIndicator()
            switch result {
            case .success(let book):
                self?.book = book
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
    func formatCategoryList(with categories: [CategoryDTO]) {
        let string = categoryFormatter.formattedString(for: categories)
        view?.displayCategories(with: string)
    }
   
    /// Convert a book from Item entity to BookCard representable
    /// - Parameters: Item object of the current book.
    func mapToBookUI() {
        guard let book = book else { return}

        let language = formatter.formatCodeToName(from: book.volumeInfo?.language, type: .languages).capitalized
        let publishedDate = formatter.formatDateToYearString(for: book.volumeInfo?.publishedDate)
        let currency = book.saleInfo?.retailPrice?.currencyCode
        let value = book.saleInfo?.retailPrice?.amount
        let price = formatter.formatDoubleToPrice(with: value, currencyCode: currency)
        
        let data = BookCardUI(title: book.volumeInfo?.title?.capitalized,
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
        view?.startActivityIndicator()
        
        libraryService.setStatus(to: state, field: documentKey, for: bookID) { [weak self] error in
            self?.view?.stopActivityIndicator()
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
  
    /// Call for the proper methods when the reommenBook button it tapped.
    /// - Parameters: Boolean value
    func recommendBook() {
        recommended ? addToRecommendedBooks() : removeFromRecommendedBooks()
        updateStatus(state: recommended, documentKey: .recommanding)
    }

    // MARK: - Private functions
    /// Add current book to the recommended collection in the database
    private func addToRecommendedBooks() {
        guard let book = book else { return }
        view?.toggleRecommendButtonIndicator(on: true)

        recommendationService.addToRecommandation(for: book) { [weak self] error in
            self?.view?.toggleRecommendButtonIndicator(on: false)
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
    /// Remove current book to the recommended collection in the database
    private func removeFromRecommendedBooks() {
        guard let book = book else { return }
        view?.toggleRecommendButtonIndicator(on: true)
        
        recommendationService.removeFromRecommandation(for: book) { [weak self] error in
            self?.view?.toggleRecommendButtonIndicator(on: false)
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }

    private func setBookFavoriteStatus() {
        if let favorite = book?.favorite {
            favoriteBook = favorite
        }
    }

    private func setBookRecommandStatus() {
        if let recommand = book?.recommanding {
            recommended = recommand
        }
    }
}
