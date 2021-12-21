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
    private var noMoreBooks = false
    private var footerView = LoadingFooterSupplementaryView()
    private var layoutComposer: ListLayoutComposer
    private var libraryService: LibraryServiceProtocol
    private var queryService: QueryServiceProtocol
    private var bookListMenu: BookListLayoutMenu?
    private var currentQuery: BookQuery
    private var bookList: [Item] = []
    private var gridItemSize: GridItemSize = .medium {
        didSet {
            let layout = layoutComposer.setCollectionViewLayout(gridItemSize: gridItemSize)
            collectionView.setCollectionViewLayout(layout, animated: true)
            applySnapshot()
        }
    }
    
    // MARK: - Initializer
    init(currentQuery: BookQuery,
         queryService: QueryService,
         libraryService: LibraryServiceProtocol,
         layoutComposer: ListLayoutComposer) {
        self.currentQuery = currentQuery
        self.queryService = queryService
        self.libraryService = libraryService
        self.layoutComposer = layoutComposer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        queryService.currentQuery = currentQuery
        bookListMenu = BookListLayoutMenu(delegate: self)
        bookListMenu?.loadLayoutChoice()
        emptyStateView.titleLabel.text = Text.Placeholder.bookListEmptyState + setTitle()
      
        configureCollectionView()
        configureNavigationBarButton()
        configureRefresherControl()
        applySnapshot(animatingDifferences: false)
        refreshBookList()
    }
    
    // MARK: - Setup
    private func configureCollectionView() {
        collectionView.register(cell: VerticalCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = dataSource
    }
    
    private func configureRefresherControl() {
        refresherControl.addTarget(self, action: #selector(refreshBookList), for: .valueChanged)
    }
    
    private func configureNavigationBarButton() {
        let show: Bool = currentQuery.listType != .categories
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Images.NavIcon.gridLayoutMenu,
                                                            primaryAction: nil,
                                                            menu: bookListMenu?.configureLayoutMenu(withFilterMenu: show))
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
                    return self.noMoreBooks = true
                }
                self.addToList(books)
            case .failure(let error):
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
    
    private func addToList(_ books: [Item]) {
        books.forEach { book in
            if !bookList.contains(where: { $0.bookID == book.bookID }) {
                bookList.append(book)
                applySnapshot()
            }
        }
    }
    // MARK: - Targets
    @objc func refreshBookList() {
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
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let currentRow = collectionView.numberOfItems(inSection: indexPath.section) - 3
        if indexPath.row == currentRow && noMoreBooks == false {
            getBooks(nextPage: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedBook = dataSource.itemIdentifier(for: indexPath) else { return }
        showBookDetails(for: selectedBook, searchType: .librarySearch)
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
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            self?.footerView = collectionView.dequeue(kind: kind, for: indexPath)
            return self?.footerView
        }
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        emptyStateView.isHidden = !bookList.isEmpty
        snapshot.appendSections([.main])
        snapshot.appendItems(bookList, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
// MARK: - Extension BookListLayoutDelegate
extension BookLibraryViewController: BookListLayoutDelegate {
   
    func orderList(by type: DocumentKey) {
        queryService.currentQuery = currentQuery
        currentQuery = queryService.getQuery(with: type)
        refreshBookList()
    }
    
    func setLayoutFromMenu(for layout: GridItemSize) {
        gridItemSize = layout
    }
}
