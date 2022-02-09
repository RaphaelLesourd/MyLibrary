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
    var currentQuery: BookQuery?

    private let libraryService: LibraryServiceProtocol
    private let queryService: QueryProtocol
    private let dataFetchLimit = 40
    
    init(libraryService: LibraryServiceProtocol,
         queryService: QueryProtocol) {
        self.libraryService = libraryService
        self.queryService = queryService
    }

    func loadMoreBooks(currentIndex: Int, lastRow: Int) {
        if lastRow == currentIndex && endOfList == false {
            getBooks(nextPage: true)
        }
    }

    func fetchBookList() {
        bookList.removeAll()
        view?.applySnapshot(animatingDifferences: false)
        endOfList = false
        getBooks(nextPage: false)
    }

    func updateQuery(by listType: QueryType) {
        currentQuery = queryService.updateQuery(from: currentQuery, with: listType.documentKey)
        fetchBookList()
    }

    // MARK: Private functions
    private func getBooks(nextPage: Bool = false) {
        guard let currentQuery = currentQuery else { return }
        view?.startActivityIndicator()

        libraryService.getBookList(for: currentQuery,
                                      limit: dataFetchLimit,
                                      forMore: nextPage) { [weak self] result in
            self?.view?.stopActivityIndicator()

            switch result {
            case .success(let books):
                self?.endOfList = books.isEmpty
                nextPage == false ?  self?.bookList = books : self?.bookList.append(contentsOf: books)
                self?.view?.applySnapshot(animatingDifferences: true)
                self?.setHeaderTitle()
            case .failure(let error):
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
            }
            self?.libraryService.removeBookListener()
        }
    }

    private func setHeaderTitle() {
        guard let currentQuery = currentQuery else { return }
        if let index = QueryType.allCases.firstIndex(where: { $0.documentKey == currentQuery.orderedBy }) {
            let title = QueryType.allCases[index].title
            view?.updateSectionTitle(with: title)
        } else {
            view?.updateSectionTitle(with: Text.ListMenu.byTitle)
        }
    }
}
