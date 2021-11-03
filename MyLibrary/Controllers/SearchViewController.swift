//
//  SettingsViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit

class SearchViewController: UIViewController {
    
    enum ApiSearchSection: Hashable {
        case main
    }
    
    // MARK: - Properties
    typealias Snapshot = NSDiffableDataSourceSnapshot<ApiSearchSection, Item>
    typealias DataSource = UICollectionViewDiffableDataSource<ApiSearchSection, Item>
    private lazy var dataSource = makeDataSource()
    private var layoutComposer = LayoutComposer()
    private let refresherControl = UIRefreshControl()
    private var noMoreBooks: Bool?
    weak var newBookDelegate: NewBookDelegate?
    private var networkService: NetworkProtocol
    var searchType: SearchType?
    var currentSearchKeywords = "" {
        didSet {
            noMoreBooks = false
            getBooks()
        }
    }
    var searchedBooks: [Item] = [] {
        didSet {
            applySnapshot()
        }
    }
    
    // MARK: - Subviews
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    // MARK: - Initializer
    /// Demands a netWorks service to fetch data.
    /// - Parameter networkService: NetworkProtocol
    init(networkService: NetworkProtocol) {
        self.networkService = networkService
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
        configureRefresherControl()
        applySnapshot(animatingDifferences: false)
    }
    
    // MARK: - Setup
    private func configureViewController() {
        view.backgroundColor = .viewControllerBackgroundColor
        title = Text.ControllerTitle.search
    }
    /// Set up the collectionView with diffable datasource and compositional layout.
    /// Layouts are contrustructed in the Layoutcomposer class.
    /// Cell and footer resistrations are shortenend by helper extensions created in the
    /// UICollectionView+Extension file.
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
    
    private func configureRefresherControl() {
        refresherControl.attributedTitle = NSAttributedString(string: "Rechargement")
        refresherControl.tintColor = .label
        collectionView.refreshControl = refresherControl
        refresherControl.addTarget(self, action: #selector(refreshBookList), for: .valueChanged)
    }
    
    // MARK: - API call
    /// Api call to get book or list of books.
    /// - Parameters:
    ///   - query: String passing search keywords, could be title, author or isbn
    ///   - fromIndex: Define the starting point of the book to fetxh, used for pagination.
    private func getBooks(fromIndex: Int = 0) {
        networkService.getData(with: currentSearchKeywords, fromIndex: fromIndex) { [weak self] result in
            guard let self = self else { return }
            self.refresherControl.endRefreshing()
            switch result {
            case .success(let books):
                self.handleList(for: books)
            case .failure(let error):
                self.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
    /// Verifies the type of search and redirects the result.
    ///  - searchType:
    ///  - .apiCall: Display the list in the collectionView
    ///  - .barCodeSearch: send the first result back to newBookController
    /// - Parameter books: List of books fetch from API
    private func handleList(for books: [Item]) {
        searchType == .apiSearch ? searchedBooks.append(contentsOf: books) : (newBookDelegate?.newBook = books.first)
    }
    
    @objc private func refreshBookList() {
        searchedBooks.removeAll()
        getBooks()
    }
}
// MARK: - CollectionView Datasource
extension SearchViewController {
    /// Create diffable Datasource for the collectionView.
    /// - configure the cell and in this case the footer.
    /// - Returns: UICollectionViewDiffableDataSource
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
    
    /// Set the data to th section of the collectionView, in this case only one section (main)
    /// - Parameter animatingDifferences: Animate the collectionView with the changes applied.
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(searchedBooks, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    /// Adds a footer to the collectionView.
    /// - Parameter dataSource: datasource to add the footer
    private func configureFooter(_ dataSource: SearchViewController.DataSource) {
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            let view: LoadingFooterSupplementaryView = collectionView.dequeue(kind: kind, for: indexPath)
            return view
        }
    }
}
// MARK: - CollectionView Delegate
extension SearchViewController: UICollectionViewDelegate {
    
    /// Keeps track whe the last cell is displayed. User to load more data.
    /// In this case when the last 3 cells are displayed and the last book hasn't been reached, more data are fetched.
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let currentRow = collectionView.numberOfItems(inSection: indexPath.section) - 3
        if indexPath.row == currentRow && noMoreBooks == false {
            getBooks(fromIndex: searchedBooks.count + 1)
        }
    }
    /// Verifies if the footer is being displayed at the end of the collection view.
    /// if the footer is displayed, the list of searchedBooks is not empty and there are books to fetch,
    /// the activityIndicator within the footer is animated.
    func collectionView(_ collectionView: UICollectionView,
                        willDisplaySupplementaryView view: UICollectionReusableView,
                        forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            if let loadingView = view as? LoadingFooterSupplementaryView {
                let activityIndicatorVisible = !searchedBooks.isEmpty && noMoreBooks == false
                loadingView.displayActivityIndicator(activityIndicatorVisible)
            }
        }
    }
    /// Verified if the footer ended being displayed, If so the activityIndicator within the footer
    /// stop being nimated and is hidden.
    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplayingSupplementaryView view: UICollectionReusableView,
                        forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            if let loadingView = view as? LoadingFooterSupplementaryView {
                loadingView.displayActivityIndicator(false)
            }
        }
    }
    /// When a cell is selected, the selected book is passed back to the newBookViewController
    /// via delgate patern protocol.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let searchBook = dataSource.itemIdentifier(for: indexPath) else { return }
        newBookDelegate?.newBook = searchBook
    }
}
// MARK: - Constraints
extension SearchViewController {
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
