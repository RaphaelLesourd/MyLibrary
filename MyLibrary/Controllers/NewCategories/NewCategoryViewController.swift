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
    private let presenter: NewCategoryPresenter

    // MARK: Initializer
    init(category: CategoryDTO?,
         presenter: NewCategoryPresenter) {
        self.presenter = presenter
        self.presenter.category = category
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
        mainView.configure(for: presenter.category != nil)
        mainView.delegate = self
        mainView.categoryTextField.delegate = self
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.displayCategory()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainView.setCollectionViewHeight()
    }
}

// MARK: - CollectionView DataSource
extension NewCategoryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CategoryColors.palette.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionViewCell.reuseIdentifier,
                                                            for: indexPath) as? ColorCollectionViewCell else {
            return UICollectionViewCell() }
        let color = CategoryColors.palette[indexPath.row]
        cell.configure(with: color)
        return cell
    }
}

// MARK: - CollectinView Delegate
extension NewCategoryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.selectedColor = CategoryColors.palette[indexPath.row]
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
        presenter.saveCategory(with: mainView.categoryTextField.text)
    }
}

// MARK: - Presenter Delegate
extension NewCategoryViewController: NewCategoryPresenterView {

    func updateBackgroundTint(with colorHex: String) {
        mainView.updateBackgroundColor(with: colorHex)
    }

    func updateCategory(at indexPath: IndexPath, color: String, name: String) {

        mainView.collectionView.selectItem(at: indexPath,
                                           animated: false,
                                           scrollPosition: .centeredVertically)
        mainView.categoryTextField.text = name
    }
    
    func startActivityIndicator() {
        mainView.saveButton.toggleActivityIndicator(to: true)
    }
    
    func stopActivityIndicator() {
        DispatchQueue.main.async {
            self.mainView.saveButton.toggleActivityIndicator(to: false)
        }
    }
    
    func dismissViewController() {
        self.dismiss(animated: true)
    }
}
