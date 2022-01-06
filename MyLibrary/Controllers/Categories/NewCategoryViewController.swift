//
//  NewCategoryViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 06/01/2022.
//

import UIKit
import IQKeyboardManagerSwift

class NewCategoryViewController: UIViewController {

    // MARK: - Properties
    private let mainView = NewCategoryMainView()
    private let editingCategory: Bool
    private let category: CategoryModel?
    private let categoryService: CategoryServiceProtocol
    private var chosenColor: String = "e38801"
    private let defaultColors: [String] = ["b83545","be4c74","ae50ae",
                                           "7e6bac","677eab","5090aa",
                                           "5e97a0","6c9d95","6c927a",
                                           "6b875e","96975e","958850",
                                           "937942","bb8122","cf8512",
                                           "e38801"]
    // ["00A5FF", "A60FFF", "FF55D1", "D50000", "FFA200", "9DBA00", "119704", "909090"]
    
    // MARK: Initializer
    init(editingCategory: Bool,
         category: CategoryModel?,
         categoryService: CategoryServiceProtocol) {
        self.editingCategory = editingCategory
        self.category = category
        self.categoryService = categoryService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
        view.backgroundColor = .viewControllerBackgroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.shouldResignOnTouchOutside = false
        mainView.categoryTextField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setEditedCategoryName()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
    
    // MARK: - Setup
    private func setupCollectionView() {
        mainView.categoryTextField.delegate = self
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
    }
  
    private func setEditedCategoryName() {
        guard let category = category,
              let name = category.name,
              let color = category.color else { return }
        mainView.categoryTextField.text = name.capitalized
        chosenColor = color
        if let index = defaultColors.firstIndex(of: color) {
            let indexPath = IndexPath(item: index, section: 0)
            mainView.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        }
    }
    
    // MARK: - Api call
    private func addCategoryToList(_ categoryName: String?) {
        guard let categoryName = categoryName else { return }
        categoryService.addCategory(for: categoryName, color: chosenColor) { [weak self] error in
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            AlertManager.presentAlertBanner(as: .customMessage(Text.Banner.categoryAddedTitle))
            self?.dismiss(animated: true)
        }
    }
    
    private func updateCategory(for category: CategoryModel?, with name: String?) {
        guard let category = category else { return }
        categoryService.updateCategoryName(for: category, with: name, color: chosenColor) { [weak self] error in
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            AlertManager.presentAlertBanner(as: .customMessage(Text.Banner.categoryModfiedTitle))
            self?.dismiss(animated: true)
        }
    }
}
// MARK: - CollectionView DataSource
extension NewCategoryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return defaultColors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionViewCell.reuseIdentifier,
                                                            for: indexPath) as? ColorCollectionViewCell else {
            return UICollectionViewCell() }
        let color = defaultColors[indexPath.row]
        cell.configure(with: color)
        return cell
    }
}
// MARK: - CollectinView Delegate
extension NewCategoryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        chosenColor = defaultColors[indexPath.row]
    }
}

// MARK: - TextField Delegate
extension NewCategoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let name = mainView.categoryTextField.text
        editingCategory ? updateCategory(for: category, with: name) : addCategoryToList(name)
        return true
    }
}
