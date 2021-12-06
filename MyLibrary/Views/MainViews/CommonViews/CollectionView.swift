//
//  HomeControllerView.swift
//  MyLibrary
//
//  Created by Birkyboy on 13/11/2021.
//

import Foundation
import UIKit

class CollectionView: UIView {
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureCollectionView()
        setCollectionViewConstraints()
        setEmptyStateViewConstraints()
        emptyStateView.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews
    var collectionView    = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let activityIndicator = UIActivityIndicatorView()
    let refresherControl  = UIRefreshControl()
    let emptyStateView    = EmptyStateView()
    
    private func configureCollectionView() {
        refresherControl.attributedTitle            = NSAttributedString(string: "Rechargement")
        refresherControl.tintColor                  = .label
        collectionView.refreshControl               = refresherControl
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor              = .clear
        collectionView.contentInset                 = UIEdgeInsets(top: 30, left: 0, bottom: 50, right: 0)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
}
// MARK: - Constraints
extension CollectionView {
    private func setEmptyStateViewConstraints() {
        addSubview(emptyStateView)
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyStateView.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo:centerYAnchor, constant: -50),
            emptyStateView.widthAnchor.constraint(equalToConstant: 200)
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
