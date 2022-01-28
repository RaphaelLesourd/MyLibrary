//
//  BookListView.swift
//  MyLibrary
//
//  Created by Birkyboy on 13/11/2021.
//

import UIKit

/// Provide  Common Collectionview to other UIViewcontroller that can inherit from this class.
class BookListView: UIView {
    
    weak var delegate: BookListViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureCollectionView()
        addButtonsAction()
        setCollectionViewConstraints()
        setEmptyStateViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews
    let activityIndicator = UIActivityIndicatorView()
    let emptyStateView = EmptyStateView()
    var headerView = HeaderSupplementaryView()
    var footerView = LoadingFooterSupplementaryView()
    
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.register(cell: CategoryCollectionViewCell.self)
        collectionView.register(cell: UserCollectionViewCell.self)
        collectionView.register(cell: BookCollectionViewCell.self)
        collectionView.register(cell: DetailedBookCollectionViewCell.self)
        collectionView.register(header: HeaderSupplementaryView.self)
        collectionView.register(footer: LoadingFooterSupplementaryView.self)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 50, right: 0)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let refresherControl: UIRefreshControl = {
        let refresherControl = UIRefreshControl()
        refresherControl.attributedTitle = NSAttributedString(string: Text.Misc.reloading)
        refresherControl.tintColor = .label
        return refresherControl
    }()
    
    // MARK: - Configure
    private func configureCollectionView() {
        collectionView.refreshControl = refresherControl
    }
    
    private func configureEmptystateView(with title: String,
                                         subtitle: String,
                                         icon: UIImage,
                                         hideButton: Bool) {
        emptyStateView.isHidden = true
        emptyStateView.configure(title: title,
                                 subtitle: subtitle,
                                 icon: icon,
                                 hideButton: hideButton)
    }
    
    private func addButtonsAction() {
        refresherControl.addAction(UIAction(handler: { [weak self] _ in
            self?.delegate?.refreshBookList()
        }), for: .valueChanged)
    }
}
// MARK: - Constraints
extension BookListView {
    private func setEmptyStateViewConstraints() {
        addSubview(emptyStateView)
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyStateView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor, constant: -50)
        ])
    }
    
    private func setCollectionViewConstraints() {
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
