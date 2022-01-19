//
//  HomeViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit

class HomeViewController: UIViewController, BookDetail {
    
    // MARK: - Properties
    typealias DataSource = UICollectionViewDiffableDataSource<HomeCollectionViewSections, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<HomeCollectionViewSections, AnyHashable>
    
    var latestBooks: [Item] = []
    var favoriteBooks: [Item] = []
    var recommandedBooks: [Item] = []
    var followedUser: [UserModel] = []
    
    private lazy var dataSource = createDataSource()
    private let mainView = BookListView()
    private let layoutComposer: HomeLayoutComposer
    private let cellConfigurator: BookCellAdapter
    private let userCellConfigurator: UserCellConfigure
    private let presenter: HomePresenter
    
    // MARK: - Initializer
    init(presenter: HomePresenter,
         cellConfigurator: BookCellAdapter,
         userCellConfigurator: UserCellConfigure,
         layoutComposer: HomeLayoutComposer) {
        self.presenter = presenter
        self.layoutComposer = layoutComposer
        self.cellConfigurator = cellConfigurator
        self.userCellConfigurator = userCellConfigurator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = mainView
        view.backgroundColor = .viewControllerBackgroundColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.emptyStateView.isHidden = true
        mainView.delegate = self
        presenter.view = self
        configureCollectionView()
        addNavigationBarButtons()
        applySnapshot(animatingDifferences: false)
        refreshData()
    }
    
    // MARK: - Setup
    private func configureCollectionView() {
        mainView.collectionView.collectionViewLayout = layoutComposer.setCollectionViewLayout(dataSource: dataSource)
        mainView.collectionView.dataSource = dataSource
        mainView.collectionView.delegate = self
    }
    
    private func addNavigationBarButtons() {
        guard let controller = splitViewController, !controller.isCollapsed else { return }
        let accountButton = UIBarButtonItem(image: Images.NavIcon.accountIcon,
                                            style: .plain,
                                            target: self,
                                            action: #selector(showAccountController))
        let activityIndicactor = UIBarButtonItem(customView: mainView.activityIndicator)
        navigationItem.rightBarButtonItems = [accountButton, activityIndicactor]
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
                                                   presenter: LibraryPresenter(libraryService: LibraryService()),
                                                   layoutComposer: BookListLayout())
        bookListVC.title = title
        navigationController?.show(bookListVC, sender: nil)
    }
    
    private func showCategories() {
        let categoryListVC = CategoriesViewController(settingBookCategory: false,
                                                      categoryPresenter: CategoryPresenter(categoryService: CategoryService()))
        if UIDevice.current.userInterfaceIdiom == .pad {
            let categoryVC = UINavigationController(rootViewController: categoryListVC)
            present(categoryVC, animated: true, completion: nil)
        } else {
            navigationController?.show(categoryListVC, sender: nil)
        }
    }
    
    @objc private func showAccountController() {
        let accountService = AccountService(userService: UserService(),
                                            libraryService: LibraryService(),
                                            categoryService: CategoryService())
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
        let dataSource = DataSource(collectionView: mainView.collectionView,
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
                    self.cellConfigurator.setBookData(for: book) { bookData in
                        cell.configure(with: bookData)
                    }
                    return cell
                }
            case .recommanding:
                if let book = item as? Item {
                    let cell: DetailedBookCollectionViewCell = collectionView.dequeue(for: indexPath)
                    self.cellConfigurator.setBookData(for: book) { bookData in
                        cell.configure(with: bookData)
                    }
                    return cell
                }
            case .users:
                if let followedUser = item as? UserModel {
                    let cell: UserCollectionViewCell = collectionView.dequeue(for: indexPath)
                    self.userCellConfigurator.setData(with: followedUser) { data in
                        cell.configure(with: data)
                    }
                    return cell
                }
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
            let section = dataSource.snapshot().sectionIdentifiers[indexPath.section]
            
            let headerView = collectionView.dequeue(kind: kind, for: indexPath) as HeaderSupplementaryView
            headerView.configure(with: section.title, buttonTitle: section.buttonTitle)
            headerView.moreButton.tag = section.buttonTag
            headerView.moreButton.addTarget(self, action: #selector(self?.showMoreButtonAction(_:)), for: .touchUpInside)
            return headerView
        }
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
            showBookDetails(for: book, searchType: nil, controller: self)
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
// MARK: - BookListView Delegate
extension HomeViewController: BookListViewDelegate {
    
    func emptyStateButtonTapped() {
        guard let splitController = splitViewController, !splitController.isCollapsed else {
            if let controller = tabBarController as? TabBarController {
                controller.selectedIndex = 2
            }
            return
        }
        splitViewController?.show(.primary)
        if let controller = splitViewController?.viewController(for: .primary) as? NewBookViewController {
            controller.newBookView.bookTileCell.textField.becomeFirstResponder()
        }
    }
    
    func refreshData() {
        presenter.getCategories()
        presenter.getLatestBooks()
        presenter.getFavoriteBooks()
        presenter.getRecommendations()
        presenter.getUsers()
    }
}
// MARK: - HomePresenter
extension HomeViewController: HomePresenterView {
    
    func applySnapshot(animatingDifferences: Bool) {
        var snapshot = Snapshot()
        DispatchQueue.main.async {
            if !self.presenter.categoryService.categories.isEmpty {
                snapshot.appendSections([.categories])
                snapshot.appendItems(self.presenter.categoryService.categories, toSection: .categories)
            }
            if !self.latestBooks.isEmpty {
                snapshot.appendSections([.newEntry])
                snapshot.appendItems(self.latestBooks, toSection: .newEntry)
            }
            if !self.favoriteBooks.isEmpty {
                snapshot.appendSections([.favorites])
                snapshot.appendItems(self.favoriteBooks, toSection: .favorites)
            }
            if !self.followedUser.isEmpty {
                snapshot.appendSections([.users])
                snapshot.appendItems(self.followedUser.sorted(by: { $0.displayName.lowercased() < $1.displayName.lowercased() }),
                                     toSection: .users)
            }
            if !self.recommandedBooks.isEmpty {
                snapshot.appendSections([.recommanding])
                snapshot.appendItems(self.recommandedBooks, toSection: .recommanding)
            }
            self.dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        }
    }
    
    func showActivityIndicator() {
        showIndicator(mainView.activityIndicator)
    }
    
    func stopActivityIndicator() {
        hideIndicator(self.mainView.activityIndicator)
        mainView.refresherControl.endRefreshing()
    }
}
