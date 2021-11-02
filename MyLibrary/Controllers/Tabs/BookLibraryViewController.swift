//
//  SearchResultViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 24/10/2021.
//

import UIKit

enum BookListSection: Int, CaseIterable {
    case mybooks
}

class BookLibraryViewController: UIViewController {
//    
//    // MARK: - Properties
//    private var layoutComposer = LayoutComposer()
//    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
//    private let searchController = UISearchController(searchResultsController: nil)
//  
//    private lazy var dataSource = makeDataSource()
//    typealias Snapshot = NSDiffableDataSourceSnapshot<BookListSection, Item>
//    typealias Datasource = UICollectionViewDiffableDataSource<BookListSection, Item>
//    private var booksList: [Item] = [] {
//        didSet {
//            applySnapshot()
//        }
//    }
//    
//    // MARK: - Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .viewControllerBackgroundColor
//        configureCollectionView()
//        setCollectionViewConstraints()
//        configureSearchController()
//    }
//    
//    // MARK: - Setup
//    private func configureCollectionView() {
//        guar
//        let layout = layoutComposer.createVerticalGridLayout(with: dataSource)
//        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.register(cell: VerticalCollectionViewCell.self)
//        collectionView.register(header: HeaderSupplementaryView.self)
//        collectionView.delegate = self
//        collectionView.dataSource = dataSource
//        collectionView.showsVerticalScrollIndicator = false
//        collectionView.backgroundColor = .clear
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//    }
//    
//    func configureSearchController() {
//        searchController.searchBar.delegate = self
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.placeholder = "Recherche"
//        searchController.definesPresentationContext = true
//        self.navigationItem.hidesSearchBarWhenScrolling = true
//        self.navigationItem.searchController = searchController
//    }
}

//// MARK: - CollectionView Delegate
//extension BookLibraryViewController: UICollectionViewDelegate {
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//    }
//}

//// MARK: - CollectionView Datasource
//extension BookLibraryViewController {
//    private func makeDataSource() -> DataSource {
//        let dataSource = DataSource(
//            collectionView: collectionView,
//            cellProvider: { (collectionView, indexPath, books) -> UICollectionViewCell? in
//                let cell: VerticalCollectionViewCell = collectionView.dequeue(for: indexPath)
//                cell.configure(with: books)
//                return cell
//            })
//        configureHeader(dataSource)
//        return dataSource
//    }
//
//    private func applySnapshot(animatingDifferences: Bool = true) {
//        var snapshot = Snapshot()
//        snapshot.appendSections(BookListSection.allCases)
//        snapshot.appendItems(booksList)
//        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
//    }
//
//    private func configureHeader(_ dataSource: BookLibraryViewController.DataSource) {
//        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
//            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
//            let view: HeaderSupplementaryView = collectionView.dequeue(kind: kind, for: indexPath)
//            view.configureTitle(with: "")
//            view.actionButton.isHidden = true
//            return view
//        }
//    }
//}
//
//// MARK: - Searchbar delegate
//extension BookLibraryViewController: UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let searchText = searchController.searchBar.text
//        print(searchText ?? "")
//        searchController.searchBar.endEditing(true)
//    }
//}
//// MARK: - Constraints
//extension BookLibraryViewController {
//    private func setCollectionViewConstraints() {
//        view.addSubview(collectionView)
//        NSLayoutConstraint.activate([
//            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
//            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
//        ])
//    }
//}
