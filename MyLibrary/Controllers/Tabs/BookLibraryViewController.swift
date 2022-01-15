//
//  SearchResultViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 24/10/2021.
//

import UIKit
/// Class inherit from a common class CollectionViewController to set up a collectionView.
class BookLibraryViewController: CollectionViewController {
    
    // MARK: - Properties
    typealias Snapshot = NSDiffableDataSourceSnapshot<SingleSection, Item>
    typealias DataSource = UICollectionViewDiffableDataSource<SingleSection, Item>
    
    private lazy var dataSource = makeDataSource()
    private let layoutComposer: BookListLayoutComposer
    private let libraryService: LibraryServiceProtocol
    private let queryService: QueryProtocol
    private let cellPresenter: CellPresenter
    
    private var noMoreBooks = false
    private var headerView = HeaderSupplementaryView()
    private var footerView = LoadingFooterSupplementaryView()
    private var bookListMenu: BookListMenu?
    private var currentQuery: BookQuery
    private var bookList: [Item] = []
    private var gridItemSize: GridSize = .medium {
        didSet {
            updateGridLayout()
        }
    }
    
    // MARK: - Initializer
    init(currentQuery: BookQuery,
         queryService: QueryService,
         libraryService: LibraryServiceProtocol,
         layoutComposer: BookListLayoutComposer) {
        self.currentQuery = currentQuery
        self.queryService = queryService
        self.libraryService = libraryService
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
        bookListMenu = BookListMenu(delegate: self)
        bookListMenu?.loadLayoutChoice()
        
        configureCollectionView()
        configureNavigationBarButton()
        configureRefresherControl()
        refreshBookList()
    }
    
    override func viewDidLayoutSubviews() {
        updateHeader(with: .timestamp)
    }
    // MARK: - Setup
    private func configureCollectionView() {
        collectionView.register(cell: BookCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = dataSource
    }
    
    private func configureRefresherControl() {
        refresherControl.addAction(UIAction(handler: { [weak self] _ in
            self?.refreshBookList()
        }), for: .valueChanged)
    }
    
    private func configureNavigationBarButton() {
        var showFilterMenu = true
        if currentQuery.listType == .categories || currentQuery.listType == .users {
            showFilterMenu = false
        }
        let menuButton = UIBarButtonItem(image: Images.NavIcon.gridLayoutMenu,
                                         primaryAction: nil,
                                         menu: bookListMenu?.configureLayoutMenu(with: showFilterMenu))
        navigationItem.rightBarButtonItem = menuButton
    }
    
    private func setTitle() -> String {
        if let categoryTitle = title, !categoryTitle.isEmpty {
            return categoryTitle.capitalized
        }
        if let query = currentQuery.listType {
            return query.title
        }
        return Text.ControllerTitle.myBooks
    }
    
    private func updateGridLayout() {
        let layout = layoutComposer.setCollectionViewLayout(gridItemSize: gridItemSize)
        collectionView.setCollectionViewLayout(layout, animated: true)
        applySnapshot()
    }
    
    private func updateHeader(with listType: QueryType) {
        let title = Text.ListMenu.bookListMenuTitle + " " + listType.title.lowercased()
        headerView.configure(with: title, buttonTitle: "")
    }
    
    // MARK: - Api call
    private func getBooks(nextPage: Bool = false) {
        showIndicator(activityIndicator)
        footerView.displayActivityIndicator(true)
        
        libraryService.getBookList(for: currentQuery, limit: 40, forMore: nextPage) { [weak self] result in
            guard let self = self else { return }
            self.hideIndicator(self.activityIndicator)
            self.refresherControl.endRefreshing()
            self.footerView.displayActivityIndicator(false)
            
            switch result {
            case .success(let books):
                guard !books.isEmpty else {
                    self.noMoreBooks = true
                    self.applySnapshot()
                    return
                }
                self.addBookToList(books)
            case .failure(let error):
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
    
    private func addBookToList(_ books: [Item]) {
        books.forEach { book in
            if !bookList.contains(where: { $0.bookID == book.bookID }) {
                bookList.append(book)
                applySnapshot()
            }
        }
    }
    // MARK: - Targets
    private func refreshBookList() {
        title = setTitle()
        noMoreBooks = false
        bookList.removeAll()
        getBooks()
    }
}

// MARK: - CollectionView Delegate
extension BookLibraryViewController: UICollectionViewDelegate {
    /// Keeps track whe the last cell is displayed. User to load more data.
    /// In this case when the last 3 cells are displayed and the last book hasn't been reached, more data are fetched.
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        let currentRow = collectionView.numberOfItems(inSection: indexPath.section) - 1
        if indexPath.row == currentRow && noMoreBooks == false {
            getBooks(nextPage: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let selectedBook = dataSource.itemIdentifier(for: indexPath) else { return }
        showBookDetails(for: selectedBook, searchType: nil)
    }
}

// MARK: - CollectionView Datasource
extension BookLibraryViewController {
    
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView,
                                    cellProvider: { [weak self] (collectionView, indexPath, book) -> UICollectionViewCell? in
            let cell: BookCollectionViewCell = collectionView.dequeue(for: indexPath)
            self?.cellPresenter.setBookData(for: book) { bookData in
                cell.configure(with: bookData)
            }
            return cell
        })
        configureFooter(dataSource)
        return dataSource
    }
    /// Adds a footer to the collectionView.
    /// - Parameter dataSource: datasource to add the footer
    private func configureFooter(_ dataSource: BookLibraryViewController.DataSource) {
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                self?.headerView = collectionView.dequeue(kind: kind, for: indexPath)
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
        collectionView.isHidden = bookList.isEmpty
        emptyStateView.isHidden = !bookList.isEmpty
        
        var snapshot = Snapshot()
        if !bookList.isEmpty {
            snapshot.appendSections([.main])
            snapshot.appendItems(bookList, toSection: .main)
            dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        }
    }
}
// MARK: - Extension BookListLayoutDelegate
extension BookLibraryViewController: BookListMenuDelegate {
    
    func orderList(by listType: QueryType) {
        updateHeader(with: listType)
        currentQuery = queryService.updateQuery(from: currentQuery, with: listType.documentKey)
        refreshBookList()
    }
    
    func setLayoutFromMenu(for size: GridSize) {
        gridItemSize = size
    }
}
