//
//  ListTableView.swift
//  MyLibrary
//
//  Created by Birkyboy on 28/10/2021.
//

import UIKit

class ListMainView: UIView {

    // MARK: - Initialiser
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setTableViewConstraints()
        setEmptyStateViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 50, right: 0)
        tableView.backgroundColor = .clear
        tableView.allowsMultipleSelection = true
        tableView.showsVerticalScrollIndicator = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.sectionHeaderHeight = 30
        tableView.sectionFooterHeight = 50
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let refresherControl = UIRefreshControl()
    let activityIndicator = UIActivityIndicatorView()
    let emptyStateView = EmptyStateView()
    var searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Configure
    func configure(with title: String, subtitle: String, icon: UIImage, hideButton: Bool) {
        emptyStateView.configure(title: title,
                                 subtitle: subtitle,
                                 icon: icon,
                                 hideButton: hideButton)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Text.Placeholder.search
        searchController.automaticallyShowsSearchResultsController = false
        searchController.hidesNavigationBarDuringPresentation = false
    }
}

// MARK: - Constraints
extension ListMainView {
    private func setTableViewConstraints() {
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setEmptyStateViewConstraints() {
        addSubview(emptyStateView)
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyStateView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            emptyStateView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 100)
        ])
    }
}
