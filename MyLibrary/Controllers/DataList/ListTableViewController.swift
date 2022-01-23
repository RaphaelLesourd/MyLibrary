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
        self.presenter.selectedData = selectedData
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = presenter.data[indexPath.row]
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.appTintColor.withAlphaComponent(0.5)
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "reuseIdentifier")
        cell.selectedBackgroundView = backgroundView
        cell.backgroundColor = .tertiarySystemBackground
        cell.textLabel?.text = data.title.capitalized
        cell.detailTextLabel?.text = data.subtitle.uppercased()
        cell.detailTextLabel?.textColor = .appTintColor
        return cell
    }
    
    // MARK: - Table view delegate
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
    
    func highlightCell(at indexPath: IndexPath) {
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
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
}
