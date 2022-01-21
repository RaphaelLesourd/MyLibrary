//
//  CategoryPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 19/01/2022.
//

import Foundation

protocol CategoryPresenterView: AcitivityIndicatorProtocol, AnyObject {
    func applySnapshot(animatingDifferences: Bool)
    func highlightCellForCategoryList(at indexPath: IndexPath)
    func displayDeleteCategoryAlert(for category: CategoryModel)
    func presentNewCategoryController(editing: Bool, for category: CategoryModel?)
}

class CategoryPresenter {
    
    // MARK: - Properties
    weak var view: CategoryPresenterView?
    var categories: [CategoryModel] = []
    var selectedCategories: [String] = []
    
    private var categoryService: CategoryServiceProtocol
    private var categoriesOriginalList: [CategoryModel] = []
    
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
                self?.categoriesOriginalList = categories
                self?.categories = categories
                self?.view?.applySnapshot(animatingDifferences: true)
            case .failure(let error):
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
    
    func deleteCategory(for category: CategoryModel) {
        view?.showActivityIndicator()
        
        categoryService.deleteCategory(for: category) { [weak self] error in
            self?.view?.stopActivityIndicator()
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            if let index = self?.categories.firstIndex(where: {
                $0.name?.lowercased() == category.name?.lowercased()
            }) {
                self?.categories.remove(at: index)
            }
            self?.view?.applySnapshot(animatingDifferences: true)
        }
    }
    
    /// Filter the recipe searched
    /// - Parameter searchText: Pass in the text used to filter recipes.
    func filterSearchedCategories(for searchText: String) {
        if searchText.isEmpty {
            categories = categoriesOriginalList
        } else {
            categories = categoriesOriginalList.filter({
                guard let categoryName = $0.name?.lowercased() else { return false }
                return categoryName.contains(searchText.lowercased())
            })
        }
        self.view?.applySnapshot(animatingDifferences: true)
    }
    
    func highlightBookCategories(for section: Int) {
        selectedCategories.forEach({ category in
            if let index = categories.firstIndex(where: { $0.uid == category }) {
                let indexPath = IndexPath(row: index, section: section)
                view?.highlightCellForCategoryList(at: indexPath)
            }
        })
    }
    
    func addSelectedCategory(from index: Int) {
        guard let categoryID = categories[index].uid else { return }
        if let index = selectedCategories.firstIndex(where: { $0 == categoryID }) {
            selectedCategories.remove(at: index)
        }
    }
    
    func removeSelectedCategory(at index: Int) {
        guard let categoryID = categories[index].uid else { return }
        selectedCategories.append(categoryID)
    }
    
    func presentSwipeAction(for action: CellSwipeActionType, at index: Int) {
        let category = categories[index]
        switch action {
        case .delete:
            self.view?.displayDeleteCategoryAlert(for: category)
        case .edit:
            self.view?.presentNewCategoryController(editing: true, for: category)
        }
    }
}
