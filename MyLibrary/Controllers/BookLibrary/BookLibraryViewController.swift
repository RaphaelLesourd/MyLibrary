//
//  SearchResultViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 24/10/2021.
//

import UIKit
/// Class inherit from a common class CollectionViewController to set up a collectionView.
class BookLibraryViewController: UIViewController {
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<SingleSection, ItemDTO>
    typealias DataSource = UICollectionViewDiffableDataSource<SingleSection, ItemDTO>
    
    private lazy var dataSource = makeDataSource()
    private let mainView = BookListView()
    private let layoutComposer: BookListLayoutMaker
    private let presenter: LibraryPresenter
    private let factory: Factory
    private var bookListMenu: BookListMenu?
    private var gridSize: GridSize = .medium {
        didSet {
            updateGridLayout()
        }
    }

    init(currentQuery: BookQuery?,
         title: String?,
         presenter: LibraryPresenter,
         layoutComposer: BookListLayoutMaker,
         factory: Factory) {
        self.presenter = presenter
        self.presenter.currentQuery = currentQuery
        self.layoutComposer = layoutComposer
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = mainView
        view.backgroundColor = .viewControllerBackgroundColor
        title = setViewControllerTitle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        configureNavigationBarButton()
        configureEmptyStateView()
        bookListMenu?.getSavedLayout()
        presenter.fetchBookList()
    }

    // MARK: - Setup
    private func setDelegates() {
        mainView.emptyStateView.delegate = self
        mainView.delegate = self
        presenter.view = self
        bookListMenu = BookListMenu(delegate: self)
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = dataSource
    }
    
    private func configureNavigationBarButton() {
        var showFilterMenu = true
        if presenter.currentQuery?.listType == .categories || presenter.currentQuery?.listType == .users {
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
    
    private func setViewControllerTitle() -> String {
        if let categoryTitle = title, !categoryTitle.isEmpty {
            return categoryTitle.capitalized
        }
        if let query = presenter.currentQuery?.listType {
            return query.title
        }
        return Text.ControllerTitle.myBooks
    }
    
    private func updateGridLayout() {
        let layout = layoutComposer.makeCollectionViewLayout(gridItemSize: gridSize)
        mainView.collectionView.setCollectionViewLayout(layout, animated: true)
        applySnapshot(animatingDifferences: true)
    }
    
    func updateSectionTitle(with title: String) {
        let text = Text.ListMenu.bookListMenuTitle + " " + title.lowercased()
        mainView.headerView.configure(with: text, buttonTitle: "")
    }
    
    // MARK: - Navigation
    func presentBookCardController(for book: ItemDTO) {
        let bookCardVC = factory.makeBookCardVC(book: book)
        bookCardVC.hidesBottomBarWhenPushed = true
        showController(bookCardVC)
    }
}

// MARK: - CollectionView Delegate
extension BookLibraryViewController: UICollectionViewDelegate {
    /// Keeps track whe the last cell is displayed. User to load more data.
    /// In this case when the last 3 cells are displayed and the last book hasn't been reached, more data are fetched.
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        let lastRow = collectionView.numberOfItems(inSection: indexPath.section) - 1
        presenter.loadMoreBooks(currentIndex: indexPath.row, lastRow: lastRow)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let selectedBook = dataSource.itemIdentifier(for: indexPath) else { return }
        presentBookCardController(for: selectedBook)
    }
}

// MARK: - CollectionView Datasource
extension BookLibraryViewController {
    
    /// Creates diffable dataSource for the CollectionView
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: mainView.collectionView,
                                    cellProvider: { [weak self] (collectionView, indexPath, book) -> UICollectionViewCell? in
            guard let self = self else { return nil }
            let cell: BookCollectionViewCell = collectionView.dequeue(for: indexPath)
            let bookData = self.presenter.makeBookCellUI(for: book)
            cell.configure(with: bookData)
            return cell
        })
        configureSupplementaryViews(dataSource)
        return dataSource
    }
    /// Adds a footer and Header to the collectionView.
    /// - Parameter dataSource: datasource to add the footer
    private func configureSupplementaryViews(_ dataSource: BookLibraryViewController.DataSource) {
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
        updateSectionTitle(with: listType.title)
        presenter.updateQuery(by: listType)
    }
    
    func setLayoutFromMenu(for size: GridSize) {
        gridSize = size
    }
}
// MARK: - BookListView Delegate
extension BookLibraryViewController: BookListViewDelegate {

    func refreshBookList() {
        presenter.fetchBookList()
    }
}

// MARK: - EmptyStateView Delegate
extension BookLibraryViewController: EmptyStateViewDelegate {
    func didTapButton() {
        guard let splitController = splitViewController, !splitController.isCollapsed else {
            if let controller = tabBarController as? TabBarController {
                controller.selectedIndex = 1
            }
            return
        }
        splitViewController?.show(.primary)
        if let controller = splitViewController?.viewController(for: .primary) as? NewBookViewController {
            controller.subViews.bookTileCell.textField.becomeFirstResponder()
        }
    }
}

// MARK: - LibraryPresenter Delegate
extension BookLibraryViewController: LibraryPresenterView {
    func startActivityIndicator() {
        showIndicator(mainView.activityIndicator)
        mainView.footerView.displayActivityIndicator(true)
    }
    
    func stopActivityIndicator() {
        DispatchQueue.main.async {
            self.hideIndicator(self.mainView.activityIndicator)
            self.mainView.refresherControl.endRefreshing()
            self.mainView.footerView.displayActivityIndicator(false)
        }
    }
}
