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
    
    private let mainView = CategoryControllerMainView()
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
        view = mainView
        view.backgroundColor = .viewControllerBackgroundColor
        title = Text.ControllerTitle.category
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.emptyStateView.delegate = self
        configureTableView()
        addNavigationBarButtons()
        getCategoryList()
        highlightBookCategories()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        newBookDelegate?.bookCategories = selectedCategories
    }
    
    // MARK: - Setup
    private func configureTableView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = dataSource
        mainView.tableView.allowsSelection = settingBookCategory
        mainView.tableView.refreshControl = mainView.refresherControl
        mainView.refresherControl.addAction(UIAction(handler: { [weak self] _ in
            self?.getCategoryList()
        }), for: .valueChanged)
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
            if let index = categoryService.categories.firstIndex(where: { $0.uid == categories }),
               let section = dataSource.snapshot().indexOfSection(.main) {
                let indexPath = IndexPath(row: index, section: section)
                mainView.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
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
            if let index = self.categoryService.categories.firstIndex(where: {
                $0.name?.lowercased() == category.name?.lowercased()
            }) {
                self.categoryService.categories.remove(at: index)
            }
            self.applySnapshot()
        }
    }
    
    private func getCategoryList() {
        categoryService.getCategories { [weak self] error in
            self?.mainView.refresherControl.endRefreshing()
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
        AlertManager.presentAlert(title: title,
                                  message: Text.Alert.deleteCategoryMessage,
                                  cancel: true,
                                  on: self) { [weak self] _ in
            self?.deleteCategory(for: category)
        }
    }
    
    // MARK: - Navigation
    private func presentNewCategoryController(editing: Bool, category: CategoryModel? = nil) {
        let newCategoryViewController = NewCategoryViewController(editingCategory: editing,
                                                                  category: category,
                                                                  categoryService: CategoryService())
        if #available(iOS 15.0, *) {
            presentSheetController(newCategoryViewController, detents: [.large()])
        } else {
            present(newCategoryViewController, animated: true, completion: nil)
        }
    }
}
// MARK: - TableView Datasource
extension CategoriesViewController {
    
    private func makeDataSource() -> DataSource {
        dataSource = DataSource(tableView: mainView.tableView, cellProvider: { (tableView, indexPath, item) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.appTintColor.withAlphaComponent(0.5)
            cell.imageView?.tintColor = UIColor(hexString: item.color ?? "E38801")
            cell.imageView?.image = Images.ButtonIcon.selectedCategoryBadge
            cell.backgroundColor = .tertiarySystemBackground
            cell.selectedBackgroundView = backgroundView
            cell.textLabel?.text = item.name?.capitalized
            return cell
        })
        return dataSource
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        mainView.tableView.isHidden = categoryService.categories.isEmpty
        mainView.emptyStateView.isHidden = !categoryService.categories.isEmpty
        var snapshot = Snapshot()
        if !categoryService.categories.isEmpty {
            snapshot.appendSections([.main])
            snapshot.appendItems(categoryService.categories, toSection: .main)
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        highlightBookCategories()
    }
}
// MARK: - TableView Delegate
extension CategoriesViewController: UITableViewDelegate {
    // Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionTitleLabel = TextLabel(color: .label,
                                          maxLines: 2,
                                          alignment: .left,
                                          font: .subtitle)
        sectionTitleLabel.text = Text.SectionTitle.categoryListSectionHeader
        return sectionTitleLabel
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    // Footer
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sectionTitleLabel = TextLabel(color: .secondaryLabel,
                                          maxLines: 2,
                                          alignment: .center,
                                          font: .footerLabel)
        sectionTitleLabel.text = Text.SectionTitle.categoryListSectionFooter
        return sectionTitleLabel
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    // Context menu
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = self.contextMenuAction(for: .delete, forRowAtIndexPath: indexPath)
        let editAction = self.contextMenuAction(for: .edit, forRowAtIndexPath: indexPath)
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    private func contextMenuAction(for actionType: ActionType,
                                   forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
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
    
    // Selection
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
// MARK: - EmptystateViewDelegate
extension CategoriesViewController: EmptyStateViewDelegate {
    func didTapButton() {
        addNewCategory()
    }
}
