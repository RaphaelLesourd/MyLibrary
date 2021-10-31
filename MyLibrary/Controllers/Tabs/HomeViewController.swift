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
      //  addSearchButton()
    }
    
    // MARK: - Setup
    private func configureCollectionView() {
        let layout = layoutComposer.composeHomeCollectionViewLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(cell: CategoryCollectionViewCell.self)
        collectionView.register(cell: VerticalCollectionViewCell.self)
        collectionView.register(cell: HorizontalCollectionViewCell.self)
        collectionView.register(header: HeaderSupplementaryView.self)
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
            let cell: CategoryCollectionViewCell = collectionView.dequeue(for: indexPath)
            let category = defaultCategories[indexPath.item]
            cell.configure(text: category)
            return cell
        case .newEntry:
            let cell: VerticalCollectionViewCell = collectionView.dequeue(for: indexPath)
         //   cell.configure()
            return cell
        case .favorites:
            let cell: HorizontalCollectionViewCell = collectionView.dequeue(for: indexPath)
           // cell.configure()
            return cell
        case .recommanding:
            let cell: VerticalCollectionViewCell = collectionView.dequeue(for: indexPath)
         //   cell.configure()
            return cell
        case nil:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView: HeaderSupplementaryView = collectionView.dequeue(kind: kind, for: indexPath)
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
     //   headerView.actionButton.addTarget(self, action: #selector(showLibrary), for: .touchUpInside)
        return headerView
    }
}
// MARK: - CollectionView Delegate
extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
    }
}
// MARK: - Constraints
extension HomeViewController {
    private func setCollectionViewConstraints() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
}
