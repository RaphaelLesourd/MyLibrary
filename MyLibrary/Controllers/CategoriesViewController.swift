//
//  CategoriesViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 17/11/2021.
//

import UIKit

class CategoriesViewController: UIViewController {
    
    // MARK: - Properties
    weak var newBookDelegate: NewBookDelegate?
    
    private let categoryService = CategoryService.shared
    private let listView        = ListTableView()
   
    var selectedCategories: [String] = []
    var settingBookCategory = true
    
    // MARK: - Lifecycle
    override func loadView() {
        view = listView
        view.backgroundColor = .viewControllerBackgroundColor
        title = Text.ControllerTitle.category
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listView.tableView.allowsSelection = settingBookCategory
        setDelegates()
        setTableViewRefresherControl()
        addNavigationBarButtons()
        setCategories()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        newBookDelegate?.bookCategories = selectedCategories
    }
    
    // MARK: - Setup
    private func setDelegates() {
        listView.tableView.delegate = self
        listView.tableView.dataSource = self
    }
    
    private func setTableViewRefresherControl() {
        listView.tableView.refreshControl = listView.refresherControl
        listView.refresherControl.addTarget(self, action: #selector(reloadList), for: .valueChanged)
    }
    
    private func addNavigationBarButtons() {
        let addButton = UIBarButtonItem(image: Images.addIcon,
                                        style: .plain,
                                        target: self,
                                        action: #selector(addNewCategory))
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func setCategories() {
        selectedCategories.forEach({ categories in
            if let index = categoryService.categories.firstIndex(where: {
                $0.uid == categories
            }) {
                let indexPath = IndexPath(row: index, section: 0)
                listView.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
            }
        })
    }
    
    // MARK: - Api call
    private func addCategoryToList(_ categoryName: String?) {
        guard let categoryName = categoryName else { return }
        categoryService.addCategory(for: categoryName) { [weak self] error in
            if let error = error {
                self?.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            self?.reloadTableView()
            self?.presentAlertBanner(as: .customMessage("Catégorie ajoutée"))
        }
    }
    
    private func updateCategory(for category: Category, with name: String?) {
        categoryService.updateCategoryName(for: category, with: name) { [weak self] error in
            if let error = error {
                self?.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            self?.reloadTableView()
            self?.presentAlertBanner(as: .customMessage("Catégorie ajoutée"))
        }
    }
    
    private func deleteCategory(for categoryName: String) {
        categoryService.deleteCategory(for: categoryName) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            if let index = self.categoryService.categories.firstIndex(where: {
                $0.name?.lowercased() == categoryName.lowercased()
            }) {
                self.categoryService.categories.remove(at: index)
            }
            self.reloadTableView()
        }
    }
  
    @objc private func reloadList() {
        categoryService.getCategories { [weak self] error in
            self?.listView.refresherControl.endRefreshing()
            if let error = error {
                self?.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
    
    // MARK: - Add categories dialog
    @objc private func addNewCategory() {
        showInputDialog(title: "Nouvelle catégorie",
                        subtitle: "Ajouter une nouvelle catégorie.",
                        actionTitle: "Ajouter", inputText: "",
                        inputPlaceholder: "Nom de catégorie",
                        actionHandler: { [weak self] category in
            self?.addCategoryToList(category)
        })
    }
    
    private func displayDeleteCategoryAlert(_ categoryName: String) {
        presentAlert(withTitle: "Effacer \(categoryName.capitalized)",
                     message: "Cette catégorie sera éffacée de votre liste.\n• Les livres contenant '\(categoryName)' ne seront pas affectés.",
                     withCancel: true) { [weak self] _ in
            self?.deleteCategory(for: categoryName)
        }
    }
    
    private func updateCategoryAlert(for category: Category) {
        showInputDialog(title: "Modifier \(category.name?.capitalized ?? "")",
                        subtitle: "",
                        actionTitle: "Ok",
                        cancelTitle: "Annuler",
                        inputText: "",
                        inputPlaceholder: "Nouveau nom",
                        inputKeyboardType: .default,
                        cancelHandler: nil) { [weak self] text in
            self?.updateCategory(for: category, with: text)
        }
    }
    
    private func removeCategoryFromList(_ categoryID: String?) {
        guard let categoryID = categoryID else { return }
        if let index = selectedCategories.firstIndex(where: {
            $0 == categoryID
        }) {
            selectedCategories.remove(at: index)
        }
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async {
            self.listView.tableView.reloadData()
        }
    }
}
// MARK: - TableView Datasource
extension CategoriesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryService.categories.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Toutes vos catégories"
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .tertiarySystemBackground
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.appTintColor.withAlphaComponent(0.5)
        cell.selectedBackgroundView = backgroundView
        let category = categoryService.categories[indexPath.row]
        cell.textLabel?.text = category.name?.capitalized
        return cell
    }
}
// MARK: - TableView Delegate
extension CategoriesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = self.contextMenuAction(for: .delete, forRowAtIndexPath: indexPath)
        let editAction = self.contextMenuAction(for: .edit, forRowAtIndexPath: indexPath)
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
 
    private func contextMenuAction(for actionType: CategoryManagementAction,
                                   forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: actionType.rawValue) { [weak self] (_, _, completion) in
            guard let self = self else {return}
            switch actionType {
            case .delete:
                if let categoryName = self.categoryService.categories[indexPath.row].name {
                    self.displayDeleteCategoryAlert(categoryName)
                }
            case .edit:
                let category = self.categoryService.categories[indexPath.row]
                self.updateCategoryAlert(for: category)
            }
            completion(true)
        }
        action.backgroundColor = actionType.color
        return action
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let categoryID = categoryService.categories[indexPath.row].uid else { return }
        selectedCategories.append(categoryID)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let categoryID = categoryService.categories[indexPath.row].uid else { return }
        removeCategoryFromList(categoryID)
    }
}
