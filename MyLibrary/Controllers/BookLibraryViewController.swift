//
//  SearchResultViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 24/10/2021.
//

import UIKit

class BookLibraryViewController: UIViewController {
    
    // MARK: - Properties
    typealias Snapshot   = NSDiffableDataSourceSnapshot<BookListSection, Item>
    typealias DataSource = UICollectionViewDiffableDataSource<BookListSection, Item>
    private lazy var dataSource = makeDataSource()
    
    private var layoutComposer = LayoutComposer()
    private let mainView       = CommonCollectionView()
    private var footerView     = LoadingFooterSupplementaryView()
    
    private var libraryService: LibraryServiceProtocol
    private var bookList  : [Item] = []
    private var noMoreBooks   = false
    var currentQuery: BookQuery = BookQuery.defaultAllBookQuery
    
    // MARK: - Initializer
    init(libraryService: LibraryServiceProtocol) {
        self.libraryService = libraryService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
        title = currentQuery.listType?.title ?? "Tous mes livres"
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
        let layout = layoutComposer.composeBookLibraryLayout()
        mainView.collectionView.collectionViewLayout = layout
        mainView.collectionView.register(cell: VerticalCollectionViewCell.self)
        mainView.collectionView.register(footer: LoadingFooterSupplementaryView.self)
        mainView.collectionView.delegate   = self
        mainView.collectionView.dataSource = dataSource
    }
    
    private func configureRefresherControl() {
        mainView.refresherControl.addTarget(self, action: #selector(refreshBookList), for: .valueChanged)
    }
  
    // MARK: - Api call
    private func getBooks(nextPage: Bool = false) {
        showIndicator(mainView.activityIndicator)
        footerView.displayActivityIndicator(true)
        
        libraryService.getBookList(for: currentQuery, forMore: nextPage) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.hideIndicator(self.mainView.activityIndicator)
                self.mainView.refresherControl.endRefreshing()
                self.footerView.displayActivityIndicator(false)
                
                switch result {
                case .success(let books):
                    if books.isEmpty {
                        self.noMoreBooks = true
                    } else {
                        self.bookList.append(contentsOf: books)
                        self.applySnapshot()
                    }
                case .failure(let error):
                    self.presentAlertBanner(as: .error, subtitle: error.description)
                }
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
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            self.footerView = collectionView.dequeue(kind: kind, for: indexPath)
            return self.footerView
        }
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections(BookListSection.allCases)
        snapshot.appendItems(bookList, toSection: .mybooks)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
