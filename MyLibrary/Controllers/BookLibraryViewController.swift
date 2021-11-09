//
//  SearchResultViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 24/10/2021.
//

import UIKit

class BookLibraryViewController: UIViewController {
    
    // MARK: - Properties
    typealias Snapshot   = NSDiffableDataSourceSnapshot<BookListSection, BookSnippet>
    typealias DataSource = UICollectionViewDiffableDataSource<BookListSection, BookSnippet>
    private lazy var dataSource = makeDataSource()
    
    private var layoutComposer    = LayoutComposer()
    private var collectionView    = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private let activityIndicator = UIActivityIndicatorView()
    private let refresherControl  = UIRefreshControl()
    private var footerView        = LoadingFooterSupplementaryView()
    
    private var libraryService: LibraryServiceProtocol
    private var snippetsList  : [BookSnippet] = []
    private var noMoreBooks   = false
    var listType: HomeCollectionViewSections = .newEntry {
        didSet {
            title = listType.title
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
        configureRefresherControl()
        addNavigationBarButtons()
        getBooks(for: listType)
    }

    // MARK: - Setup
    private func configureViewController() {
        view.backgroundColor = .viewControllerBackgroundColor
    }
    
    private func addNavigationBarButtons() {
        let activityIndicactorButton = UIBarButtonItem(customView: activityIndicator)
        navigationItem.rightBarButtonItems = [activityIndicactorButton]
    }
    
    private func configureCollectionView() {
        let layout = layoutComposer.composeBookLibraryLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(cell: VerticalCollectionViewCell.self)
        collectionView.register(footer: LoadingFooterSupplementaryView.self)
        collectionView.delegate                     = self
        collectionView.dataSource                   = dataSource
        collectionView.backgroundColor              = .clear
        collectionView.frame                        = view.frame
        collectionView.showsVerticalScrollIndicator = false
        view.addSubview(collectionView)
    }
    
    private func configureRefresherControl() {
        refresherControl.attributedTitle = NSAttributedString(string: "Rechargement")
        refresherControl.tintColor       = .label
        collectionView.refreshControl    = refresherControl
        refresherControl.addTarget(self, action: #selector(refreshBookList), for: .valueChanged)
    }
  
    // MARK: - Api call
    private func getBooks(for listType: HomeCollectionViewSections, forMore: Bool = false) {
        showIndicator(activityIndicator)
        footerView.displayActivityIndicator(true)
        
        libraryService.getSnippets(limitNumber: 15, listType: listType, paginate: forMore) { [weak self] result in
            guard let self = self else { return }
            self.hideIndicator(self.activityIndicator)
            self.refresherControl.endRefreshing()
            self.footerView.displayActivityIndicator(false)
          
            switch result {
            case .success(let snippets):
                if snippets.isEmpty {
                    self.noMoreBooks = true
                } else {
                    self.snippetsList.append(contentsOf: snippets)
                    self.applySnapshot()
                }
            case .failure(let error):
                self.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
    
    // MARK: - Targets
    @objc private func refreshBookList() {
        snippetsList.removeAll()
        noMoreBooks = false
        getBooks(for: listType)
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
           getBooks(for: listType, forMore: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedBookId = dataSource.itemIdentifier(for: indexPath)?.etag else { return }
        showBookDetails(bookid: selectedBookId, searchType: .librarySearch)
    }
}

// MARK: - CollectionView Datasource
extension BookLibraryViewController {
    private func makeDataSource() -> DataSource {
        dataSource = DataSource(collectionView: collectionView,
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
