//
//  SearchResultViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 24/10/2021.
//

import UIKit
/// Class inherit from a common class CollectionViewController to set up a collectionView.
class BookLibraryViewController: UIViewController, BookCellAdapter {
    
    // MARK: - Properties
    typealias Snapshot = NSDiffableDataSourceSnapshot<SingleSection, Item>
    typealias DataSource = UICollectionViewDiffableDataSource<SingleSection, Item>
    
    private lazy var dataSource = makeDataSource()
    private let mainView = BookListView()
    private let layoutComposer: BookListLayoutComposer
    private let queryService: QueryProtocol
    private let presenter: LibraryPresenter
    
    private var bookListMenu: BookListMenu?
    private var currentQuery: BookQuery
    private var gridItemSize: GridSize = .medium {
        didSet {
            updateGridLayout()
        }
    }
    private let factory: Factory
    
    // MARK: - Initializer
    init(currentQuery: BookQuery,
         queryService: QueryService,
         presenter: LibraryPresenter,
         layoutComposer: BookListLayoutComposer) {
        self.currentQuery = currentQuery
        self.queryService = queryService
        self.presenter = presenter
        self.layoutComposer = layoutComposer
        self.factory = ViewControllerFactory()
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
        title = setTitle()
        setDelegates()
        configureCollectionView()
        configureNavigationBarButton()
        configureEmptyStateView()
        
        bookListMenu?.loadLayoutChoice()
        applySnapshot(animatingDifferences: false)
        presenter.getBooks(with: currentQuery)
    }
    
    override func viewDidLayoutSubviews() {
        updateHeader(with: .timestamp)
    }
    
    // MARK: - Setup
    private func setDelegates() {
        mainView.emptyStateView.delegate = self
        mainView.delegate = self
        presenter.view = self
        bookListMenu = BookListMenu(delegate: self)
    }
    
    private func configureCollectionView() {
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = dataSource
    }
    
    private func configureNavigationBarButton() {
        var showFilterMenu = true
        if currentQuery.listType == .categories || currentQuery.listType == .users {
            showFilterMenu = false
        }
        let menuButton = UIBarButtonItem(image: Images.NavIcon.gridLayoutMenu,
                                         primaryAction: nil,
                                         menu: bookListMenu?.configureLayoutMenu(with: showFilterMenu))
        let activityIndicactorButton = UIBarButtonItem(customView: mainView.activityIndicator)
        navigationItem.rightBarButtonItems = [menuButton ,activityIndicactorButton]
    }
 
    private func configureEmptyStateView() {
        mainView.emptyStateView.configure(title: Text.EmptyState.noBookTitle,
                                          subtitle: Text.EmptyState.noBookSubtitle,
                                          icon: Images.TabBarIcon.booksIcon,
                                          hideButton: false)
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
        mainView.collectionView.setCollectionViewLayout(layout, animated: true)
        applySnapshot(animatingDifferences: true)
    }
    
    private func updateHeader(with listType: QueryType) {
        let title = Text.ListMenu.bookListMenuTitle + " " + listType.title.lowercased()
        mainView.headerView.configure(with: title, buttonTitle: "")
    }
    
    // MARK: - Navigation
    func showBookDetails(for book: Item) {
        let bookCardVC = factory.makeBookCardVC(book: book, type: nil, factory: factory)
        bookCardVC.hidesBottomBarWhenPushed = true
        if UIDevice.current.userInterfaceIdiom == .pad {
            let viewController = UINavigationController(rootViewController: bookCardVC)
            present(viewController, animated: true)
        } else {
            navigationController?.show(bookCardVC, sender: nil)
        }
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
        if indexPath.row == currentRow && presenter.endOfList == false {
            presenter.getBooks(with: currentQuery, nextPage: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let selectedBook = dataSource.itemIdentifier(for: indexPath) else { return }
        showBookDetails(for: selectedBook)
    }
}

// MARK: - CollectionView Datasource
extension BookLibraryViewController {
    
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: mainView.collectionView,
                                    cellProvider: { [weak self] (collectionView, indexPath, book) -> UICollectionViewCell? in
            guard let self = self else { return nil }
            let cell: BookCollectionViewCell = collectionView.dequeue(for: indexPath)
            let bookData = self.setBookData(for: book)
            cell.configure(with: bookData)
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
                self?.mainView.headerView = collectionView.dequeue(kind: kind, for: indexPath)
                return self?.mainView.headerView
            case UICollectionView.elementKindSectionFooter:
                self?.mainView.footerView = collectionView.dequeue(kind: kind, for: indexPath)
                return self?.mainView.footerView
            default:
                return nil
            }
            
        }
    }
    
    func applySnapshot(animatingDifferences: Bool) {
        mainView.collectionView.isHidden = presenter.bookList.isEmpty
        mainView.emptyStateView.isHidden = !presenter.bookList.isEmpty
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(presenter.bookList, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
// MARK: - BookListLayout Delegate
extension BookLibraryViewController: BookListMenuDelegate {
    
    func orderList(by listType: QueryType) {
        updateHeader(with: listType)
        currentQuery = queryService.updateQuery(from: currentQuery, with: listType.documentKey)
        refreshData()
    }
    
    func setLayoutFromMenu(for size: GridSize) {
        gridItemSize = size
    }
}
// MARK: - BookListView Delegate
extension BookLibraryViewController: BookListViewDelegate {
    func refreshData() {
        presenter.bookList.removeAll()
        presenter.endOfList = false
        presenter.getBooks(with: currentQuery)
    }
}

// MARK: - EmptyStateView Delegate
extension BookLibraryViewController: EmptyStateViewDelegate {
    func didTapButton() {
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
}

// MARK: - LibraryPresenter Delegate
extension BookLibraryViewController: LibraryPresenterView {
    func showActivityIndicator() {
        showIndicator(mainView.activityIndicator)
        mainView.footerView.displayActivityIndicator(true)
    }
    
    func stopActivityIndicator() {
        hideIndicator(mainView.activityIndicator)
        mainView.refresherControl.endRefreshing()
        mainView.footerView.displayActivityIndicator(false)
    }
}
