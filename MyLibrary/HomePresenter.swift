//
//  HomePresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 18/01/2022.
//

protocol HomePresenterDelegate: AnyObject {
    var latestBooks: [Item] { get set }
    var favoriteBooks: [Item] { get set }
    var recommandedBooks: [Item] { get set }
    var followedUser: [UserModel] { get set }
    func applySnapshot(animatingDifferences: Bool)
    func showActivityIndicator()
    func stopActivityIndicator()
}

class HomePresenter {
    
    // MARK: - Properties
    weak var delegate: HomePresenterDelegate?
    let categoryService: CategoryServiceProtocol
    private let libraryService: LibraryService
    private let recommendationService: RecommendationServiceProtocol
    
    // MARK: - Intializer
    init(libraryService: LibraryService,
         categoryService: CategoryServiceProtocol,
         recommendationService: RecommendationServiceProtocol ) {
        self.libraryService = libraryService
        self.categoryService = categoryService
        self.recommendationService = recommendationService
    }
    
    // MARK: - API Calls
    func getCategories() {
        categoryService.getCategories { [weak self] error in
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
            }
            self?.delegate?.applySnapshot(animatingDifferences: true)
        }
    }
    
    func getLatestBooks() {
        getBooks(for: .latestBookQuery) { [weak self] books in
            self?.delegate?.latestBooks = books
            self?.delegate?.applySnapshot(animatingDifferences: true)
        }
    }
    
    func getFavoriteBooks() {
        getBooks(for: .favoriteBookQuery) { [weak self] books in
            self?.delegate?.favoriteBooks = books
            self?.delegate?.applySnapshot(animatingDifferences: true)
        }
    }
    
    func getRecommendations() {
        getBooks(for: .recommendationQuery) { [weak self] books in
            self?.delegate?.recommandedBooks = books
            self?.delegate?.applySnapshot(animatingDifferences: true)
        }
    }
    
    func getUsers() {
        recommendationService.retrieveRecommendingUsers { [weak self] result in
            switch result {
            case .success(let users):
                self?.delegate?.followedUser = users
                self?.delegate?.applySnapshot(animatingDifferences: true)
            case .failure(let error):
                AlertManager.presentAlertBanner(as: .error, subtitle: error.localizedDescription)
            }
        }
    }
    
    private func getBooks(for query: BookQuery, completion: @escaping ([Item]) -> Void) {
        delegate?.showActivityIndicator()
        libraryService.getBookList(for: query,
                                      limit: 15,
                                      forMore: false) { [weak self] result in
            self?.delegate?.stopActivityIndicator()
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
