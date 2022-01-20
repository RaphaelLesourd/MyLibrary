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
    
    weak var newBookDelegate: NewBookDelegate?
    var selectedCategories: [String] = []
    
    private let mainView = CategoryControllerMainView()
    private let presenter: CategoryPresenter
    private lazy var dataSource = makeDataSource()
    private var settingBookCategory: Bool
    
    init(settingBookCategory: Bool,
         categoryPresenter: CategoryPresenter) {
        self.settingBookCategory = settingBookCategory
        self.presenter = categoryPresenter
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
        presenter.view = self
        mainView.emptyStateView.delegate = self
        configureTableView()
        addNavigationBarButtons()
        applySnapshot(animatingDifferences: false)
        presenter.getCategoryList()
        highlightBookCategories(with: selectedCategories)
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
            self?.presenter.getCategoryList()
        }), for: .valueChanged)
    }
    
    private func addNavigationBarButtons() {
        let addButton = UIBarButtonItem(image: Images.NavIcon.addIcon,
                                        style: .plain,
                                        target: self,
                                        action: #selector(addNewCategory))
        let activityIndicactor = UIBarButtonItem(customView: mainView.activityIndicator)
        navigationItem.rightBarButtonItems = [addButton, activityIndicactor]
    }
    
    func highlightBookCategories(with selectedCategories: [String]) {
        selectedCategories.forEach({ categories in
            if let index = presenter.categories.firstIndex(where: { $0.uid == categories }),
               let section = dataSource.snapshot().indexOfSection(.main) {
                let indexPath = IndexPath(row: index, section: section)
                mainView.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
            }
        })
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
            self?.presenter.deleteCategory(for: category)
        }
    }
    
    // MARK: - Navigation
    private func presentNewCategoryController(editing: Bool, category: CategoryModel? = nil) {
        let presenter = NewCategoryPresenter(categoryService: CategoryService())
        let newCategoryViewController = NewCategoryViewController(editingCategory: editing,
                                                                  category: category,
                                                                  presenter: presenter)
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
        dataSource = DataSource(tableView: mainView.tableView,
                                cellProvider: { (tableView, indexPath, item) -> UITableViewCell? in
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
    
    func applySnapshot(animatingDifferences: Bool) {
        mainView.tableView.isHidden = presenter.categories.isEmpty
        mainView.emptyStateView.isHidden = !presenter.categories.isEmpty
        
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(presenter.categories, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        
        highlightBookCategories(with: self.selectedCategories)
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
    
    private func contextMenuAction(for actionType: ActionType, forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: actionType.title) { [weak self] (_, _, completion) in
            guard let self = self else {return}
            
            let category = self.presenter.categories[indexPath.row]
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
        guard let categoryID = presenter.categories[indexPath.row].uid else { return }
        selectedCategories.append(categoryID)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let categoryID = presenter.categories[indexPath.row].uid else { return }
        if let index = selectedCategories.firstIndex(where: { $0 == categoryID }) {
            selectedCategories.remove(at: index)
        }
    }
}
// MARK: - EmptystateView Delegate
extension CategoriesViewController: EmptyStateViewDelegate {
    func didTapButton() {
        addNewCategory()
    }
}
// MARK: - CategoryPresenter Delegate
extension CategoriesViewController: CategoryPresenterView {
    
    func showActivityIndicator() {
        DispatchQueue.main.async {
            self.mainView.activityIndicator.startAnimating()
        }
    }
    
    func stopActivityIndicator() {
        DispatchQueue.main.async {
            self.mainView.activityIndicator.stopAnimating()
            self.mainView.refresherControl.endRefreshing()
        }
    }
}
