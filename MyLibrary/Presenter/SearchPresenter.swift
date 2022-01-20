//
//  SearchPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 18/01/2022.
//

protocol SearchPresenterView: AcitivityIndicatorProtocol, AnyObject {
    func handleList(for books: [Item])
}

class SearchPresenter {
    
    // MARK: - Properties
    weak var view: SearchPresenterView?
    private let apiManager: ApiManagerProtocol
  
    // MARK: - Initializer
    init(apiManager: ApiManagerProtocol) {
        self.apiManager = apiManager
    }
    
    // MARK: - API call
    /// Api call to get book or list of books.
    /// - Parameters:
    ///   - query: String passing search keywords, could be title, author or isbn
    ///   - fromIndex: Define the starting point of the book to fetxh, used for pagination.
    func getBooks(with keywords: String,
                  fromIndex: Int) {
        view?.showActivityIndicator()
        
        apiManager.getData(with: keywords, fromIndex: fromIndex) { [weak self] result in
            self?.view?.stopActivityIndicator()
            switch result {
            case .success(let books):
                self?.view?.handleList(for: books)
            case .failure(let error):
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
}
