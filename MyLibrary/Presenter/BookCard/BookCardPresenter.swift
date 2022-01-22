//
//  BookCardPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 21/01/2022.
//

import Foundation

protocol BookCardPresenterView: AcitivityIndicatorProtocol, AnyObject {
    func dismissController()
    func playRecommendButtonIndicator(_ play: Bool)
    func displayBook(with data: BookCardRepresentable)
    func displayCategories(with list: NSAttributedString)
}

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
    
    // MARK: - Public Functions
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
  
    func recommendBook(_ recommend: Bool) {
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
                self?.book = book
                self?.setBookData(from: book)
                self?.fetchCategoryNames()
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
            self?.setCategoriesLabel(with: categories)
        }
    }
    
    func setCategoriesLabel(with categories: [CategoryModel]) {
        let string = categoryFormatter.formattedString(for: categories)
        view?.displayCategories(with: string)
    }
   
    func setBookData(from book: Item) {
        let language = formatter.formatCodeToName(from: book.volumeInfo?.language, type: .languages).capitalized
        let publishedDate = formatter.formatDateToYearString(for: book.volumeInfo?.publishedDate)
        let currency = book.saleInfo?.retailPrice?.currencyCode
        let value = book.saleInfo?.retailPrice?.amount
        let price = formatter.formatDoubleToPrice(with: value, currencyCode: currency)
        
        let data = BookCardRepresentable(title: book.volumeInfo?.title?.capitalized ?? "",
                            authors: book.volumeInfo?.authors?.joined(separator: ", ") ?? "",
                            rating: book.volumeInfo?.ratingsCount ?? 0,
                            description: book.volumeInfo?.volumeInfoDescription ?? "",
                            isbn: book.volumeInfo?.industryIdentifiers?.first?.identifier ?? "",
                            language: language,
                            publisher: book.volumeInfo?.publisher?.capitalized ?? "",
                            publishedDate: publishedDate,
                            pages: String(book.volumeInfo?.pageCount ?? 0),
                            price: price,
                            image: book.volumeInfo?.imageLinks?.thumbnail ?? "")
        view?.displayBook(with: data)
    }
    
    // MARK: - Private functions
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
