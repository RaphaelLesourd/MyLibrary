//
//  SearchPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 18/01/2022.
//

class SearchPresenter: BookCellMapper {

    weak var view: SearchPresenterView?
    var searchList: [ItemDTO] = []
    var noMoreBooksFound: Bool?
    var currentSearchKeywords = "" {
        didSet {
            refreshSearchList()
        }
    }
    private let apiManager: SearchBookService
    
    init(apiManager: SearchBookService) {
        self.apiManager = apiManager
    }
    
    /// Api call to get book or list of books.
    /// - Parameters:
    ///   - query: String passing search keywords, could be title, author or isbn
    ///   - fromIndex: Define the starting point of the book to fetxh, used for pagination.
    func getBooks(with keywords: String, fromIndex: Int) {
        view?.startActivityIndicator()
        print("called")
        apiManager.getBooks(for: keywords, fromIndex: fromIndex) { [weak self] result in
            self?.view?.stopActivityIndicator()
            switch result {
            case .success(let books):
                books.isEmpty ? self?.noMoreBooksFound = true : self?.addToList(books)
            case .failure(let error):
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
    
    func refreshSearchList() {
        clearData()
        getBooks(with: currentSearchKeywords, fromIndex: 0)
    }

    func clearData() {
        searchList.removeAll()
        noMoreBooksFound = false
        view?.applySnapshot(animatingDifferences: false)
    }

    /// Add an array of Item object to the search book, after check if it already exists or not.
    /// - Parameters:
    /// - books: Array of Item objects
    private func addToList(_ books: [ItemDTO]) {
        books.forEach { book in
            if !self.searchList.contains(where: { $0.volumeInfo?.title == book.volumeInfo?.title }) {
                self.searchList.append(book)
                self.view?.applySnapshot(animatingDifferences: true)
            }
        }
    }
}
