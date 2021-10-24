//
//  SettingsViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit

class SearchViewController: UIViewController {

    // MARK: - Properties
      private let searchController = UISearchController(searchResultsController: nil)
       
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .viewControllerBackgroundColor
        configureSearchController()
        addScannerButton()
    }

    // MARK: - Setup
    func configureSearchController() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Recherche"
        searchController.definesPresentationContext = true
        searchController.automaticallyShowsSearchResultsController = true
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
    }
}
// MARK: - Search result updater
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
           return
        }
        searchController.searchBar.text = nil
        searchController.isActive = false
    }
}
