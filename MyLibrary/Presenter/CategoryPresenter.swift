//
//  CategoryPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 19/01/2022.
//

import Foundation

protocol CategoryPresenterView: AcitivityIndicatorProtocol, AnyObject {
    func applySnapshot(animatingDifferences: Bool)
}

class CategoryPresenter {
    
    // MARK: - Properties
    weak var view: CategoryPresenterView?
    var categoryService: CategoryServiceProtocol
    var categories: [CategoryModel] = []
    
    // MARK: - Initializer
    init(categoryService: CategoryServiceProtocol) {
        self.categoryService = categoryService
    }
    
    // MARK: - API Call
    func getCategoryList() {
        self.view?.showActivityIndicator()
        categoryService.getCategories { [weak self] result in
            self?.view?.stopActivityIndicator()
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
    
    func deleteCategory(for category: CategoryModel) {
        view?.showActivityIndicator()
        
        categoryService.deleteCategory(for: category) { [weak self] error in
            guard let self = self else { return }
            self.view?.stopActivityIndicator()
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            if let index = self.categories.firstIndex(where: {
                $0.name?.lowercased() == category.name?.lowercased()
            }) {
                self.categories.remove(at: index)
            }
            DispatchQueue.main.async {
                self.view?.applySnapshot(animatingDifferences: true)
            }
        }
    }
}
