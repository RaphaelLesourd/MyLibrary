//
//  CategoriesViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 17/11/2021.
//

import UIKit

class CategoriesViewController: UIViewController {
    
    // MARK: - Properties
    typealias Snapshot = NSDiffableDataSourceSnapshot<SingleSection, CategoryModel>
    typealias DataSource = UITableViewDiffableDataSource<SingleSection, CategoryModel>
    
    var selectedCategories: [String] = []
    weak var newBookDelegate: NewBookDelegate?
    
    private let listView = CategoryControllerMainView()
    
    private lazy var dataSource = makeDataSource()
    private var categoryService: CategoryServiceProtocol
    private var settingBookCategory: Bool
    
    init(settingBookCategory: Bool, categoryService: CategoryServiceProtocol) {
        self.categoryService = categoryService
        self.settingBookCategory = settingBookCategory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Lifecycle
    override func loadView() {
        view = listView
        view.backgroundColor = .viewControllerBackgroundColor
        title = Text.ControllerTitle.category
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        addNavigationBarButtons()
        applySnapshot(animatingDifferences: false)
        getCategoryList()
        highlightBookCategories()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        newBookDelegate?.bookCategories = selectedCategories
    }
    
    // MARK: - Setup
    private func configureTableView() {
        listView.tableView.delegate = self
        listView.tableView.dataSource = dataSource
        listView.tableView.allowsSelection = settingBookCategory
        listView.tableView.refreshControl = listView.refresherControl
        listView.refresherControl.addTarget(self, action: #selector(getCategoryList), for: .valueChanged)
    }
    
    private func addNavigationBarButtons() {
        let addButton = UIBarButtonItem(image: Images.NavIcon.addIcon,
                                        style: .plain,
                                        target: self,
                                        action: #selector(addNewCategory))
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func highlightBookCategories() {
        selectedCategories.forEach({ categories in
            if let index = categoryService.categories.firstIndex(where: { $0.uid == categories }) {
                let indexPath = IndexPath(row: index, section: 0)
                listView.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
            }
        })
    }
    
    // MARK: - Api call
    private func deleteCategory(for category: CategoryModel) {
        categoryService.deleteCategory(for: category) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            if let index = self.categoryService.categories.firstIndex(where: { $0.name?.lowercased() == category.name?.lowercased() }) {
                self.categoryService.categories.remove(at: index)
            }
            self.applySnapshot()
        }
    }
    
    @objc private func getCategoryList() {
        categoryService.getCategories { [weak self] error in
            self?.listView.refresherControl.endRefreshing()
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            self?.applySnapshot()
        }
    }
    
    // MARK: - Categories dialog
    @objc private func addNewCategory() {
        presentNewCategoryController(editing: false)
    }
    
    private func displayDeleteCategoryAlert(_ category: CategoryModel) {
        let title = Text.ButtonTitle.delete + " " + (category.name?.capitalized ?? "")
        AlertManager.presentAlert(withTitle: title,
                                  message: Text.Alert.deleteCategoryMessage,
                                  withCancel: true,
                                  on: self) { [weak self] _ in
            self?.deleteCategory(for: category)
        }
    }
    
    // MARK: - Navigation
    private func presentNewCategoryController(editing: Bool, category: CategoryModel? = nil) {
        let newCategoryViewController = NewCategoryViewController(editingCategory: editing,
                                                                  category: category,
                                                                  categoryService: CategoryService())
        present(newCategoryViewController, animated: true, completion: nil)
    }
}
// MARK: - TableView Datasource
extension CategoriesViewController {
    
    private func makeDataSource() -> DataSource {
        dataSource = DataSource(tableView: listView.tableView, cellProvider: { (tableView, indexPath, item) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.appTintColor.withAlphaComponent(0.5)
            cell.imageView?.tintColor = UIColor(hexString: item.color ?? "FFFFFF")
            cell.imageView?.image = UIImage(systemName: "circle.fill")
            cell.backgroundColor = .tertiarySystemBackground
            cell.selectedBackgroundView = backgroundView
            cell.textLabel?.text = item.name?.capitalized
            return cell
        })
        return dataSource
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(categoryService.categories, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        highlightBookCategories()
    }
}
// MARK: - TableView Delegate
extension CategoriesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = self.contextMenuAction(for: .delete, forRowAtIndexPath: indexPath)
        let editAction = self.contextMenuAction(for: .edit, forRowAtIndexPath: indexPath)
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    private func contextMenuAction(for actionType: ActionType, forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: actionType.title) { [weak self] (_, _, completion) in
            guard let self = self else {return}
            
            let category = self.categoryService.categories[indexPath.row]
            switch actionType {
            case .delete:
                self.displayDeleteCategoryAlert(category)
            case .edit:
                self.presentNewCategoryController(editing: true, category: category)
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
        if let index = selectedCategories.firstIndex(where: { $0 == categoryID }) {
            selectedCategories.remove(at: index)
        }
    }
}
