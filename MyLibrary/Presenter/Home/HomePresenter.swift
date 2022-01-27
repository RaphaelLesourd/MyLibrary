//
//  HomePresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 18/01/2022.
//

class HomePresenter: BookCellAdapter, UserCellAdapter {
    
    // MARK: - Properties
    weak var view: HomePresenterView?
    var categories: [CategoryModel] = []
    var latestBooks: [Item] = []
    var favoriteBooks: [Item] = []
    var recommandedBooks: [Item] = []
    var followedUser: [UserModel] = []
    
    private let libraryService: LibraryServiceProtocol
    private let categoryService: CategoryServiceProtocol
    private let recommendationService: RecommendationServiceProtocol
    
    // MARK: - Intializer
    init(libraryService: LibraryServiceProtocol,
         categoryService: CategoryServiceProtocol,
         recommendationService: RecommendationServiceProtocol) {
        self.libraryService = libraryService
        self.categoryService = categoryService
        self.recommendationService = recommendationService
    }
    
    /// Fetch books for the current query
    /// - Parameters:
    /// - query: BookQuery object to fetch a list of Item
    /// - returns: Array of Item
    private func getBooks(for query: BookQuery, completion: @escaping ([Item]) -> Void) {
        view?.showActivityIndicator()
        libraryService.getBookList(for: query,
                                      limit: 15,
                                      forMore: false) { [weak self] result in
            self?.view?.stopActivityIndicator()
            switch result {
            case .success(let books):
                completion(books)
            case .failure(let error):
                AlertManager.presentAlertBanner(as: .error,
                                                subtitle: error.description)
            }
        }
    }
}

extension HomePresenter: HomePresenting {
    // MARK: - API Calls
    func getCategories() {
        categoryService.getCategories { [weak self] result in
            switch result {
            case .success(let categories):
                self?.categories = categories
                self?.view?.applySnapshot(animatingDifferences: true)
            case .failure(let error):
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
    
    func getLatestBooks() {
        getBooks(for: .latestBookQuery) { [weak self] books in
            self?.latestBooks = books
            self?.view?.applySnapshot(animatingDifferences: true)
        }
    }
    
    func getFavoriteBooks() {
        getBooks(for: .favoriteBookQuery) { [weak self] books in
            self?.favoriteBooks = books
            self?.view?.applySnapshot(animatingDifferences: true)
        }
    }
    
    func getRecommendations() {
        getBooks(for: .recommendationQuery) { [weak self] books in
            self?.recommandedBooks = books
            self?.view?.applySnapshot(animatingDifferences: true)
        }
    }
    
    func getUsers() {
        recommendationService.retrieveRecommendingUsers { [weak self] result in
            switch result {
            case .success(let users):
                self?.followedUser = users
                self?.view?.applySnapshot(animatingDifferences: true)
            case .failure(let error):
                AlertManager.presentAlertBanner(as: .error, subtitle: error.localizedDescription)
            }
        }
    }
}
