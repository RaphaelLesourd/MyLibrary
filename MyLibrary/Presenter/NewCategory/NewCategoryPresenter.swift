//
//  NewCategoryPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 19/01/2022.
//

import Foundation

protocol NewCategoryPresenterView: AcitivityIndicatorProtocol, AnyObject {
    func updateCategoryColor(at indexPath: IndexPath, and colorHex: String)
    func dismissViewController()
}

class NewCategoryPresenter {
    
    // MARK: - Properties
    weak var view: NewCategoryPresenterView?
    var isEditing = Bool()
    let defaultColors: [String] = ["238099","16adb7","0abfc2","3482b7","426db3","586ba4","324376",
                                           "579188","4a8259","58a94c","59996d","8fb241","a8c81b","97a948",
                                           "858974","a4a68c","ad8587","d1a8b4","a480cf","aab03b","ac985b",
                                           "af689b","ba5066","dd6e33","e25928","d23408","bb3237","a32f65",
                                           "f29340","f64c3c","ad3434","bc854e","837f72","5a6072","747781",
                                           "12d7ff","4dafff","9479ff","d7269d","fb0056","fc5102","fd9600",
                                           "ffc553","c3d696","86d9c9"]
    private var categoryService: CategoryServiceProtocol
    
    // MARK: - Initializer
    init(categoryService: CategoryServiceProtocol) {
        self.categoryService = categoryService
    }
    
    // MARK: - Public functions
    func setCategoryColor(with colorHex: String?) {
        if let color = colorHex,
           let index = defaultColors.firstIndex(of: color) {
            let indexPath = IndexPath(item: index, section: 0)
            view?.updateCategoryColor(at: indexPath, and: color)
        }
    }
    
    func saveCategory(with name: String?,
                      and colorHex: String,
                      for category: CategoryModel? = nil) {
        guard isEditing else {
            addCategoryToList(with: name, and: colorHex)
            return
        }
        updateCategory(for: category, with: name, and: colorHex)
    }
    
    // MARK: - Private functions
    private func addCategoryToList(with categoryName: String?,
                                   and colorHex: String) {
        guard let categoryName = categoryName else { return }
        view?.showActivityIndicator()
        categoryService.addCategory(for: categoryName, color: colorHex) { [weak self] error in
            self?.view?.stopActivityIndicator()
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            AlertManager.presentAlertBanner(as: .customMessage(Text.Banner.categoryAddedTitle))
            self?.view?.dismissViewController()
        }
    }
    
    private func updateCategory(for category: CategoryModel?,
                                with name: String?,
                                and colorHex: String) {
        guard let category = category else { return }
        view?.showActivityIndicator()
        categoryService.updateCategoryName(for: category, with: name, color: colorHex) { [weak self] error in
            self?.view?.stopActivityIndicator()
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            AlertManager.presentAlertBanner(as: .customMessage(Text.Banner.categoryModfiedTitle))
            self?.view?.dismissViewController()
        }
    }
    
}
