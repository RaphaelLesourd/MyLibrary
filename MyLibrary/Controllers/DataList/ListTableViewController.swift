//
//  ListTableViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 22/01/2022.
//

import UIKit

class ListTableViewController: UITableViewController {
    
    // MARK: - Properties
    weak var newBookDelegate: NewBookViewControllerDelegate?
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let presenter: ListPresenter
    private var sectionTitle = String()
    
    // MARK: - Initializer
    init(selectedData: String?,
         newBookDelegate: NewBookViewControllerDelegate?,
         presenter: ListPresenter) {
        self.newBookDelegate = newBookDelegate
        self.presenter = presenter
        self.presenter.receivedData = selectedData
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
        presenter.view = self
        presenter.getControllerTitle()
        presenter.getSectionTitle()
        presenter.getFavoriteList()
        presenter.getData()
    }
    
    // MARK: - Setup
    private func configureTableView() {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        tableView.allowsSelection = true
        tableView.showsVerticalScrollIndicator = true
        tableView.backgroundColor = .viewControllerBackgroundColor
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
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return Text.SectionTitle.listFooter
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = presenter.data[indexPath.row]
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.appTintColor.withAlphaComponent(0.3)
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "reuseIdentifier")
        cell.selectedBackgroundView = backgroundView
        cell.backgroundColor = .tertiarySystemBackground
        cell.textLabel?.text = data.title.capitalized
        
        cell.detailTextLabel?.text = data.subtitle.uppercased()
        cell.detailTextLabel?.textColor = .appTintColor
        
        cell.imageView?.image = Images.ButtonIcon.favorite
        cell.imageView?.tintColor = data.favorite ? .favoriteColor : UIColor.favoriteColor.withAlphaComponent(0.1)
        return cell
    }
    
    // MARK: - Table view delegate
    // Context menu
    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favorite = self.contextMenuAction(forRowAtIndexPath: indexPath)
        return UISwipeActionsConfiguration(actions: [favorite])
    }
    
    private func contextMenuAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        let data = presenter.data[indexPath.row]
        let action = UIContextualAction(style: .normal, title: nil) { [weak self] (_, _, completion) in
            data.favorite ? self?.presenter.removeFavorite(at: indexPath.row) : self?.presenter.addToFavorite(for: indexPath.row)
            completion(true)
        }
        action.backgroundColor = .favoriteColor
        action.image = data.favorite ? Images.ButtonIcon.favoriteNot : Images.ButtonIcon.favorite
        return action
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.getSelectedData(at: indexPath.row)
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
    
    func setLanguage(with code: String) {
        newBookDelegate?.setLanguage(with: code)
    }
    
    func setCurrency(with code: String) {
        newBookDelegate?.setCurrency(with: code)
    }
    
    func setSectionTitle(as title: String) {
        sectionTitle = title
    }
    
    func setTitle(as title: String) {
        self.title = title
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.presenter.highlightCell()
        }
    }
    
    func reloadTableViewRow(at indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [indexPath], with: .left)
            self.presenter.highlightCell()
        }
    }
    
    func highlightCell(at indexPath: IndexPath) {
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
    }
}
