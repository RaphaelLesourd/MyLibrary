//
//  LibraryPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 18/01/2022.
//

class LibraryPresenter: BookCellAdapter {
    
    // MARK: - Properties
    weak var view: LibraryPresenterView?
    var endOfList: Bool = false
    var bookList: [Item] = []
    private let libraryService: LibraryServiceProtocol
   
    // MARK: - Initializer
    init(libraryService: LibraryServiceProtocol) {
        self.libraryService = libraryService
    }
}
extension LibraryPresenter: LibraryPresenting {
    
    func getBooks(with query: BookQuery, nextPage: Bool = false) {
        view?.updateHeader(with: query.listType?.title)
        view?.showActivityIndicator()
        libraryService.getBookList(for: query,
                                      limit: 40,
                                      forMore: nextPage) { [weak self] result in
            self?.view?.stopActivityIndicator()
            
            switch result {
            case .success(let books):
                guard !books.isEmpty else {
                    self?.endOfList = true
                    self?.view?.applySnapshot(animatingDifferences: true)
                    return
                }
                self?.bookList.append(contentsOf: books)
                self?.view?.applySnapshot(animatingDifferences: true)
            case .failure(let error):
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
}
