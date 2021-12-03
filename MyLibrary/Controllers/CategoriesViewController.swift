//
//  CategoriesViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 17/11/2021.
//

import UIKit

class CategoriesViewController: UIViewController {
    
    // MARK: - Properties
    typealias Snapshot   = NSDiffableDataSourceSnapshot<SingleSection, Category>
    typealias DataSource = UITableViewDiffableDataSource<SingleSection, Category>
   
    var dataSource        : DataSource!
    var selectedCategories: [String] = []
    var settingBookCategory = true
    
    weak var newBookDelegate: NewBookDelegate?
    
    private let categoryService = CategoryService.shared
    private let listView        = ListTableView()

    // MARK: - Lifecycle
    override func loadView() {
        view = listView
        view.backgroundColor = .viewControllerBackgroundColor
        title = Text.ControllerTitle.category
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listView.tableView.allowsSelection = settingBookCategory
        makeDataSource()
        applySnapshot(animatingDifferences: false)
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
            self?.applySnapshot()
            self?.presentAlertBanner(as: .customMessage("Catégorie ajoutée"))
        }
    }
    
    private func updateCategory(for category: Category, with name: String?) {
        categoryService.updateCategoryName(for: category, with: name) { [weak self] error in
            if let error = error {
                self?.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            self?.applySnapshot()
            self?.presentAlertBanner(as: .customMessage("Catégorie ajoutée"))
        }
    }
    
    private func deleteCategory(for category: Category) {
        categoryService.deleteCategory(for: category) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            if let index = self.categoryService.categories.firstIndex(where: {
                $0.name?.lowercased() == category.name?.lowercased()
            }) {
                self.categoryService.categories.remove(at: index)
            }
            self.applySnapshot()
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
    
    private func displayDeleteCategoryAlert(_ category: Category) {
        presentAlert(withTitle: "Effacer \(category.name?.capitalized ?? "")",
                     message: "Etes vous sur de vouloir éffacer cette catégorie?",
                     withCancel: true) { [weak self] _ in
            self?.deleteCategory(for: category)
        }
    }
    
    private func removeCategoryFromList(_ category: Category) {
        guard let categoryID = category.uid else { return }
        if let index = selectedCategories.firstIndex(where: {
            $0 == categoryID
        }) {
            selectedCategories.remove(at: index)
        }
    }
    
    private func updateCategoryAlert(for category: Category) {
        showInputDialog(title: "Modifier \(category.name?.capitalized ?? "")",
                        subtitle: "",
                        actionTitle: "Ok",
                        cancelTitle: "Annuler",
                        inputText: category.name?.capitalized,
                        inputPlaceholder: "",
                        inputKeyboardType: .default,
                        cancelHandler: nil) { [weak self] text in
            self?.updateCategory(for: category, with: text)
        }
    }
}
// MARK: - TableView Datasource
extension CategoriesViewController {
 
    private func makeDataSource() {
        dataSource = DataSource(tableView: listView.tableView, cellProvider: { (tableView, indexPath, item) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.backgroundColor = .tertiarySystemBackground
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.appTintColor.withAlphaComponent(0.5)
            cell.selectedBackgroundView = backgroundView
            cell.textLabel?.text = item.name?.capitalized
            
            return cell
        })
        listView.tableView.dataSource = dataSource
        applySnapshot()
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(categoryService.categories, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
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
               let category = self.categoryService.categories[indexPath.row]
               self.displayDeleteCategoryAlert(category)
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
        let category = categoryService.categories[indexPath.row]
        removeCategoryFromList(category)
    }
}
