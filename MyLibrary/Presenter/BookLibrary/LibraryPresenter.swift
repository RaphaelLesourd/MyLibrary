//
//  LibraryPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 18/01/2022.
//

class LibraryPresenter: BookCellMapper {

    weak var view: LibraryPresenterView?
    var endOfList: Bool = false
    var bookList: [ItemDTO] = [] 
    private let libraryService: LibraryServiceProtocol

    init(libraryService: LibraryServiceProtocol) {
        self.libraryService = libraryService
    }
   
    func getBooks(with query: BookQuery?, nextPage: Bool = false) {
        guard let query = query else { return }
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
                self?.setHeaderTitle(for: query)
            case .failure(let error):
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }

    private func setHeaderTitle(for query: BookQuery) {
        if let index = QueryType.allCases.firstIndex(where: { $0.documentKey == query.orderedBy }) {
            let title = QueryType.allCases[index].title
            view?.updateSectionTitle(with: title)
        } else {
            view?.updateSectionTitle(with: Text.ListMenu.byTitle)
        }
    }
}
