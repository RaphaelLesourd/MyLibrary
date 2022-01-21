//
//  NewCategoryViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 06/01/2022.
//

import UIKit

class NewCategoryViewController: UIViewController {
    
    // MARK: Properties
    private let mainView = NewCategoryMainView()
    private let editingCategory: Bool
    private let category: CategoryModel?
    private let presenter: NewCategoryPresenter
    var chosenColor: String = "e38801" {
        didSet {
            mainView.updateBackgroundColor(with: chosenColor)
        }
    }
    
    // MARK: Initializer
    init(editingCategory: Bool,
         category: CategoryModel?,
         presenter: NewCategoryPresenter) {
        self.editingCategory = editingCategory
        self.category = category
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func loadView() {
        view = mainView
        view.backgroundColor = .viewControllerBackgroundColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        presenter.isEditing = editingCategory
        mainView.configure(for: editingCategory)
        mainView.delegate = self
        mainView.categoryTextField.delegate = self
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setEditedCategoryName()
        presenter.setCategoryColor(with: category?.color)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainView.setCollectionViewHeight()
    }

    // MARK: Setup
    private func setEditedCategoryName() {
        guard let category = category,
              let name = category.name else { return }
        mainView.categoryTextField.text = name.capitalized
        
    }
}

// MARK: - CollectionView DataSource
extension NewCategoryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.defaultColors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionViewCell.reuseIdentifier,
                                                            for: indexPath) as? ColorCollectionViewCell else {
            return UICollectionViewCell() }
        let color = presenter.defaultColors[indexPath.row]
        cell.configure(with: color)
        return cell
    }
}

// MARK: - CollectinView Delegate
extension NewCategoryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        chosenColor = presenter.defaultColors[indexPath.row]
    }
}

// MARK: - TextField Delegate
extension NewCategoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveCategory()
        return true
    }
}

// MARK: - NewCategoryView Delegate
extension NewCategoryViewController: NewCategoryViewDelegate {
    func saveCategory() {
        presenter.saveCategory(with: mainView.categoryTextField.text,
                               and: chosenColor,
                               for: category)
    }
}

// MARK: - Presenter Delegate
extension NewCategoryViewController: NewCategoryPresenterView {
   func updateCategoryColor(at indexPath: IndexPath, and colorHex: String) {
        mainView.collectionView.selectItem(at: indexPath,
                                           animated: false,
                                           scrollPosition: .centeredVertically)
        chosenColor = colorHex
    }
    
    func showActivityIndicator() {
        mainView.saveButton.displayActivityIndicator(true)
    }
    
    func stopActivityIndicator() {
        DispatchQueue.main.async {
            self.mainView.saveButton.displayActivityIndicator(false)
        }
    }
    
    func dismissViewController() {
        self.dismiss(animated: true)
    }
}
