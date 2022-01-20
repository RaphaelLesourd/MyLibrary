//
//  HomePresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 18/01/2022.
//

import Foundation

protocol HomePresenterView: AcitivityIndicatorProtocol, AnyObject {
    func applySnapshot(animatingDifferences: Bool)
}

class HomePresenter {
    
    // MARK: - Properties
    weak var view: HomePresenterView?
    let categoryService: CategoryServiceProtocol
    var categories: [CategoryModel] = []
    var latestBooks: [Item] = []
    var favoriteBooks: [Item] = []
    var recommandedBooks: [Item] = []
    var followedUser: [UserModel] = []
    
    private let libraryService: LibraryServiceProtocol
    private let recommendationService: RecommendationServiceProtocol
    
    // MARK: - Intializer
    init(libraryService: LibraryServiceProtocol,
         categoryService: CategoryServiceProtocol,
         recommendationService: RecommendationServiceProtocol) {
        self.libraryService = libraryService
        self.categoryService = categoryService
        self.recommendationService = recommendationService
    }
    
    // MARK: - API Calls
    func getCategories() {
        categoryService.getCategories { [weak self] result in
            switch result {
            case .success(let categories):
                self?.categories = categories
                DispatchQueue.main.async {
                    self?.view?.applySnapshot(animatingDifferences: true)
                }
            case .failure(let error):
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
    
    func getLatestBooks() {
        getBooks(for: .latestBookQuery) { [weak self] books in
            self?.latestBooks = books
            DispatchQueue.main.async {
                self?.view?.applySnapshot(animatingDifferences: true)
            }
        }
    }
    
    func getFavoriteBooks() {
        getBooks(for: .favoriteBookQuery) { [weak self] books in
            self?.favoriteBooks = books
            DispatchQueue.main.async {
                self?.view?.applySnapshot(animatingDifferences: true)
            }
        }
    }
    
    func getRecommendations() {
        getBooks(for: .recommendationQuery) { [weak self] books in
            self?.recommandedBooks = books
            DispatchQueue.main.async {
                self?.view?.applySnapshot(animatingDifferences: true)
            }
        }
    }
    
    func getUsers() {
        recommendationService.retrieveRecommendingUsers { [weak self] result in
            switch result {
            case .success(let users):
                self?.followedUser = users
                DispatchQueue.main.async {
                    self?.view?.applySnapshot(animatingDifferences: true)
                }
            case .failure(let error):
                AlertManager.presentAlertBanner(as: .error, subtitle: error.localizedDescription)
            }
        }
    }
    
    private func getBooks(for query: BookQuery,
                          completion: @escaping ([Item]) -> Void) {
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
