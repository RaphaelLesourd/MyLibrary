//
//  CommentControllerView.swift
//  MyLibrary
//
//  Created by Birkyboy on 03/12/2021.
//

import UIKit
import InputBarAccessoryView

class CommentControllerView: UIView {
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureEmptyStateView()
        configureTableView()
        configureInputBar()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    let activityIndicator = UIActivityIndicatorView()
    let refresherControl = UIRefreshControl()
    let inputBar = InputBarAccessoryView()
    let emptyStateView = EmptyStateView()
    
    // MARK: - Configure
    private func configureInputBar() {
        inputBar.inputTextView.isImagePasteEnabled = false
        inputBar.isTranslucent = true
        inputBar.backgroundView.backgroundColor = .tertiarySystemBackground
        inputBar.translatesAutoresizingMaskIntoConstraints = false
        
        let inputTextView = inputBar.inputTextView
        inputTextView.layer.cornerRadius = 14.0
        inputTextView.layer.borderWidth = 0.0
        inputTextView.backgroundColor = .secondarySystemGroupedBackground
        inputTextView.font = UIFont.systemFont(ofSize: 18.0)
        inputTextView.placeholderLabel.text = "Ce que vous en pensez..."
        inputTextView.textContainerInset = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 6, left: 18, bottom: 6, right: 15)
        
        let sendButton = inputBar.sendButton
        sendButton.image = UIImage(systemName: "paperplane.fill")
        sendButton.tintColor = .label
        sendButton.title = nil
        sendButton.setSize(CGSize(width: 30, height: 30), animated: true)
    }
    
    private func configureTableView() {
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.reuseIdentifier)
        tableView.register(CommentsBookCell.self, forCellReuseIdentifier: CommentsBookCell.reuseIdentifier)
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.alwaysBounceVertical = true
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false
        tableView.refreshControl = refresherControl
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureEmptyStateView() {
        emptyStateView.titleLabel.text = "Soyez le premier à écrire un comentaire sur ce livre..."
        emptyStateView.isHidden = true
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
    }
}
// MARK: - Constraints
extension CommentControllerView {
    private func setConstraints() {
        addSubview(tableView)
        addSubview(emptyStateView)
        addSubview(inputBar)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            emptyStateView.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo:centerYAnchor),
            emptyStateView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
}