//
//  HomeViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit

class HomeViewController: CollectionViewController {
    
    // MARK: - Properties
    typealias DataSource = UICollectionViewDiffableDataSource<HomeCollectionViewSections, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<HomeCollectionViewSections, AnyHashable>
    
    private lazy var dataSource = createDataSource()
    private let layoutComposer: HomeLayoutComposer
    private let libraryService: LibraryServiceProtocol
    private let categoryService: CategoryServiceProtocol
    private let recommendationService: RecommendationServiceProtocol
    private let cellPresenter: CellPresenter
    private let userCellPresenter: UserCellPresenter
    
    private var latestBooks: [Item] = []
    private var favoriteBooks: [Item] = []
    private var recommandedBooks: [Item] = []
    private var followedUser: [UserModel] = []
    
    // MARK: - Initializer
    init(libraryService: LibraryServiceProtocol,
         layoutComposer: HomeLayoutComposer,
         categoryService: CategoryServiceProtocol,
         recommendationService: RecommendationServiceProtocol) {
        self.libraryService = libraryService
        self.layoutComposer = layoutComposer
        self.categoryService = categoryService
        self.recommendationService = recommendationService
        self.cellPresenter = BookCellPresenter(imageRetriever: KFImageRetriever())
        self.userCellPresenter = FollowedUserDataCellPresenter(imageRetriever: KFImageRetriever())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = device == .pad ? Text.ControllerTitle.myBooks : Text.ControllerTitle.home
        configureCollectionView()
        configureRefresherControl()
        applySnapshot(animatingDifferences: false)
        fetchBookLists()
        addNavigationBarButtons()
    }
    
    // MARK: - Setup
    private func configureCollectionView() {
        collectionView.dataSource = dataSource
        collectionView.register(cell: CategoryCollectionViewCell.self)
        collectionView.register(cell: UserCollectionViewCell.self)
        collectionView.register(cell: BookCollectionViewCell.self)
        collectionView.register(cell: DetailedBookCollectionViewCell.self)
        collectionView.register(header: HeaderSupplementaryView.self)
        collectionView.delegate = self
    }
    
    private func configureRefresherControl() {
        refresherControl.addAction(UIAction(handler: { [weak self] _ in
            self?.fetchBookLists()
        }), for: .valueChanged)
    }

    private func addNavigationBarButtons() {
        guard device == .pad else { return }
        let addButton = UIBarButtonItem(image: Images.NavIcon.accountIcon,
                                        style: .plain,
                                        target: self,
                                        action: #selector(showAccountController))
        navigationItem.rightBarButtonItem = addButton
    }
    
    // MARK: - Api call
    
    private func fetchBookLists() {
        categoryService.getCategories { [weak self] error in
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
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
        recommendationService.retrieveRecommendingUsers { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
                    self?.followedUser = users
                    self?.applySnapshot()
                case .failure(let error):
                    AlertManager.presentAlertBanner(as: .error, subtitle: error.localizedDescription)
                }
            }
        }
    }
    
    private func getBooks(for query: BookQuery, completion: @escaping ([Item]) -> Void) {
        showIndicator(activityIndicator)
        
        libraryService.getBookList(for: query,
                                      limit: 15,
                                      forMore: false) { [weak self] result in
            guard let self = self else { return }
            self.hideIndicator(self.activityIndicator)
            self.refresherControl.endRefreshing()
            switch result {
            case .success(let books):
                completion(books)
            case .failure(let error):
                AlertManager.presentAlertBanner(as: .error,
                                                subtitle: error.description)
            }
        }
    }
    
    // MARK: - Targets
    @objc private func showMoreButtonAction(_ sender: UIButton) {
        let section = HomeCollectionViewSections(rawValue: sender.tag)
        switch section {
        case .categories:
            showCategories()
        case .users:
            showBookList(for: section?.sectionDataQuery, title: Text.SectionTitle.userRecommandation)
        default:
            showBookList(for: section?.sectionDataQuery)
        }
    }
    
    // MARK: - Navigation
    private func showBookList(for query: BookQuery?, title: String? = nil) {
        guard let query = query else { return }
        let bookListVC = BookLibraryViewController(currentQuery: query,
                                                   queryService: QueryService(),
                                                   libraryService: LibraryService(),
                                                   layoutComposer: BookListLayout())
        bookListVC.title = title
        navigationController?.show(bookListVC, sender: nil)
    }
    
    private func showCategories() {
        let categoryListVC = CategoriesViewController(settingBookCategory: false,
                                                      categoryService: CategoryService())
        if device == .pad {
            let categoryVC = UINavigationController(rootViewController: categoryListVC)
            present(categoryVC, animated: true, completion: nil)
        } else {
            navigationController?.show(categoryListVC, sender: nil)
        }
    }
    
    @objc private func showAccountController() {
        let accountService = AccountService(userService: UserService(),
                                            libraryService: libraryService,
                                            categoryService: categoryService)
        let accountController = AccountViewController(accountService: accountService,
                                                      userService: UserService(),
                                                      imageService: ImageStorageService(),
                                                      feedbackManager: FeedbackManager())
        let accountVC = UINavigationController(rootViewController: accountController)
        present(accountVC, animated: true, completion: nil)
    }
}

// MARK: - DataSource
extension HomeViewController {
    /// Create diffable Datasource for the collectionView.
    /// - configure the cell and in this case the footer.
    /// - Returns: UICollectionViewDiffableDataSource
    private func createDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView,
                                    cellProvider: { [weak self] (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let self = self else { return nil}
            let sections = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            switch sections {
            case .categories:
                if let category = item as? CategoryModel {
                    let cell: CategoryCollectionViewCell = collectionView.dequeue(for: indexPath)
                    cell.configure(with: category)
                    return cell
                }
            case .newEntry, .favorites:
                if let book = item as? Item {
                    let cell: BookCollectionViewCell = collectionView.dequeue(for: indexPath)
                    self.cellPresenter.setBookData(for: book) { bookData in
                        cell.configure(with: bookData)
                    }
                    return cell
                }
            case .recommanding:
                if let book = item as? Item {
                    let cell: DetailedBookCollectionViewCell = collectionView.dequeue(for: indexPath)
                    self.cellPresenter.setBookData(for: book) { bookData in
                        cell.configure(with: bookData)
                    }
                    return cell
                }
            case .users:
                if let followedUser = item as? UserModel {
                    let cell: UserCollectionViewCell = collectionView.dequeue(for: indexPath)
                    self.userCellPresenter.setData(with: followedUser) { data in
                        cell.configure(with: data)
                    }
                    return cell
                }
            }
            return nil
        })
        configureHeader(dataSource)
        collectionView.collectionViewLayout = layoutComposer.setCollectionViewLayout(dataSource: dataSource)
        return dataSource
    }
    
    /// Adds a header to the collectionView.
    /// - Parameter dataSource: datasource to add the footer
    private func configureHeader(_ dataSource: HomeViewController.DataSource) {
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            let section = dataSource.snapshot().sectionIdentifiers[indexPath.section]
            
            let headerView = collectionView.dequeue(kind: kind, for: indexPath) as HeaderSupplementaryView
            headerView.configure(with: section.title, buttonTitle: section.buttonTitle)
            headerView.moreButton.tag = section.buttonTag
            headerView.moreButton.addTarget(self, action: #selector(self?.showMoreButtonAction(_:)), for: .touchUpInside)
            return headerView
        }
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        collectionView.isHidden = latestBooks.isEmpty
        emptyStateView.isHidden = !latestBooks.isEmpty
        
        var snapshot = Snapshot()
        if !categoryService.categories.isEmpty {
            snapshot.appendSections([.categories])
            snapshot.appendItems(categoryService.categories, toSection: .categories)
        }
        if !latestBooks.isEmpty {
            snapshot.appendSections([.newEntry])
            snapshot.appendItems(latestBooks, toSection: .newEntry)
        }
        if !favoriteBooks.isEmpty {
            snapshot.appendSections([.favorites])
            snapshot.appendItems(favoriteBooks, toSection: .favorites)
        }
        if !followedUser.isEmpty {
            snapshot.appendSections([.users])
            snapshot.appendItems(followedUser.sorted(by: { $0.displayName.lowercased() < $1.displayName.lowercased() }),
                                 toSection: .users)
        }
        if !recommandedBooks.isEmpty {
            snapshot.appendSections([.recommanding])
            snapshot.appendItems(recommandedBooks, toSection: .recommanding)
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
// MARK: - CollectionView Delegate
extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedItem = dataSource.itemIdentifier(for: indexPath) else { return }
        
        if let category = selectedItem as? CategoryModel {
            let categoryQuery = BookQuery(listType: .categories,
                                          orderedBy: .category,
                                          fieldValue: category.uid,
                                          descending: true)
            showBookList(for: categoryQuery, title: category.name)
        }
        if let book = selectedItem as? Item {
            showBookDetails(for: book, searchType: nil)
        }
        if let followedUser = selectedItem as? UserModel {
            let query = BookQuery(listType: .users,
                                  orderedBy: .ownerID,
                                  fieldValue: followedUser.userID,
                                  descending: true)
            showBookList(for: query, title: followedUser.displayName)
        }
    }
}
