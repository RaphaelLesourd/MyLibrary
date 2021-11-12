//
//  HomeViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - Properties
    typealias DataSource = UICollectionViewDiffableDataSource<HomeCollectionViewSections, Item>
    typealias Snapshot   = NSDiffableDataSourceSnapshot<HomeCollectionViewSections, Item>
    private lazy var dataSource = makeDataSource()
    
    private var collectionView    = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private let activityIndicator = UIActivityIndicatorView()
    private let refresherControl  = UIRefreshControl()
    
    private var layoutComposer = LayoutComposer()
    private var libraryService : LibraryServiceProtocol
    
    private let latestBookQuery   = BookQuery.latestBookQuery
    private let favoriteBookQuery = BookQuery.favoriteBookQuery
    private let recommandedQuery  = BookQuery.recommandeBookQuery
    private var currentQuery: BookQuery?
   
    private var latestBooks     : [Item] = []
    private var favoriteBooks   : [Item] = []
    private var recommandedBooks: [Item] = []
    private var categories      : [Item] = []
    
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
        applySnapshot(animatingDifferences: false)
        fetchBookLists()
    }
  
    // MARK: - Setup
    private func configureViewController() {
        view.backgroundColor = .viewControllerBackgroundColor
        title = Text.ControllerTitle.home
    }
    
    private func addNavigationBarButtons() {
        let activityIndicactorButton = UIBarButtonItem(customView: activityIndicator)
        navigationItem.rightBarButtonItems = [activityIndicactorButton]
    }
    
    private func configureCollectionView() {
        let layout = layoutComposer.composeHomeCollectionViewLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(cell: CategoryCollectionViewCell.self)
        collectionView.register(cell: VerticalCollectionViewCell.self)
        collectionView.register(cell: HorizontalCollectionViewCell.self)
        collectionView.register(header: HeaderSupplementaryView.self)
        
        collectionView.delegate                     = self
        collectionView.dataSource                   = dataSource
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor              = .clear
        collectionView.frame                        = view.frame
        collectionView.contentInset                 = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
        view.addSubview(collectionView)
    }
    
    private func configureRefresherControl() {
        refresherControl.attributedTitle = NSAttributedString(string: "Rechargement")
        refresherControl.tintColor       = .label
        collectionView.refreshControl    = refresherControl
        refresherControl.addTarget(self, action: #selector(fetchBookLists), for: .valueChanged)
    }
    
    // MARK: - Api call
    @objc private func fetchBookLists() {
        getBooks(for: .latestBookQuery) { [weak self] books in
            self?.latestBooks = books
        }
        getBooks(for: .favoriteBookQuery) { [weak self] books in
            self?.favoriteBooks = books
        }
        getBooks(for: .recommandeBookQuery) { [weak self] books in
            self?.recommandedBooks = books
            self?.applySnapshot()
        }
    }
    
    private func getBooks(for query: BookQuery, completion: @escaping ([Item]) -> Void) {
        showIndicator(activityIndicator)
        
        libraryService.getBooks(for: query, forMore: false) { [weak self] result in
            guard let self = self else { return }
            self.hideIndicator(self.activityIndicator)
            self.refresherControl.endRefreshing()
            switch result {
            case .success(let books):
                DispatchQueue.main.async {
                    completion(books)
                }
            case .failure(let error):
                completion([])
                self.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
    
    // MARK: - Targets
    @objc private func showMoreBook(_ sender: UIButton) {
        let bookListVC = BookLibraryViewController(libraryService: LibraryService())
        switch HomeCollectionViewSections(rawValue: sender.tag) {
        case .categories:
            currentQuery = nil
        case .newEntry:
            currentQuery = latestBookQuery
        case .recommanding:
            currentQuery = recommandedQuery
        case .favorites:
            currentQuery = favoriteBookQuery
        case .none:
            currentQuery = nil
        }
        if let currentQuery = currentQuery {
            bookListVC.currentQuery = currentQuery
            navigationController?.pushViewController(bookListVC, animated: true)
        }
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
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            let headerView = collectionView.dequeue(kind: kind, for: indexPath) as HeaderSupplementaryView
            if let headerTitle = HomeCollectionViewSections(rawValue: indexPath.section)?.title {
                headerView.configureTitle(with: headerTitle)
            }
            headerView.actionButton.tag = HomeCollectionViewSections.allCases[indexPath.section].rawValue
            headerView.actionButton.addTarget(self, action: #selector(self?.showMoreBook(_:)), for: .touchUpInside)
            return headerView
        }
    }
    /// Set the data to th section of the collectionView, in this case only one section (main)
    /// - Parameter animatingDifferences: Animate the collectionView with the changes applied.
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections(HomeCollectionViewSections.allCases)
      //  snapshot.appendItems(latestBooks, toSection: .categories)
        snapshot.appendItems(latestBooks, toSection: .newEntry)
        snapshot.appendItems(favoriteBooks, toSection: .favorites)
        snapshot.appendItems(recommandedBooks, toSection: .recommanding)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
// MARK: - CollectionView Delegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedBook = dataSource.itemIdentifier(for: indexPath) else { return }
        showBookDetails(for: selectedBook, searchType: .librarySearch)
    }
}
