//
//  CategoryPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 19/01/2022.
//

protocol CategoryPresenterDelegate: AnyObject {
    func applySnapshot(animatingDifferences: Bool)
    func showActivityIndicator()
    func stopActivityIndicator()
}

class CategoryPresenter {
    
    // MARK: - Properties
    weak var delegate: CategoryPresenterDelegate?
    var categoryService: CategoryServiceProtocol
    
    // MARK: - Initializer
    init(categoryService: CategoryServiceProtocol) {
        self.categoryService = categoryService
    }
    
    // MARK: - Public functions
    func getCategoryList() {
        self.delegate?.showActivityIndicator()
        categoryService.getCategories { [weak self] error in
            self?.delegate?.stopActivityIndicator()
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            self?.delegate?.applySnapshot(animatingDifferences: true)
        }
    }
    
    func deleteCategory(for category: CategoryModel) {
        delegate?.showActivityIndicator()
        
        categoryService.deleteCategory(for: category) { [weak self] error in
            guard let self = self else { return }
            self.delegate?.stopActivityIndicator()
             if let error = error {
                 AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                 return
             }
             if let index = self.categoryService.categories.firstIndex(where: {
                 $0.name?.lowercased() == category.name?.lowercased()
             }) {
                 self.categoryService.categories.remove(at: index)
             }
             self.delegate?.applySnapshot(animatingDifferences: true)
         }
     }
}
