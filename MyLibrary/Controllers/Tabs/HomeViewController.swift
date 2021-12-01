//
//  HomeViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    typealias DataSource = UICollectionViewDiffableDataSource<HomeCollectionViewSections, AnyHashable>
    typealias Snapshot   = NSDiffableDataSourceSnapshot<HomeCollectionViewSections, AnyHashable>
    private lazy var dataSource = makeDataSource()
    
    private let mainView        = CollectionView()
    private var layoutComposer  : LayoutComposer
    private var libraryService  : LibraryServiceProtocol
    private var categoryService = CategoryService.shared
    
    private var latestBooks     : [Item] = []
    private var favoriteBooks   : [Item] = []
    private var recommandedBooks: [Item] = []
    
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
        let layout = layoutComposer.setCollectionViewLayout()
        mainView.collectionView.collectionViewLayout = layout
        mainView.collectionView.register(cell: CategoryCollectionViewCell.self)
        mainView.collectionView.register(cell: VerticalCollectionViewCell.self)
        mainView.collectionView.register(cell: HorizontalCollectionViewCell.self)
        mainView.collectionView.register(header: HeaderSupplementaryView.self)
        mainView.collectionView.delegate   = self
        mainView.collectionView.dataSource = dataSource
    }
    
    private func configureRefresherControl() {
        mainView.refresherControl.addTarget(self, action: #selector(fetchBookLists), for: .valueChanged)
    }
    
    // MARK: - Api call
    @objc private func fetchBookLists() {
        categoryService.getCategories { [weak self] error in
            if let error = error {
                self?.presentAlertBanner(as: .error, subtitle: error.description)
            }
            self?.applySnapshot()
        }
        getBooks(for: .latestBookQuery) { [weak self] books in
            DispatchQueue.main.async {
                self?.latestBooks = books
                self?.applySnapshot()
            }
        }
        getBooks(for: .favoriteBookQuery) { [weak self] books in
            DispatchQueue.main.async {
                self?.favoriteBooks = books
                self?.applySnapshot()
            }
        }
        getBooks(for: .recommendationQuery) { [weak self] books in
            DispatchQueue.main.async {
                self?.recommandedBooks = books
                self?.applySnapshot()
            }
        }
    }
    
    private func getBooks(for query: BookQuery, completion: @escaping ([Item]) -> Void) {
        showIndicator(mainView.activityIndicator)
        
        libraryService.getBookList(for: query, limit: 20, forMore: false) { [weak self] result in
            guard let self = self else { return }
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
    
    // MARK: - Targets
    @objc private func showMoreButtonAction(_ sender: UIButton) {
        var query: BookQuery?
        switch HomeCollectionViewSections(rawValue: sender.tag) {
        case .categories:
            showCategories()
        case .newEntry:
            query = BookQuery.latestBookQuery
        case .recommanding:
            query = BookQuery.recommendationQuery
        case .favorites:
            query = BookQuery.favoriteBookQuery
        case  .none:
            query = nil
        }
        showBookList(for: query)
    }
    
    // MARK: - Navigation
    private func showBookList(for query: BookQuery?, title: String? = nil) {
        let bookListVC = BookLibraryViewController(libraryService: LibraryService(),
                                                   layoutComposer: ListLayout())
        if let query = query {
            bookListVC.currentQuery = query
            bookListVC.title = title
            navigationController?.pushViewController(bookListVC, animated: true)
        }
    }
    
    private func showCategories() {
        let categoryListVC = CategoriesViewController()
        categoryListVC.settingBookCategory = false
        navigationController?.pushViewController(categoryListVC, animated: true)
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
                if let category = item as? Category {
                    let cell: CategoryCollectionViewCell = collectionView.dequeue(for: indexPath)
                    cell.configure(text: category.name)
                    return cell
                }
            case .favorites, .newEntry:
                if let book = item as? Item {
                    let cell: VerticalCollectionViewCell = collectionView.dequeue(for: indexPath)
                    cell.configure(with: book)
                    return cell
                }
            case .recommanding:
                if let book = item as? Item {
                    let cell: HorizontalCollectionViewCell = collectionView.dequeue(for: indexPath)
                    cell.configure(with: book)
                    return cell
                }
            case .none:
                return nil
            }
            return nil
        })
        configureHeader(dataSource)
        return dataSource
    }
    /// Adds a header to the collectionView.
    /// - Parameter dataSource: datasource to add the footer
    private func configureHeader(_ dataSource: HomeViewController.DataSource) {
       
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            let headerView = collectionView.dequeue(kind: kind, for: indexPath) as HeaderSupplementaryView
            if let headerData = HomeCollectionViewSections(rawValue: indexPath.section) {
                headerView.configure(with: headerData.title, buttonTitle: headerData.buttonTitle)
            }
            headerView.titleView.actionButton.tag = HomeCollectionViewSections.allCases[indexPath.section].rawValue
            headerView.titleView.actionButton.addTarget(self, action: #selector(self?.showMoreButtonAction(_:)), for: .touchUpInside)
            return headerView
        }
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections(HomeCollectionViewSections.allCases)

        snapshot.appendItems(categoryService.categories, toSection: .categories)
        snapshot.appendItems(latestBooks, toSection: .newEntry)
        snapshot.appendItems(favoriteBooks, toSection: .favorites)
        snapshot.appendItems(recommandedBooks, toSection: .recommanding)
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
// MARK: - CollectionView Delegate
extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedItem = dataSource.itemIdentifier(for: indexPath) else { return }
        
        if let category = selectedItem as? Category {
            let categoryQuery = BookQuery(listType: .categories,
                                          orderedBy: .category,
                                          fieldValue: category.uid,
                                          descending: true)
            showBookList(for: categoryQuery, title: category.name)
        }
        if let book = selectedItem as? Item {
            showBookDetails(for: book, searchType: .librarySearch)
        }
    }
}
