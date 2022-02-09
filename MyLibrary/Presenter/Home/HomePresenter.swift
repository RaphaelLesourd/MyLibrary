//
//  HomePresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 18/01/2022.
//

import FirebaseAuth

class HomePresenter: BookCellMapper {
    weak var view: HomePresenterView?
    var currentUserID = Auth.auth().currentUser?.uid
    var categories: [CategoryDTO] = []
    var latestBooks: [ItemDTO] = []
    var favoriteBooks: [ItemDTO] = []
    var recommandedBooks: [ItemDTO] = []
    var followedUser: [UserModelDTO] = []

    private let libraryService: LibraryServiceProtocol
    private let categoryService: CategoryServiceProtocol
    private let recommendationService: RecommendationServiceProtocol

    init(libraryService: LibraryServiceProtocol,
         categoryService: CategoryServiceProtocol,
         recommendationService: RecommendationServiceProtocol) {
        self.libraryService = libraryService
        self.categoryService = categoryService
        self.recommendationService = recommendationService
    }
    
    // MARK: - Internal functions
    func getCategories() {
        categoryService.getUserCategories { [weak self] result in
            self?.view?.stopActivityIndicator()
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
        recommendationService.getRecommendingUsers { [weak self] result in
            self?.view?.stopActivityIndicator()
            switch result {
            case .success(let users):
                self?.followedUser = users
                self?.view?.applySnapshot(animatingDifferences: true)
            case .failure(let error):
                AlertManager.presentAlertBanner(as: .error, subtitle: error.localizedDescription)
            }
        }
    }

    func makeUserCellUI(with user: UserModelDTO) -> UserCellUI {
        let currentUser: Bool = user.userID == currentUserID
        return UserCellUI(userName: user.displayName.capitalized,
                          profileImage: user.photoURL,
                          currentUser: currentUser)
    }
    
    // MARK: - Private functions
    /// Fetch books for the current query
    /// - Parameters:
    /// - query: BookQuery object to fetch a list of Item
    /// - returns: Array of Item
    private func getBooks(for query: BookQuery, completion: @escaping ([ItemDTO]) -> Void) {
        view?.startActivityIndicator()
        libraryService.getBookList(for: query,
                                      limit: 15,
                                      forMore: false) { [weak self] result in
            self?.view?.stopActivityIndicator()
            switch result {
            case .success(let books):
                completion(books)
            case .failure(let error):
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
            }
            self?.libraryService.removeBookListener()
        }
    }

    func displayItem(for selectedItem: AnyHashable) {
        if let category = selectedItem as? CategoryDTO {
            let categoryQuery = BookQuery(listType: .categories,
                                          orderedBy: .category,
                                          fieldValue: category.uid,
                                          descending: true)
            view?.presentBookLibraryController(for: categoryQuery, title: category.name)
        }
        if let book = selectedItem as? ItemDTO {
            view?.presentBookCardController(with: book)
        }
        if let followedUser = selectedItem as? UserModelDTO {
            let query = BookQuery(listType: .users,
                                  orderedBy: .ownerID,
                                  fieldValue: followedUser.userID,
                                  descending: true)
            view?.presentBookLibraryController(for: query, title: followedUser.displayName)
        }
    }
}
