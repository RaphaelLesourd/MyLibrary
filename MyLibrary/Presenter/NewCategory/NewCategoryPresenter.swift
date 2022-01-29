//
//  NewCategoryPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 19/01/2022.
//

import Foundation

class NewCategoryPresenter {
    
    // MARK: - Properties
    weak var view: NewCategoryPresenterView?
    var category: CategoryDTO?
    var selectedColor: String = CategoryColors.defaultColor {
        didSet {
            updateBackgroundTintColor()
        }
    }
    private var categoryService: CategoryServiceProtocol
    
    // MARK: - Initializer
    init(categoryService: CategoryServiceProtocol) {
        self.categoryService = categoryService
    }

    // MARK: - Public functions
    func displayCategory() {
        guard let category = category else { return }

        if let index = CategoryColors.palette.firstIndex(of: category.color) {
            let indexPath = IndexPath(item: index, section: 0)
            view?.updateCategory(at: indexPath, color: category.color, name: category.name)
        }
        selectedColor = category.color
    }

    func updateBackgroundTintColor() {
        view?.updateBackgroundTint(with: selectedColor)
    }

    func saveCategory(with name: String?) {
        guard let name = name else {
            AlertManager.presentAlertBanner(as: .error, subtitle: Text.Banner.emptyComment)
            return
        }
        guard let category = category else {
            saveNewCategory(with: name, and: selectedColor)
            return
        }
        updateCategory(for: category, with: name, and: selectedColor)
    }

    // MARK: - Private functions
    private func saveNewCategory(with name: String,
                                 and colorHex: String) {
        view?.startActivityIndicator()
        
        categoryService.addCategory(for: name, color: colorHex) { [weak self] error in
            self?.view?.stopActivityIndicator()
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            AlertManager.presentAlertBanner(as: .customMessage(Text.Banner.categoryAddedTitle))
            self?.view?.dismissViewController()
        }
    }

    private func updateCategory(for category: CategoryDTO,
                                with name: String?,
                                and colorHex: String) {
        view?.startActivityIndicator()
        
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
