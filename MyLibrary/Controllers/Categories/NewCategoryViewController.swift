//
//  NewCategoryViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 06/01/2022.
//

import UIKit

class NewCategoryViewController: UIViewController {
    
    // MARK: - Properties
    private let mainView = NewCategoryMainView()
    private let colorPicker = UIColorPickerViewController()
    private let editingCategory: Bool
    private let category: CategoryModel?
    private let categoryService: CategoryServiceProtocol
    private var chosenColor: String = "e38801" {
        didSet {
            mainView.updateBackgroundColor(with: chosenColor)
        }
    }
    private let defaultColors: [String] = ["238099","16adb7","0abfc2","3482b7","426db3","586ba4","324376",
                                           "579188","4a8259","58a94c","59996d","8fb241","a8c81b","97a948",
                                           "858974","a4a68c","ad8587","d1a8b4","a480cf","aab03b","ac985b",
                                           "af689b","ba5066","dd6e33","e25928","d23408","bb3237","a32f65",
                                           "f29340","f64c3c","ad3434","bc854e","837f72","5a6072","747781",
                                           "12d7ff","4dafff","9479ff","d7269d","fb0056","fc5102","fd9600",
                                           "ffc553","c3d696","86d9c9"]
    
    // MARK: - Initializer
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

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.configure(for: editingCategory)
        mainView.delegate = self
        mainView.categoryTextField.delegate = self
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setEditedCategoryName()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainView.setCollectionViewHeight()
    }

    // MARK: - Setup
    private func setEditedCategoryName() {
        guard let category = category,
              let name = category.name else { return }
        mainView.categoryTextField.text = name.capitalized
        if let color = category.color,
           let index = defaultColors.firstIndex(of: color) {
            let indexPath = IndexPath(item: index, section: 0)
            mainView.collectionView.selectItem(at: indexPath,
                                               animated: false,
                                               scrollPosition: .centeredVertically)
            chosenColor = color
        }
    }
    
    private func selectColor() {
        colorPicker.supportsAlpha = true
        colorPicker.selectedColor = UIColor(hexString: chosenColor)
        self.present(colorPicker, animated: true)
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
        saveCategory()
        return true
    }
}
// MARK: - NewCategoryViewDelegate
extension NewCategoryViewController: NewCategoryViewDelegate {
    func saveCategory() {
        let name = mainView.categoryTextField.text
        editingCategory ? updateCategory(for: category, with: name) : addCategoryToList(name)
    }
}
