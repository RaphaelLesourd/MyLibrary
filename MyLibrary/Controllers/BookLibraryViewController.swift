//
//  SearchResultViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 24/10/2021.
//

import UIKit

class BookLibraryViewController: UIViewController {
    
    // MARK: - Properties
    typealias Snapshot   = NSDiffableDataSourceSnapshot<SingleSection, Item>
    typealias DataSource = UICollectionViewDiffableDataSource<SingleSection, Item>
    private lazy var dataSource = makeDataSource()
    
    private var noMoreBooks    = false
    private var layoutComposer : LayoutComposer
    private let mainView       = CollectionView()
    private var footerView     = LoadingFooterSupplementaryView()
    private var libraryService : LibraryServiceProtocol
    private var bookList       : [Item] = []
    
    var currentQuery: BookQuery = BookQuery.defaultAllBookQuery
    
    // MARK: - Initializer
    init(libraryService: LibraryServiceProtocol, layoutComposer: LayoutComposer) {
        self.libraryService = libraryService
        self.layoutComposer = layoutComposer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        view  = mainView
        title = setTile()
        view.backgroundColor = .viewControllerBackgroundColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureRefresherControl()
        addNavigationBarButtons()
        applySnapshot(animatingDifferences: false)
        getBooks()
    }
    
    // MARK: - Setup
    private func addNavigationBarButtons() {
        let activityIndicactorButton = UIBarButtonItem(customView: mainView.activityIndicator)
        navigationItem.rightBarButtonItems = [activityIndicactorButton]
    }
    
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
    
    private func setTile() -> String {
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
        showIndicator(mainView.activityIndicator)
        footerView.displayActivityIndicator(true)
        
        libraryService.getBookList(for: currentQuery, limit: 40, forMore: nextPage) { [weak self] result in
            guard let self = self else { return }
            self.hideIndicator(self.mainView.activityIndicator)
            self.mainView.refresherControl.endRefreshing()
            self.footerView.displayActivityIndicator(false)
            
            switch result {
            case .success(let books):
                guard !books.isEmpty else {
                    return self.noMoreBooks = true
                }
                self.addToList(books)
            case .failure(let error):
                self.presentAlertBanner(as: .error, subtitle: error.description)
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
    @objc private func refreshBookList() {
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
        dataSource = DataSource(collectionView: mainView.collectionView,
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
        snapshot.appendSections(SingleSection.allCases)
        snapshot.appendItems(bookList, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
