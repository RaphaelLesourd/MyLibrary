//
//  LibraryPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 18/01/2022.
//

import UIKit

protocol LibraryPresenterDelegate: AnyObject {
    func addBookToList(_ books: [Item])
    func applySnapshot(animatingDifferences: Bool)
    func showActivityIndicator()
    func stopActivityIndicator()
}

typealias BookLibraryPresenterDelegate = LibraryPresenterDelegate & UIViewController

class LibraryPresenter {
    
    weak var delegate: BookLibraryPresenterDelegate?
    var noMoreBooks = false
    private let libraryService: LibraryService
    
    init(libraryService: LibraryService) {
        self.libraryService = libraryService
    }
    
    func getBooks(with query: BookQuery, nextPage: Bool = false) {
        delegate?.showActivityIndicator()
        libraryService.getBookList(for: query, limit: 40, forMore: nextPage) { [weak self] result in
            guard let self = self else { return }
            self.delegate?.stopActivityIndicator()
            switch result {
            case .success(let books):
                guard !books.isEmpty else {
                    self.noMoreBooks = true
                    self.delegate?.applySnapshot(animatingDifferences: true)
                    return
                }
                self.delegate?.addBookToList(books)
            case .failure(let error):
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
    
    func setDelegate(with delegate: BookLibraryPresenterDelegate) {
        self.delegate = delegate
    }
}
