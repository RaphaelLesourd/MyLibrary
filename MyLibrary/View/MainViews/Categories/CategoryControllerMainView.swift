//
//  ListTableView.swift
//  MyLibrary
//
//  Created by Birkyboy on 28/10/2021.
//

import UIKit

class CategoryControllerMainView: UIView {

    // MARK: - Initialiser
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setTableViewConstraints()
        setEmptyStateViewConstraints()
        configure()
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
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let refresherControl = UIRefreshControl()
    let emptyStateView = EmptyStateView()
    
    // MARK: - Configure
    private func configure() {
        emptyStateView.configure(title: Text.EmptyState.categoryTitle,
                                 subtitle: Text.EmptyState.categorySubtitle,
                                 icon: Images.ButtonIcon.selectedCategoryBadge)
    }
}

// MARK: - Constraints
extension CategoryControllerMainView {
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
        let offSetX: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 40 : 0
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyStateView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: offSetX),
            emptyStateView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -50)
        ])
    }
}
