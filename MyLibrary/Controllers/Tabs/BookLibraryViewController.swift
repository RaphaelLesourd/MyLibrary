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
    
    // MARK: - Properties
    private var layoutComposer = LayoutComposer()
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private let activityIndicator = UIActivityIndicatorView()
    private let searchController = UISearchController(searchResultsController: nil)
    private var footerView = LoadingFooterSupplementaryView()
  
    typealias Snapshot = NSDiffableDataSourceSnapshot<BookListSection, Item>
    typealias DataSource = UICollectionViewDiffableDataSource<BookListSection, Item>
    private lazy var dataSource = makeDataSource()
    private var libraryService: LibraryServiceProtocol
    private var snippetsList: [Item] = [] {
        didSet {
            applySnapshot()
        }
    }
    
    // MARK: - Initializer
    init(libraryService: LibraryServiceProtocol) {
        self.libraryService = libraryService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        setCollectionViewConstraints()
        configureSearchController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getLastestBook()
    }
    // MARK: - Setup
    private func configureViewController() {
        view.backgroundColor = .viewControllerBackgroundColor
        title = Text.ControllerTitle.myBooks
    }
    private func configureCollectionView() {
        let layout = layoutComposer.composeBookLibraryLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(cell: VerticalCollectionViewCell.self)
        collectionView.register(footer: LoadingFooterSupplementaryView.self)
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureSearchController() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Recherche"
        searchController.definesPresentationContext = true
        self.navigationItem.hidesSearchBarWhenScrolling = true
        self.navigationItem.searchController = searchController
    }
    
    // MARK: - Api call
    private func getLastestBook() {
        showIndicator(activityIndicator)
        libraryService.getSnippets(limitNumber: 0) { [weak self] result in
            guard let self = self else { return }
            self.hideIndicator(self.activityIndicator)
            switch result {
            case .success(let snippets):
                self.snippetsList = snippets
            case .failure(let error):
                self.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
    
    private func showSelectedBook(_ snippet: Item) {
        showIndicator(activityIndicator)
        libraryService.retrieveBook(snippet) { [weak self] result in
            guard let self = self else { return }
            self.hideIndicator(self.activityIndicator)
            switch result {
            case .success(let book):
                self.showBookDetails(with: book, searchType: .librarySearch)
            case .failure(let error):
                self.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
}

// MARK: - CollectionView Delegate
extension BookLibraryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedBook = dataSource.itemIdentifier(for: indexPath) else { return }
        showSelectedBook(selectedBook)
    }
}

// MARK: - CollectionView Datasource
extension BookLibraryViewController {
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView,
                                    cellProvider: { (collectionView, indexPath, books) -> UICollectionViewCell? in
                let cell: VerticalCollectionViewCell = collectionView.dequeue(for: indexPath)
                cell.configure(with: books)
                return cell
            })
        configureFooter(dataSource)
        return dataSource
    }
    
    /// Adds a footer to the collectionView.
    /// - Parameter dataSource: datasource to add the footer
    private func configureFooter(_ dataSource: BookLibraryViewController.DataSource) {
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            self.footerView = collectionView.dequeue(kind: kind, for: indexPath)
            return self.footerView
        }
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections(BookListSection.allCases)
        snapshot.appendItems(snippetsList, toSection: .mybooks)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

// MARK: - Searchbar delegate
extension BookLibraryViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchController.searchBar.text
        print(searchText ?? "")
        searchController.searchBar.endEditing(true)
    }
}
// MARK: - Constraints
extension BookLibraryViewController {
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
