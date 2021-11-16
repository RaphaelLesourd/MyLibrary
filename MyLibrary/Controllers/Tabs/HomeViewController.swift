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
    
    private let mainView       = CommonCollectionView()
    private var layoutComposer = LayoutComposer()
    private var libraryService : LibraryServiceProtocol
    
    private var currentQuery    : BookQuery?
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
    override func loadView() {
        view                 = mainView
        view.backgroundColor = .viewControllerBackgroundColor
        title                = Text.ControllerTitle.home
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureRefresherControl()
        addNavigationBarButtons()
        applySnapshot(animatingDifferences: false)
        fetchBookLists()
    }
    
    // MARK: - Setup
    private func addNavigationBarButtons() {
        let activityIndicactorButton = UIBarButtonItem(customView: mainView.activityIndicator)
        navigationItem.rightBarButtonItems = [activityIndicactorButton]
    }
    
    private func configureCollectionView() {
        let layout = layoutComposer.composeHomeCollectionViewLayout()
        mainView.collectionView.collectionViewLayout = layout
        mainView.collectionView.register(cell: CategoryCollectionViewCell.self)
        mainView.collectionView.register(cell: VerticalCollectionViewCell.self)
        mainView.collectionView.register(cell: HorizontalCollectionViewCell.self)
        mainView.collectionView.register(header: HeaderSupplementaryView.self)
        mainView.collectionView.delegate    = self
        mainView.collectionView.dataSource  = dataSource
    }
    
    private func configureRefresherControl() {
        mainView.refresherControl.addTarget(self, action: #selector(fetchBookLists), for: .valueChanged)
    }
    
    // MARK: - Api call
    @objc private func fetchBookLists() {
        getBooks(for: .latestBookQuery) { [weak self] books in
            self?.latestBooks = books
            self?.applySnapshot()
        }
        getBooks(for: .favoriteBookQuery) { [weak self] books in
            self?.favoriteBooks = books
            self?.applySnapshot()
        }
        getBooks(for: .recommandationQuery) { [weak self] books in
            self?.recommandedBooks = books
            self?.applySnapshot()
        }
    }
    
    private func getBooks(for query: BookQuery, completion: @escaping ([Item]) -> Void) {
        showIndicator(mainView.activityIndicator)
        
        libraryService.getBookList(for: query, limit: 20, forMore: false) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.hideIndicator(self.mainView.activityIndicator)
                self.mainView.refresherControl.endRefreshing()
                switch result {
                case .success(let books):
                    completion(books)
                case .failure(let error):
                    self.presentAlertBanner(as: .error, subtitle: error.description)
                }
            }
        }
    }
    
    // MARK: - Targets
    @objc private func showMoreButtonAction(_ sender: UIButton) {
        let bookListVC = BookLibraryViewController(libraryService: LibraryService())
        switch HomeCollectionViewSections(rawValue: sender.tag) {
        case .categories, .none:
            currentQuery = nil
        case .newEntry:
            currentQuery = BookQuery.latestBookQuery
        case .recommanding:
            currentQuery = BookQuery.recommandationQuery
        case .favorites:
            currentQuery = BookQuery.favoriteBookQuery
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
        let dataSource = DataSource(collectionView: mainView.collectionView,
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
            headerView.actionButton.addTarget(self, action: #selector(self?.showMoreButtonAction(_:)), for: .touchUpInside)
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
