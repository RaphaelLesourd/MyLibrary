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
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .viewControllerBackgroundColor
        configureCollectionView()
        setCollectionViewConstraints()
        configureSearchController()
    }
    
    // MARK: - Setup
    private func configureCollectionView() {
        let layout = layoutComposer.composeHomeCollectionViewLayout()
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
    // All setup functions below are set when the recipeListType is set to favorite.
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search"
        searchController.automaticallyShowsSearchResultsController = true
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
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
            cell.configure()
            return cell
        case .newEntry:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCollectionViewCell.reuseIdentifier,
                                                                for: indexPath) as? VerticalCollectionViewCell  else { return UICollectionViewCell() }
            cell.configure()
            return cell
        case .lastRead:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalCollectionViewCell.reuseIdentifier,
                                                          for: indexPath) as? HorizontalCollectionViewCell  else { return UICollectionViewCell() }
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
        case .newEntry:
            headerView.configureTitle(with: "Last read")
        case .lastRead:
            headerView.configureTitle(with: "Last addition")
        case .none, .reading:
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
// MARK: - Search result updater
extension HomeViewController: UISearchResultsUpdating {
    
    /// Upadate the tableView according to the text entered in the UISearchControler textField
    /// - Parameter searchController: Pass in the search controller used.
   func updateSearchResults(for searchController: UISearchController) {
      //  guard let searchText = searchController.searchBar.text else {return}
       
    }
    
    /// Filter the recipe searched
    /// - Parameter searchText: Pass in the text used to filter recipes.
    private func filterSearchedRecipes(for searchText: String) {
        if searchText.isEmpty {
            
        } else {
    
        }
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
