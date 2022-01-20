//
//  LibraryPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 18/01/2022.
//

protocol LibraryPresenterView: AcitivityIndicatorProtocol, AnyObject {
    func addBookToList(_ books: [Item])
    func applySnapshot(animatingDifferences: Bool)
}

class LibraryPresenter {
    
    // MARK: - Properties
    weak var view: LibraryPresenterView?
    var endOfList: Bool = false
    private let libraryService: LibraryServiceProtocol
    
    // MARK: - Initializer
    init(libraryService: LibraryServiceProtocol) {
        self.libraryService = libraryService
    }
    
    // MARK: - API Call
    func getBooks(with query: BookQuery,
                  nextPage: Bool = false) {
        view?.showActivityIndicator()
        libraryService.getBookList(for: query,
                                      limit: 40,
                                      forMore: nextPage) { [weak self] result in
            guard let self = self else { return }
            self.view?.stopActivityIndicator()
            switch result {
            case .success(let books):
                guard !books.isEmpty else {
                    self.endOfList = true
                    self.view?.applySnapshot(animatingDifferences: true)
                    return
                }
                self.view?.addBookToList(books)
            case .failure(let error):
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
}
