//
//  HomeViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit

/// Enum giving name to each section of the HomeController CollectionView for better readability
enum HomeCollectionViewSections: Int, CaseIterable {
    case categories
    case newEntry
    case favorites
    case recommanding
}

class HomeViewController: UIViewController {

    // MARK: - Properties
    typealias DataSource = UICollectionViewDiffableDataSource<HomeCollectionViewSections, BookSnippet>
    typealias Snapshot = NSDiffableDataSourceSnapshot<HomeCollectionViewSections, BookSnippet>
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private let activityIndicator = UIActivityIndicatorView()
    private let refresherControl = UIRefreshControl()
    private lazy var dataSource = makeDataSource()
    private var layoutComposer = LayoutComposer()
    private var libraryService: LibraryServiceProtocol
    private var latestBooks: [BookSnippet] = []
    private var favoriteBooks: [BookSnippet] = []
    private var recommandedBooks: [BookSnippet] = []
    private var categories: [BookSnippet] = []
    
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
        configureRefresherControl()
        configureCollectionView()
        applySnapshot(animatingDifferences: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getLastestBookSnippet()
    }
    
    // MARK: - Setup
    private func configureViewController() {
        view.backgroundColor = .viewControllerBackgroundColor
        title = Text.ControllerTitle.home
    }
    
    private func configureCollectionView() {
        let layout = layoutComposer.composeHomeCollectionViewLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(cell: CategoryCollectionViewCell.self)
        collectionView.register(cell: VerticalCollectionViewCell.self)
        collectionView.register(cell: HorizontalCollectionViewCell.self)
        collectionView.register(header: HeaderSupplementaryView.self)
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.frame = view.frame
        view.addSubview(collectionView)
    }
    
    private func configureRefresherControl() {
        refresherControl.tintColor = .label
        collectionView.refreshControl = refresherControl
        refresherControl.addTarget(self, action: #selector(refreshBookList), for: .valueChanged)
    }
    
    // MARK: - Api call
    private func getLastestBookSnippet() {
        showIndicator(activityIndicator)
        libraryService.getSnippets(limitNumber: 10, favoriteBooks: false) { [weak self] result in
            guard let self = self else { return }
            self.hideIndicator(self.activityIndicator)
            switch result {
            case .success(let snippets):
                self.latestBooks = snippets
                self.applySnapshot()
            case .failure(let error):
                self.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
        libraryService.getSnippets(limitNumber: 10, favoriteBooks: true) { [weak self] result in
            guard let self = self else { return }
            self.hideIndicator(self.activityIndicator)
            switch result {
            case .success(let snippets):
                self.favoriteBooks = snippets
                self.applySnapshot()
            case .failure(let error):
                self.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
    
    private func showSelectedBook(for id: String) {
       showIndicator(activityIndicator)
        libraryService.retrieveBook(for: id) { [weak self] result in
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
    
    // MARK: - Targets
    @objc private func refreshBookList() {
        getLastestBookSnippet()
    }
}
// MARK: - DataSource
extension HomeViewController {
    /// Create diffable Datasource for the collectionView.
    /// - configure the cell and in this case the footer.
    /// - Returns: UICollectionViewDiffableDataSource
    private func makeDataSource() -> DataSource {
           let dataSource = DataSource(collectionView: collectionView,
                                       cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            switch HomeCollectionViewSections(rawValue: indexPath.section) {
            case .categories:
                let cell: CategoryCollectionViewCell = collectionView.dequeue(for: indexPath)
                cell.configure(text: "")
                return cell
            case .newEntry, .recommanding:
                let cell: VerticalCollectionViewCell = collectionView.dequeue(for: indexPath)
                cell.configure(with: item)
                return cell
            case .favorites:
                let cell: HorizontalCollectionViewCell = collectionView.dequeue(for: indexPath)
                cell.configure(with: item)
                return cell
            case .none:
                return nil
            }
        })
        configureHeader(dataSource)
        return dataSource
    }
    /// Adds a header to the collectionView.
    /// - Parameter dataSource: datasource to add the footer
    private func configureHeader(_ dataSource: HomeViewController.DataSource) {
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            var headerTitle = ""
            let headerView = collectionView.dequeue(kind: kind, for: indexPath) as HeaderSupplementaryView
            switch HomeCollectionViewSections(rawValue: indexPath.section) {
            case .categories:
                headerTitle = "Catégories"
            case .newEntry:
                headerTitle = "Derniers ajouts"
            case .recommanding:
                headerTitle = "Recommandations"
            case .favorites:
                headerTitle = "Favoris"
            case .none:
                return nil
            }
            headerView.configureTitle(with: headerTitle)
            return headerView
        }
    }
    /// Set the data to th section of the collectionView, in this case only one section (main)
    /// - Parameter animatingDifferences: Animate the collectionView with the changes applied.
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections(HomeCollectionViewSections.allCases)
     //   snapshot.appendItems(latestBooks, toSection: .categories)
      //  snapshot.appendItems(latestBooks, toSection: .recommanding)
        snapshot.appendItems(favoriteBooks, toSection: .favorites)
        snapshot.appendItems(latestBooks, toSection: .newEntry)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
// MARK: - CollectionView Delegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedBookId = dataSource.itemIdentifier(for: indexPath)?.etag else { return }
        showSelectedBook(for: selectedBookId)
    }
}
