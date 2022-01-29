//
//  ListTableViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 22/01/2022.
//

import UIKit

class ListTableViewController: UIViewController {

    typealias Snapshot = NSDiffableDataSourceSnapshot<ListSection, DataList>
    weak var newBookDelegate: NewBookViewControllerDelegate?

    private let mainView = ListMainView()
    private lazy var dataSource = makeDataSource()
    private let presenter: ListPresenter

    init(receivedData: String?,
         newBookDelegate: NewBookViewControllerDelegate?,
         presenter: ListPresenter) {
        self.newBookDelegate = newBookDelegate
        self.presenter = presenter
        self.presenter.selection = receivedData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = mainView
        view.backgroundColor = .viewControllerBackgroundColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        addSearchController()
        configureEmpStateView()
        applySnapshot(animatingDifferences: false)
        mainView.emptyStateView.delegate = self
        presenter.view = self
        presenter.getControllerTitle()
        presenter.getData()
    }
    
    // MARK: - Setup
    private func configureTableView() {
        mainView.tableView.dataSource = dataSource
        mainView.tableView.delegate = self
    }
    
    private func addSearchController() {
        mainView.searchController.searchResultsUpdater = self
        self.navigationItem.searchController = mainView.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.definesPresentationContext = true
    }
    
    private func configureEmpStateView() {
        mainView.emptyStateView.configure(title: presenter.listDataType.title,
                                          subtitle: Text.EmptyState.listSubtitle,
                                          icon: presenter.listDataType.icon,
                                          hideButton: false)
    }
}
// MARK: - TableView delegate
extension ListTableViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = dataSource.snapshot().sectionIdentifiers[section]
        let numberOfItemsInsection = dataSource.snapshot().numberOfItems(inSection: section)
        let sectionTitleLabel = TextLabel(color: .secondaryLabel,
                                          maxLines: 1,
                                          alignment: .center,
                                          font: .lightSectionTitle)
        sectionTitleLabel.text = numberOfItemsInsection == 0 ? "" : section.headerTitle
        return sectionTitleLabel
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let section = dataSource.snapshot().sectionIdentifiers[section]
        let sectionFooterLabel = TextLabel(color: .secondaryLabel,
                                           maxLines: 2,
                                           alignment: .center,
                                           font: .lightFootnote)
        sectionFooterLabel.text = section.footerTitle
        return sectionFooterLabel
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        UISwipeActionsConfiguration(actions: [makeFavoriteContextualAction(forRowAt: indexPath)])
    }
    
    private func makeFavoriteContextualAction(forRowAt indexPath: IndexPath) -> UIContextualAction {
        guard let data = dataSource.itemIdentifier(for: indexPath) else {
            return UIContextualAction()
        }
        let action = UIContextualAction(style: .normal, title: nil) { [weak self] (_, _, completion) in
            data.favorite ? self?.presenter.removeFavorite(with: data) : self?.presenter.addToFavorite(with: data)
            completion(true)
        }
        action.backgroundColor = .favoriteColor
        action.image = data.favorite ? Images.ButtonIcon.favoriteNot : Images.ButtonIcon.favorite
        return action
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = dataSource.itemIdentifier(for: indexPath)
        presenter.getSelectedData(from: data)
    }
}
// MARK: - TableView Datasource
extension ListTableViewController {
    
    private func makeDataSource() -> ListDataSource {
        dataSource = ListDataSource(tableView: mainView.tableView,
                                    cellProvider: { (_, _, item) -> UITableViewCell? in
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.appTintColor.withAlphaComponent(0.3)
            
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "reuseIdentifier")
            cell.selectedBackgroundView = backgroundView
            cell.backgroundColor = .tertiarySystemBackground
            cell.textLabel?.text = item.title.capitalized
            
            cell.detailTextLabel?.text = item.subtitle.uppercased()
            cell.detailTextLabel?.textColor = .appTintColor
            
            cell.imageView?.image = Images.ButtonIcon.favorite
            cell.imageView?.tintColor = item.favorite ? .favoriteColor : UIColor.favoriteColor.withAlphaComponent(0.1)
            return cell
        })
        return dataSource
    }
    
    func applySnapshot(animatingDifferences: Bool) {
        mainView.tableView.isHidden = presenter.data.isEmpty
        mainView.emptyStateView.isHidden = !presenter.data.isEmpty
        
        var snapshot = Snapshot()
        
        let favorite = presenter.data.filter({ $0.favorite == true })
        snapshot.appendSections([.favorite])
        snapshot.appendItems(favorite, toSection: .favorite)
        
        let others = presenter.data.filter({ $0.favorite == false })
        snapshot.appendSections([.others])
        snapshot.appendItems(others, toSection: .others)
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        presenter.highlightCell()
    }
}

// MARK: - UISearch result
extension ListTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {return}
        presenter.filterList(with: searchText)
    }
}

// MARK: - List Presenter View
extension ListTableViewController: ListPresenterView {
    func reloadRow(for item: DataList) {
        var snapshot = dataSource.snapshot()
        snapshot.reloadItems([item])
        dataSource.apply(snapshot)
        applySnapshot(animatingDifferences: true)
    }
    
    func setLanguage(with code: String) {
        newBookDelegate?.setLanguage(with: code)
    }
    
    func setCurrency(with code: String) {
        newBookDelegate?.setCurrency(with: code)
    }
    
    func setTitle(as title: String) {
        self.title = title
    }

    /// Highlist tableView cell for the feched data.
    /// - Parameters:
    /// - item: Datalist object of the data to hightlight.
    /// - Note: To construct the IndexPath we capture the section and Index Int value  from the snapshot.
    func highlightCell(for item: DataList) {
        guard let section = dataSource.snapshot().sectionIdentifier(containingItem: item),
              let index = dataSource.snapshot().indexOfItem(item) else { return }
        let indexPath = IndexPath(row: index, section: section.tag)
        DispatchQueue.main.async {
            self.mainView.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
        }
    }
}
// MARK: - EmptyStateView Delegate
extension ListTableViewController: EmptyStateViewDelegate {
    func didTapButton() {
        mainView.searchController.searchBar.text = nil
    }
}
