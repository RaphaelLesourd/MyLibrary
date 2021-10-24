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
    let defaultCategories: [String] = ["Fantasy", "Roman", "Fiction", "Bd", "Historique"].sorted()
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
        let layout = layoutComposer.composeHomeCollectionViewLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CategoryCollectionViewCell.self,
                                         forCellWithReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier)
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

    // MARK: - Navigation
    private func showBookDetails() {
        let bookCardVC = BookCardViewController()
        navigationController?.pushViewController(bookCardVC, animated: true)
    }
    
    @objc private func showLibrary() {
        let libraryVC = BookLibraryViewController()
        navigationController?.pushViewController(libraryVC, animated: true)
    }
}
// MARK: - CollectionView Datasource
extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return HomeCollectionViewSections.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch HomeCollectionViewSections(rawValue: section) {
        case .categories:
            return defaultCategories.count
        case .newEntry:
            return 10
        case .favorites:
            return 30
        case .recommanding:
           return 5
        case nil:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch HomeCollectionViewSections(rawValue: indexPath.section) {
        case .categories:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier,
                                                                for: indexPath) as? CategoryCollectionViewCell  else {
                return UICollectionViewCell() }
            let category = defaultCategories[indexPath.item]
            cell.configure(text: category)
            return cell
        case .newEntry:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCollectionViewCell.reuseIdentifier,
                                                                for: indexPath) as? VerticalCollectionViewCell  else {
                return UICollectionViewCell() }
            cell.configure()
            return cell
        case .favorites:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalCollectionViewCell.reuseIdentifier,
                                                          for: indexPath) as? HorizontalCollectionViewCell  else {
                return UICollectionViewCell() }
            cell.configure()
            return cell
        case .recommanding:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCollectionViewCell.reuseIdentifier,
                                                                for: indexPath) as? VerticalCollectionViewCell  else {
                return UICollectionViewCell() }
            cell.configure()
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
        case .categories:
            headerView.configureTitle(with: "Catégories")
        case .newEntry:
            headerView.configureTitle(with: "Mes derniers ajouts")
        case .favorites:
            headerView.configureTitle(with: "Mes favoris")
        case .recommanding:
            headerView.configureTitle(with: "Recommandations")
        case .none:
            break
        }
        headerView.actionButton.addTarget(self, action: #selector(showLibrary), for: .touchUpInside)
        return headerView
    }
}
// MARK: - CollectionView Delegate
extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      showBookDetails()
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
