//
//  SettingsViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - Properties
    typealias Snapshot   = NSDiffableDataSourceSnapshot<SingleSection, Item>
    typealias DataSource = UICollectionViewDiffableDataSource<SingleSection, Item>
    private lazy var dataSource = makeDataSource()

    private let mainView       = CollectionView()
    private var footerView     = LoadingFooterSupplementaryView()
    private var layoutComposer : LayoutComposer
    private var networkService : ApiManagerProtocol
    private var noMoreBooks    : Bool?
    
    weak var newBookDelegate: NewBookDelegate?
    
    var searchType: SearchType?
    var searchedBooks: [Item] = [] 
    var currentSearchKeywords = "" {
        didSet {
            searchedBooks.removeAll()
            noMoreBooks = false
            getBooks()
        }
    }
   
    // MARK: - Initializer
    /// Demands a netWorks service to fetch data.
    /// - Parameter networkService: NetworkProtocol
    init(networkService: ApiManagerProtocol, layoutComposer: LayoutComposer) {
        self.networkService = networkService
        self.layoutComposer = layoutComposer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
        view.backgroundColor = .viewControllerBackgroundColor
        title = Text.ControllerTitle.search
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureRefresherControl()
        applySnapshot(animatingDifferences: false)
    }
    
    // MARK: - Setup
    /// Set up the collectionView with diffable datasource and compositional layout.
    /// Layouts are contrustructed in the Layoutcomposer class.
    /// Cell and footer resistrations are shortenend by helper extensions created in the
    /// UICollectionView+Extension file.
    private func configureCollectionView() {
        let layout = layoutComposer.setCollectionViewLayout()
        mainView.collectionView.collectionViewLayout = layout
        mainView.collectionView.register(cell: VerticalCollectionViewCell.self)
        mainView.collectionView.register(footer: LoadingFooterSupplementaryView.self)
        mainView.collectionView.delegate   = self
        mainView.collectionView.dataSource = dataSource
    }
    
    private func configureRefresherControl() {
        mainView.refresherControl.addTarget(self, action: #selector(refreshBookList), for: .valueChanged)
    }
    
    // MARK: - API call
    /// Api call to get book or list of books.
    /// - Parameters:
    ///   - query: String passing search keywords, could be title, author or isbn
    ///   - fromIndex: Define the starting point of the book to fetxh, used for pagination.
    private func getBooks(fromIndex: Int = 0) {
        footerView.displayActivityIndicator(true)
        
        networkService.getData(with: currentSearchKeywords, fromIndex: fromIndex) { [weak self] result in
            guard let self = self else { return }
            self.mainView.refresherControl.endRefreshing()
            self.footerView.displayActivityIndicator(false)
            
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
        switch searchType {
        case .apiSearch:
            books.isEmpty ? noMoreBooks = true : addBooks(books)
        case .barCodeSearch:
            newBookDelegate?.newBook = books.first
        case .librarySearch:
            return
        case .none:
            return
        }
    }
    
    private func addBooks(_ books: [Item]) {
        books.forEach { book in
            if !self.searchedBooks.contains(where: { $0.volumeInfo?.title == book.volumeInfo?.title }) {
                self.searchedBooks.append(book)
                self.applySnapshot()
            }
        }
    }
    
    @objc private func refreshBookList() {
        searchedBooks.removeAll()
        noMoreBooks = false
        getBooks()
    }
}
// MARK: - CollectionView Datasource
extension SearchViewController {
    /// Create diffable Datasource for the collectionView.
    /// - configure the cell and in this case the footer.
    /// - Returns: UICollectionViewDiffableDataSource
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: mainView.collectionView,
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
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            self?.footerView = collectionView.dequeue(kind: kind, for: indexPath)
            return self?.footerView
        }
    }
}
// MARK: - CollectionView Delegate
extension SearchViewController: UICollectionViewDelegate {
    /// Keeps track whe the last cell is displayed. User to load more data.
    /// In this case when the last 3 cells are displayed and the last book hasn't been reached, more data are fetched.
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        let currentRow = collectionView.numberOfItems(inSection: indexPath.section) - 3
        if indexPath.row == currentRow && noMoreBooks == false {
            getBooks(fromIndex: searchedBooks.count + 1)
        }
    }
    /// When a cell is selected, the selected book is passed back to the newBookViewController
    /// via delgate patern protocol.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let searchBook = dataSource.itemIdentifier(for: indexPath) else { return }
        newBookDelegate?.newBook = searchBook
    }
}
