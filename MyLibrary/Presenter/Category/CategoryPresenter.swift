//
//  CategoryPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 19/01/2022.
//

import Foundation

class CategoryPresenter {

    weak var view: CategoryPresenterView?
    var categories: [CategoryDTO] = []
    var categoriesOriginalList: [CategoryDTO] = []
    var selectedCategories: [String] = []
    
    private var categoryService: CategoryServiceProtocol
    
    init(categoryService: CategoryServiceProtocol) {
        self.categoryService = categoryService
    }

    /// Fetch the user categories
    func getCategoryList() {
        self.view?.startActivityIndicator()
        categoryService.getUserCategories { [weak self] result in
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
    
    /// Delete category from the database
    /// - Parameters:
    /// - category:CategoryModel object
    func deleteCategory(for category: CategoryDTO) {
        view?.startActivityIndicator()
        
        categoryService.deleteCategory(for: category) { [weak self] error in
            self?.view?.stopActivityIndicator()
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            if let index = self?.categories.firstIndex(where: {
                $0.name.lowercased() == category.name.lowercased()
            }) {
                self?.categories.remove(at: index)
            }
            self?.view?.applySnapshot(animatingDifferences: true)
        }
    }
    
    /// Filter the recipe searched
    /// - Parameters:
    /// - searchText: Pass in the text used to filter recipes.
    func filterSearchedCategories(for searchText: String) {
        if searchText.isEmpty {
            categories = categoriesOriginalList
        } else {
            categories = categoriesOriginalList.filter({
                let categoryName = $0.name.lowercased()
                return categoryName.contains(searchText.lowercased())
            })
        }
        self.view?.applySnapshot(animatingDifferences: true)
    }
    
    /// Highlight tableView cell for the category received
    /// - Parameters:
    /// - section: Int for the section the category is in
    func highlightBookCategories(for section: Int) {
        selectedCategories.forEach({ category in
            if let index = categories.firstIndex(where: { $0.uid == category }) {
                let indexPath = IndexPath(row: index, section: section)
                view?.highlightCell(at: indexPath)
            }
        })
    }
    
    /// Add a selected category to the array of categories
    /// - Parameters:
    /// - index: Int of the category index
    func addSelectedCategory(at index: Int) {
        let categoryID = categories[index].uid
        selectedCategories.append(categoryID)
    }
    
    /// Remove a selected category from the array of categories
    /// - Parameters:
    /// - index: Int of the category index
    func removeSelectedCategory(from index: Int) {
        let categoryID = categories[index].uid
        if let index = selectedCategories.firstIndex(where: { $0 == categoryID }) {
            selectedCategories.remove(at: index)
        }
    }
    
    /// Handle the cell trailing swipe actions and call the methods for the action
    /// - Parameters:
    ///   - action: CellSwipeActionType Enum case
    ///   - index: Int of the category index
    func presentSwipeAction(for action: CellSwipeActionType, at index: Int) {
        let category = categories[index]
        switch action {
        case .delete:
            self.view?.displayDeleteAlert(for: category)
        case .edit:
            self.view?.presentNewCategoryController(with: category)
        }
    }
}
