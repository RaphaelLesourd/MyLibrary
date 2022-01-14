//
//  SettingsViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit

class SearchViewController: CollectionViewController {
    
    // MARK: - Properties
    typealias Snapshot = NSDiffableDataSourceSnapshot<SingleSection, Item>
    typealias DataSource = UICollectionViewDiffableDataSource<SingleSection, Item>
   
    weak var newBookDelegate: NewBookDelegate?
    var searchType: SearchType?
    var searchedBooks: [Item] = []
    var currentSearchKeywords = "" {
        didSet {
            refreshBookList()
        }
    }
   
    private let layoutComposer: BookListLayoutComposer
    private let apiManager: ApiManagerProtocol
    private lazy var dataSource = createDataSource()
    private var headerView = HeaderSupplementaryView()
    private var footerView = LoadingFooterSupplementaryView()
    private var cellPresenter: CellPresenter?
    private var noMoreBooks: Bool?
    
    // MARK: - Initializer
    init(apiManager: ApiManagerProtocol,
         layoutComposer: BookListLayoutComposer) {
        self.apiManager = apiManager
        self.layoutComposer = layoutComposer
        self.cellPresenter = BookCellPresenter(imageRetriever: KFImageRetriever())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureCollectionView()
        configureRefresherControl()
        applySnapshot(animatingDifferences: false)
    }
    
    // MARK: - Setup
    private func configureUI() {
        title = Text.ControllerTitle.search
        emptyStateView.configure(title: Text.EmptyState.searchTitle,
                                 subtitle: Text.EmptyState.searchSubtitle,
                                 icon: Images.ButtonIcon.search,
                                 hideButton: true)
    }
    /// Set up the collectionView with diffable datasource and compositional layout.
    /// Layouts are contrustructed in the Layoutcomposer class.
    /// Cell and footer resistrations are shortenend by helper extensions created in the
    /// UICollectionView+Extension file.
    private func configureCollectionView() {
        let size: GridSize = device == .pad ? .large : .medium
        let layout = layoutComposer.setCollectionViewLayout(gridItemSize: size)
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = dataSource
    }
    
    private func configureRefresherControl() {
        refresherControl.addAction(UIAction(handler: { [weak self] _ in
            self?.refreshBookList()
        }), for: .valueChanged)
    }
    
    // MARK: - API call
    /// Api call to get book or list of books.
    /// - Parameters:
    ///   - query: String passing search keywords, could be title, author or isbn
    ///   - fromIndex: Define the starting point of the book to fetxh, used for pagination.
    private func getBooks(fromIndex: Int = 0) {
        footerView.displayActivityIndicator(true)
        
        apiManager.getData(with: currentSearchKeywords, fromIndex: fromIndex) { [weak self] result in
            guard let self = self else { return }
            self.refresherControl.endRefreshing()
            self.footerView.displayActivityIndicator(false)
            
            switch result {
            case .success(let books):
                self.handleList(for: books)
            case .failure(let error):
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
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
        case .keywordSearch:
            books.isEmpty ? noMoreBooks = true : addBooks(books)
        case .barCodeSearch:
            newBookDelegate?.newBook = books.first
        case .none:
            return
        }
    }
    
    private func addBooks(_ books: [Item]) {
        books.forEach {  book in
            if !self.searchedBooks.contains(where: { $0.volumeInfo?.title == book.volumeInfo?.title }) {
                self.searchedBooks.append(book)
                self.applySnapshot()
            }
        }
    }
    
    private func refreshBookList() {
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
    private func createDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView,
                                    cellProvider: { [weak self] (collectionView, indexPath, book) -> UICollectionViewCell? in
            let cell: BookCollectionViewCell = collectionView.dequeue(for: indexPath)
            self?.cellPresenter?.setBookData(for: book) { bookData in
                cell.configure(with: bookData)
            }
            return cell
        })
        configureFooter(dataSource)
        return dataSource
    }
  
    /// Adds a footer to the collectionView.
    /// - Parameter dataSource: datasource to add the footer
    private func configureFooter(_ dataSource: SearchViewController.DataSource) {
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                self?.headerView = collectionView.dequeue(kind: kind, for: indexPath)
                self?.headerView.configure(with: "Powered by GoogleBooks", buttonTitle: "")
                return self?.headerView
            case UICollectionView.elementKindSectionFooter:
                self?.footerView = collectionView.dequeue(kind: kind, for: indexPath)
                return self?.footerView
            default:
                return nil
            }
        }
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        emptyStateView.isHidden = !searchedBooks.isEmpty
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(searchedBooks, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
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
