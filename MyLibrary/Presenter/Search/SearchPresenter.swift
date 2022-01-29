//
//  SearchPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 18/01/2022.
//

class SearchPresenter: BookCellMapper {
    
    // MARK: - Properties
    weak var view: SearchPresenterView?
    var searchList: [ItemDTO] = []
    var noMoreBooksFound: Bool?
    var searchType: SearchType?
    var currentSearchKeywords = "" {
        didSet {
            refreshSearchList()
        }
    }
    private let apiManager: SearchBookService
    
    // MARK: - Initializer
    init(apiManager: SearchBookService) {
        self.apiManager = apiManager
    }
    
    // MARK: - Public functions
    /// Api call to get book or list of books.
    /// - Parameters:
    ///   - query: String passing search keywords, could be title, author or isbn
    ///   - fromIndex: Define the starting point of the book to fetxh, used for pagination.
    func getBooks(with keywords: String, fromIndex: Int) {
        view?.startActivityIndicator()
        
        apiManager.getBooks(for: keywords, fromIndex: fromIndex) { [weak self] result in
            self?.view?.stopActivityIndicator()
            switch result {
            case .success(let books):
                self?.handleSearchList(with: books)
            case .failure(let error):
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
    
    func refreshSearchList() {
        searchList.removeAll()
        noMoreBooksFound = false
        getBooks(with: currentSearchKeywords, fromIndex: 0)
    }
    
    // MARK: - Private functions
    /// Verifies the type of search and redirects the result.
    ///  - Parameters:
    ///   - searchType: - .apiCall: Display the list in the collectionView
    ///    - .barCodeSearch: send the first result back to newBookController
    ///   - books: List of books fetch from API
   private func handleSearchList(with books: [ItemDTO]) {
        switch searchType {
        case .keywordSearch:
            books.isEmpty ? noMoreBooksFound = true : addToList(books)
        case .barCodeSearch:
            view?.displayBookFromBarCodeSearch(with: books.first)
        case .none:
            return
        }
    }
    
    /// Add an array of Item object to the search book, after check if it already exists or not.
    /// - Parameters:
    /// - books: Array of Item objects
    private func addToList(_ books: [ItemDTO]) {
        books.forEach {  book in
            if !self.searchList.contains(where: { $0.volumeInfo?.title == book.volumeInfo?.title }) {
                self.searchList.append(book)
                self.view?.applySnapshot(animatingDifferences: true)
            }
        }
    }
}
