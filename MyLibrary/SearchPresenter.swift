//
//  SearchPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 18/01/2022.
//

import UIKit

protocol SearchPresenterDelegate: AnyObject {
    func handleList(for: [Item])
    func showActivityIndicator()
    func stopActivityIndicator()
}

typealias SearchBookPresenterDelegate = SearchPresenterDelegate & UIViewController

class SearchPresenter {
    
    weak var delegate: SearchBookPresenterDelegate?
    
    private let apiManager: ApiManagerProtocol
    
    init(apiManager: ApiManagerProtocol) {
        self.apiManager = apiManager
    }
    
    // MARK: - API call
    /// Api call to get book or list of books.
    /// - Parameters:
    ///   - query: String passing search keywords, could be title, author or isbn
    ///   - fromIndex: Define the starting point of the book to fetxh, used for pagination.
    func getBooks(with keywords: String, fromIndex: Int) {
        delegate?.showActivityIndicator()
        apiManager.getData(with: keywords, fromIndex: fromIndex) { [weak self] result in
            guard let self = self else { return }
            self.delegate?.stopActivityIndicator()
            
            switch result {
            case .success(let books):
                self.delegate?.handleList(for: books)
            case .failure(let error):
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
    
    func setDelegate(with delegate: SearchBookPresenterDelegate) {
        self.delegate = delegate
    }
}
