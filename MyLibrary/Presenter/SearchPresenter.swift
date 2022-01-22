//
//  SearchPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 18/01/2022.
//

protocol SearchPresenterView: AcitivityIndicatorProtocol, AnyObject {
    func applySnapshot(animatingDifferences: Bool)
    func displayBookFromBarCodeSearch(with book: Item?)
}

class SearchPresenter: BookCellAdapter {
    
    // MARK: - Properties
    weak var view: SearchPresenterView?
    var searchedBooks: [Item] = []
    var noMoreBooks: Bool?
    var searchType: SearchType?
    var currentSearchKeywords = "" {
        didSet {
            refreshData()
        }
    }
    private let apiManager: ApiManagerProtocol
    
    // MARK: - Initializer
    init(apiManager: ApiManagerProtocol) {
        self.apiManager = apiManager
    }
    
    // MARK: - Public functions
    /// Api call to get book or list of books.
    /// - Parameters:
    ///   - query: String passing search keywords, could be title, author or isbn
    ///   - fromIndex: Define the starting point of the book to fetxh, used for pagination.
    func getBooks(with keywords: String,
                  fromIndex: Int) {
        view?.showActivityIndicator()
        
        apiManager.getData(with: keywords, fromIndex: fromIndex) { [weak self] result in
            self?.view?.stopActivityIndicator()
            switch result {
            case .success(let books):
                self?.handleList(for: books)
            case .failure(let error):
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
    func refreshData() {
        searchedBooks.removeAll()
        noMoreBooks = false
        getBooks(with: currentSearchKeywords, fromIndex: 0)
    }
    
    // MARK: - Private functions
    /// Verifies the type of search and redirects the result.
    ///  - searchType:
    ///  - .apiCall: Display the list in the collectionView
    ///  - .barCodeSearch: send the first result back to newBookController
    /// - Parameter books: List of books fetch from API
   private func handleList(for books: [Item]) {
        switch searchType {
        case .keywordSearch:
            books.isEmpty ? noMoreBooks = true : addBooks(books)
        case .barCodeSearch:
            view?.displayBookFromBarCodeSearch(with: books.first)
        case .none:
            return
        }
    }
    
    private func addBooks(_ books: [Item]) {
        books.forEach {  book in
            if !self.searchedBooks.contains(where: { $0.volumeInfo?.title == book.volumeInfo?.title }) {
                self.searchedBooks.append(book)
                self.view?.applySnapshot(animatingDifferences: true)
            }
        }
    }
}
