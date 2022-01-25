//
//  ListTableViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 22/01/2022.
//

import UIKit

class ListTableViewController: UITableViewController {
    
    // MARK: - Properties
    typealias Snapshot = NSDiffableDataSourceSnapshot<ListSection, ListRepresentable>
    typealias DataSource = UITableViewDiffableDataSource<ListSection, ListRepresentable>
    weak var newBookDelegate: NewBookViewControllerDelegate?
    
    private lazy var dataSource = makeDataSource()
    private let searchController = UISearchController(searchResultsController: nil)
    private let presenter: ListPresenter
    private var sectionTitle = String()
    
    // MARK: - Initializer
    init(receivedData: String?,
         newBookDelegate: NewBookViewControllerDelegate?,
         presenter: ListPresenter) {
        self.newBookDelegate = newBookDelegate
        self.presenter = presenter
        self.presenter.receivedData = receivedData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        addSearchController()
        applySnapshot(animatingDifferences: false)
        presenter.view = self
        presenter.getControllerTitle()
        presenter.getData()
    }
    
    // MARK: - Setup
    private func configureTableView() {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        tableView.allowsSelection = true
        tableView.showsVerticalScrollIndicator = true
        tableView.backgroundColor = .viewControllerBackgroundColor
        tableView.dataSource = dataSource
    }
    
    private func addSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Text.Placeholder.search
        searchController.automaticallyShowsSearchResultsController = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
    }
    
    // MARK: - Table view data source
    // Header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = dataSource.snapshot().sectionIdentifiers[section]
        let sectionTitleLabel = TextLabel(color: .secondaryLabel,
                                          maxLines: 1,
                                          alignment: .center,
                                          font: .footerLabel)
        sectionTitleLabel.text = section.headerTitle
        return sectionTitleLabel
    }
    
    // Footer
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let section = dataSource.snapshot().sectionIdentifiers[section]
        let sectionFooterLabel = TextLabel(color: .secondaryLabel,
                                          maxLines: 2,
                                          alignment: .center,
                                          font: .footerLabel)
        if section == .others {
            sectionFooterLabel.text = Text.SectionTitle.listFooter
        }
        return sectionFooterLabel
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    // MARK: - Table view delegate
    // Context menu
    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favorite = self.contextMenuAction(forRowAtIndexPath: indexPath)
        return UISwipeActionsConfiguration(actions: [favorite])
    }
    
    private func contextMenuAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = dataSource.itemIdentifier(for: indexPath)
        presenter.getSelectedData(from: data)
    }
}
// MARK: - TableView Datasource
extension ListTableViewController {
    
    private func makeDataSource() -> DataSource {
        dataSource = DataSource(tableView: tableView,
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
            var snapshot = Snapshot()
            snapshot.appendSections([.favorite, .others])
            snapshot.appendItems(presenter.data.filter({ $0.favorite == true }), toSection: .favorite)
            snapshot.appendItems(presenter.data.filter({ $0.favorite == false }), toSection: .others)
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
    func reloadRow(for item: ListRepresentable) {
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
    
    func highlightCell(for item: ListRepresentable) {
        guard let section = dataSource.snapshot().sectionIdentifier(containingItem: item),
              let index = dataSource.snapshot().indexOfItem(item) else { return }
        let indexPath = IndexPath(row: index, section: section.rawValue)
        DispatchQueue.main.async {
            self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
        }
    }
    
}
