//
//  CategoriesViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 17/11/2021.
//

import UIKit

class CategoriesViewController: UIViewController {
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<SingleSection, CategoryDTO>
    weak var newBookDelegate: NewBookViewControllerDelegate?
    
    private lazy var dataSource = makeDataSource()
    private let mainView = ListMainView()
    private let presenter: CategoryPresenter
    private let factory: Factory
    private var isSelecting: Bool
    
    init(isSelecting: Bool,
         selectedCategories: [String],
         newBookDelegate: NewBookViewControllerDelegate?,
         categoryPresenter: CategoryPresenter,
         factory: Factory) {
        self.isSelecting = isSelecting
        self.newBookDelegate = newBookDelegate
        self.presenter = categoryPresenter
        self.presenter.selectedCategories = selectedCategories
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = mainView
        view.backgroundColor = .viewControllerBackgroundColor
        title = Text.ControllerTitle.category
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        mainView.emptyStateView.delegate = self
        mainView.delegate = self
        addNavigationBarButtons()
        addSearchController()
        configureTableView()
        configureEmpStateView()
        applySnapshot(animatingDifferences: false)
        presenter.getCategoryList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        newBookDelegate?.setCategories(with: presenter.selectedCategories)
    }
    
    // MARK: Setup
    private func configureTableView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = dataSource
        mainView.tableView.allowsSelection = isSelecting
        mainView.tableView.refreshControl = mainView.refresherControl
    }
    
    private func configureEmpStateView() {
        mainView.emptyStateView.configure(title: Text.EmptyState.categoryTitle,
                                          subtitle: Text.EmptyState.categorySubtitle,
                                          icon: Images.ButtonIcon.selectedCategoryBadge)
    }
    
    private func addNavigationBarButtons() {
        let addButton = UIBarButtonItem(image: Images.NavIcon.addIcon,
                                        style: .plain,
                                        target: self,
                                        action: #selector(addNewCategory))
        let activityIndicactor = UIBarButtonItem(customView: mainView.activityIndicator)
        self.navigationItem.rightBarButtonItems = [addButton, activityIndicactor]
    }
    
    private func addSearchController() {
        mainView.searchController.searchResultsUpdater = self
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = mainView.searchController
        self.definesPresentationContext = true
    }
    
    @objc private func addNewCategory() {
        presentNewCategoryController()
    }
}

// MARK: - TableView Datasource
extension CategoriesViewController {
    
    private func makeDataSource() -> CategoryDataSource {
        dataSource = CategoryDataSource(tableView: mainView.tableView,
                                cellProvider: { (tableView, indexPath, item) -> UITableViewCell? in
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.appTintColor.withAlphaComponent(0.3)
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.selectedBackgroundView = backgroundView
            cell.imageView?.tintColor = UIColor(hexString: item.color)
            cell.imageView?.image = Images.ButtonIcon.selectedCategoryBadge
            cell.backgroundColor = .tertiarySystemBackground
            cell.textLabel?.text = item.name.capitalized
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
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        }
        if let section = dataSource.snapshot().indexOfSection(.main) {
            presenter.highlightBookCategories(for: section)
        }
    }
}

// MARK: - TableView Delegate
extension CategoriesViewController: UITableViewDelegate {
    // Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionTitleLabel = TextLabel(color: .secondaryLabel,
                                          maxLines: 2,
                                          alignment: .left,
                                          font: .footerLabel)
        sectionTitleLabel.text = Text.SectionTitle.categoryListSectionHeader.uppercased()
        return sectionTitleLabel
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
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
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = makeContextMenuAction(for: .delete, forRowAtIndexPath: indexPath)
        let editAction = makeContextMenuAction(for: .edit, forRowAtIndexPath: indexPath)
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    private func makeContextMenuAction(for actionType: CellSwipeActionType,
                                       forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: actionType.title) { [weak self] (_, _, completion) in
            self?.presenter.presentSwipeAction(for: actionType, at: indexPath.row)
            completion(true)
        }
        action.backgroundColor = actionType.color
        return action
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.addSelectedCategory(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        presenter.removeSelectedCategory(from: indexPath.row)
    }
}

// MARK: Emptystate view delegate
extension CategoriesViewController: EmptyStateViewDelegate {
    func didTapButton() {
        addNewCategory()
    }
}

// MARK: List main view delegate
extension CategoriesViewController: ListMainViewDelegate {
    func refreshPulled() {
        presenter.getCategoryList()
    }
}

// MARK: Category presenter delegate
extension CategoriesViewController: CategoryPresenterView {
    
    func displayDeleteAlert(for category: CategoryDTO) {
        let title = Text.ButtonTitle.delete + " " + category.name.capitalized
        AlertManager.presentAlert(title: title,
                                  message: Text.Alert.deleteCategoryMessage,
                                  cancel: true) { [weak self] _ in
            self?.presenter.deleteCategory(for: category)
        }
    }
    
    func presentNewCategoryController(with category: CategoryDTO? = nil) {
        let newCategoryViewController = factory.makeNewCategoryVC(category: category)
        if #available(iOS 15.0, *) {
            presentSheetController(newCategoryViewController, detents: [.large()])
        } else {
            present(newCategoryViewController, animated: true, completion: nil)
        }
    }

    /// Highlight cell for the data saved
    /// - Parameters: IndexPath of the data fetched
    func highlightCell(at indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.mainView.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
    }
    
    func startActivityIndicator() {
        self.mainView.activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        DispatchQueue.main.async {
            self.mainView.activityIndicator.stopAnimating()
            self.mainView.refresherControl.endRefreshing()
        }
    }
}

// MARK: - Search Result updating
extension CategoriesViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {return}
        presenter.filterSearchedCategories(for: searchText)
    }
}
