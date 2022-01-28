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
    var selectedColor: String = "e38801" {
        didSet {
            updateBackgroundTintColor()
        }
    }
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
    func displayCategory() {
        guard let category = category else { return }

        if let index = defaultColors.firstIndex(of: category.color) {
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
            createCategory(with: name, and: selectedColor)
            return
        }
        updateCategory(for: category, with: name, and: selectedColor)
    }

    // MARK: - Private functions
    private func createCategory(with name: String,
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
