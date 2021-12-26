//
//  HomeControllerView.swift
//  MyLibrary
//
//  Created by Birkyboy on 13/11/2021.
//

import UIKit

/// Provide  Common Collectionview to other UIViewcontroller that can inherit from this class.
class CollectionViewController: UIViewController {
    
    // MARK: - Properties
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let activityIndicator = UIActivityIndicatorView()
    let refresherControl = UIRefreshControl()
    let emptyStateView = EmptyStateView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .viewControllerBackgroundColor
        configureCollectionView()
        setCollectionViewConstraints()
        setEmptyStateViewConstraints()
        addNavigationBarButtons()
        emptyStateView.isHidden = true
    }
    
    // MARK: - Navgation
    func showBookDetails(for book: Item, searchType: SearchType?) {
        
        let bookCardVC = BookCardViewController(book: book,
                                                libraryService: LibraryService(),
                                                recommendationService: RecommandationService())
        bookCardVC.hidesBottomBarWhenPushed = true
        bookCardVC.searchType = searchType
        navigationController?.show(bookCardVC, sender: nil)
    }
    
  // MARK: - Setup
    private func configureCollectionView() {
        collectionView.register(footer: LoadingFooterSupplementaryView.self)
        refresherControl.attributedTitle = NSAttributedString(string: Text.Misc.reloading)
        refresherControl.tintColor = .label
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.refreshControl = refresherControl
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 50, right: 0)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addNavigationBarButtons() {
        let activityIndicactorButton = UIBarButtonItem(customView: activityIndicator)
        navigationItem.rightBarButtonItems = [activityIndicactorButton]
    }
}
// MARK: - Constraints
extension CollectionViewController {
    private func setEmptyStateViewConstraints() {
        view.addSubview(emptyStateView)
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            emptyStateView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func setCollectionViewConstraints() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
