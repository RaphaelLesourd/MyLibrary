//
//  HomeViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - Properties
    private var layoutComposer = LayoutComposer()
    
    // MARK: - Subviews
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .viewControllerBackgroundColor
        configureCollectionView()
        setCollectionViewConstraints()
    }
    
    // MARK: - Setup
    private func configureCollectionView() {
        let layout = layoutComposer.composeCollectionViewLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(VerticalCollectionViewCell.self,
                                         forCellWithReuseIdentifier: VerticalCollectionViewCell.reuseIdentifier)
        collectionView.register(HorizontalCollectionViewCell.self,
                                         forCellWithReuseIdentifier: HorizontalCollectionViewCell.reuseIdentifier)
        collectionView.register(HeaderSupplementaryView.self,
                                         forSupplementaryViewOfKind: HeaderSupplementaryView.kind,
                                         withReuseIdentifier: HeaderSupplementaryView.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
}
// MARK: - CollectionView Datasource
extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return HomeCollectionViewSections.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch HomeCollectionViewSections(rawValue: section) {
        case .reading:
           return 1
        case .newEntry:
            return 10
        case .lastRead:
            return 30
        case nil:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch HomeCollectionViewSections(rawValue: indexPath.section) {
        case .reading:
           guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCollectionViewCell.reuseIdentifier,
                                                               for: indexPath) as? VerticalCollectionViewCell else { return UICollectionViewCell() }
            
            return cell
        case .newEntry:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCollectionViewCell.reuseIdentifier,
                                                                for: indexPath) as? VerticalCollectionViewCell  else { return UICollectionViewCell() }
            
            return cell
        case .lastRead:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalCollectionViewCell.reuseIdentifier,
                                                          for: indexPath) as? HorizontalCollectionViewCell  else { return UICollectionViewCell() }
            return cell
        case nil:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                               withReuseIdentifier: HeaderSupplementaryView.reuseIdentifier,
                                                                               for: indexPath) as? HeaderSupplementaryView else {
            return HeaderSupplementaryView()
        }
        switch HomeCollectionViewSections(rawValue: indexPath.section) {
        case .newEntry:
            headerView.configureTitle(with: "Last read")
        case .lastRead:
            headerView.configureTitle(with: "Last addition")
        case .none, .reading:
            break
        }
        return headerView
    }
}
// MARK: - CollectionView Delegate
extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bookCardVC = BookCardViewController()
        navigationController?.pushViewController(bookCardVC, animated: true)
    }
}
// MARK: - Constraints
extension HomeViewController {
    
    private func setCollectionViewConstraints() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
}
