//
//  LibraryPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 18/01/2022.
//

class LibraryPresenter: BookCellMapper {
    
    // MARK: - Properties
    weak var view: LibraryPresenterView?
    var endOfList: Bool = false
    var bookList: [ItemDTO] = []
    private let libraryService: LibraryServiceProtocol
   
    // MARK: - Initializer
    init(libraryService: LibraryServiceProtocol) {
        self.libraryService = libraryService
    }
   
    func getBooks(with query: BookQuery?, nextPage: Bool = false) {
        guard let query = query else { return }
        view?.updateSectionTitle(with: query.listType?.title)
        view?.startActivityIndicator()
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
