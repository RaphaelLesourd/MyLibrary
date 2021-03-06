//
//  SettingsViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit

class SearchViewController: UIViewController {

    typealias Snapshot = NSDiffableDataSourceSnapshot<SingleSection, ItemDTO>
    typealias DataSource = UICollectionViewDiffableDataSource<SingleSection, ItemDTO>
    
    weak var newBookDelegate: NewBookViewControllerDelegate?

    private(set) var presenter: SearchPresenter
    private let mainView = BookListView()
    private let layoutComposer: BookListLayoutMaker
    private var headerView = HeaderSupplementaryView()
    private var footerView = LoadingFooterSupplementaryView()
    private lazy var dataSource = makeDataSource()

    init(presenter: SearchPresenter,
         layoutComposer: BookListLayoutMaker) {
        self.presenter = presenter
        self.layoutComposer = layoutComposer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = mainView
        view.backgroundColor = .viewControllerBackgroundColor
        title = Text.ControllerTitle.search
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.delegate = self
        presenter.view = self
        configureEmptyStateView()
        configureNavigationBar()
        configureCollectionView()
        applySnapshot(animatingDifferences: false)
    }
    
    // MARK: Setup
    /// Set up the collectionView with diffable datasource and compositional layout.
    /// Layouts are contrustructed in the Layoutcomposer class.
    /// Cell and footer resistrations are shortenend by helper extensions created in the
    /// UICollectionView+Extension file.
    private func configureCollectionView() {
        let size: GridSize = UIDevice.current.userInterfaceIdiom == .pad ? .extraLarge : .medium
        let layout = layoutComposer.makeCollectionViewLayout(gridItemSize: size)
        mainView.collectionView.collectionViewLayout = layout
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = dataSource
    }
    
    private func configureNavigationBar() {
        let activityIndicactorButton = UIBarButtonItem(customView: mainView.activityIndicator)
        navigationItem.rightBarButtonItems = [activityIndicactorButton]
    }
    
    private func configureEmptyStateView() {
        mainView.emptyStateView.configure(title: Text.EmptyState.searchTitle,
                                          subtitle: Text.EmptyState.searchSubtitle,
                                          icon: Images.ButtonIcon.search,
                                          hideButton: true)
    }
}
// MARK: CollectionView datasource
extension SearchViewController {
    /// Create diffable Datasource for the collectionView.
    /// - configure the cell and in this case the footer.
    /// - Returns: UICollectionViewDiffableDataSource
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: mainView.collectionView,
                                    cellProvider: { [weak self] (collectionView, indexPath, book) -> UICollectionViewCell? in
            let cell: BookCollectionViewCell = collectionView.dequeue(for: indexPath)
            if let bookData = self?.presenter.makeBookCellUI(for: book) {
                cell.configure(with: bookData)
            }
            return cell
        })
        configureFooter(dataSource)
        return dataSource
    }
    
    /// Adds a footer to the collectionView.
    /// - Parameter dataSource: datasource to add the footer
    private func configureFooter(_ dataSource: SearchViewController.DataSource) {
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                self?.headerView = collectionView.dequeue(kind: kind, for: indexPath)
                self?.headerView.configure(with: Text.SectionTitle.searchHeader, buttonTitle: "")
                return self?.headerView
            case UICollectionView.elementKindSectionFooter:
                self?.footerView = collectionView.dequeue(kind: kind, for: indexPath)
                return self?.footerView
            default:
                return nil
            }
        }
    }
    
    func applySnapshot(animatingDifferences: Bool) {
        mainView.emptyStateView.isHidden = !presenter.searchList.isEmpty
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(presenter.searchList, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
// MARK: CollectionView delegate
extension SearchViewController: UICollectionViewDelegate {
    /// Keeps track whe the last cell is displayed. User to load more data.
    /// In this case when the last 3 cells are displayed and the last book hasn't been reached, more data are fetched.
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {

        let currentRow = collectionView.numberOfItems(inSection: indexPath.section) - 3
        if indexPath.row == currentRow && presenter.noMoreBooksFound == false {
            presenter.getBooks(with: presenter.currentSearchKeywords,
                               fromIndex: presenter.searchList.count + 1)
        }
    }
    /// When a cell is selected, the selected book is passed back to the newBookViewController
    /// via delgate patern protocol.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let searchBook = dataSource.itemIdentifier(for: indexPath) else { return }
        newBookDelegate?.setBookData(with: searchBook)
        presenter.clearData()
    }
}
// MARK: BookList view delegate
extension SearchViewController: BookListViewDelegate {

    func refreshBookList() {
        presenter.refreshSearchList()
    }
}
// MARK: Search presenter delegate
extension SearchViewController: SearchPresenterView {

    func startActivityIndicator() {
        footerView.displayActivityIndicator(true)
    }
    
    func stopActivityIndicator() {
        mainView.refresherControl.endRefreshing()
        footerView.displayActivityIndicator(false)
    }
}
