//
//  CategoriesViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 17/11/2021.
//

import UIKit

class CategoriesViewController: UIViewController {
    
    // MARK: - Properties
    enum CategoryManagementAction: String {
        case delete = "Effacer"
        case edit = "Editer"
    }
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
        displayUnregisteredCategories()
        setCategories()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        newBookDelegate?.setCategories(with: selectedCategories)
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
                $0.name?.lowercased() == categories.lowercased()
            }) {
                let indexPath = IndexPath(row: index, section: 0)
                listView.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
            }
        })
    }
    
    // MARK: - Api call
    private func addCategoryToList(_ categoryName: String?) {
        guard let categoryName = categoryName else { return }
        self.categoryService.addCategory(for: categoryName) { [weak self] error in
            if let error = error {
                self?.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            self?.reloadTableView()
            self?.presentAlertBanner(as: .customMessage("Catégorie ajoutée"))
        }
    }
    
    private func displayUnregisteredCategories() {
        selectedCategories.forEach { category in
            categoryService.checkIfDocumentExist(categoryName: category) { [weak self] documentID in
                if documentID == nil {
                    self?.requestAction(for: category)
                }
            }
        }
    }
    
    private func deleteCategory(for categoryName: String) {
        self.categoryService.deleteCategory(for: categoryName) { [weak self] error in
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
    
    private func requestAction(for categoryName: String) {
        showInputDialog(title: "Catégorie inconnue",
                        subtitle: "Voulez-vous l'ajouter aux catégories de ce livre livre?",
                        actionTitle: "Ajouter",
                        cancelTitle: "Ignorer",
                        inputText: categoryName,
                        inputPlaceholder: "Nom",
                        inputKeyboardType: .default) { [weak self] _ in
            self?.removeCategoryFromList(categoryName)
        } actionHandler: { [weak self] category in
            self?.addCategoryToList(category)
            self?.removeCategoryFromList(categoryName)
        }
    }
    
    private func displayDeleteCategoryAlert(_ categoryName: String) {
        presentAlert(withTitle: "Effacer \(categoryName.capitalized)",
                     message: "Cette catégorie sera éffacée de votre liste.\n• Les livres contenant '\(categoryName)' ne seront pas affectés.",
                     withCancel: true) { [weak self] _ in
            self?.deleteCategory(for: categoryName)
        }
    }
    
    private func removeCategoryFromList(_ category: String?) {
        guard let category = category else { return }
        if let index = selectedCategories.firstIndex(where: {
            $0.lowercased() == category.lowercased()
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
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    private func contextMenuAction(for actionType: CategoryManagementAction,
                                   forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: actionType.rawValue) { [weak self] (_, _, completion) in
            guard let self = self else {return}
            if let categoryName = self.categoryService.categories[indexPath.row].name {
                self.displayDeleteCategoryAlert(categoryName)
                completion(true)
            }
        }
        action.backgroundColor = .systemRed
        return action
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let category = categoryService.categories[indexPath.row].name else { return }
        selectedCategories.append(category)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let category = categoryService.categories[indexPath.row].name else { return }
        removeCategoryFromList(category)
    }
}
