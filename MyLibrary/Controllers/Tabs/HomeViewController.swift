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
    private var layoutComposer: HomeLayoutComposer
    private var libraryService: LibraryServiceProtocol
    private var categoryService: CategoryServiceProtocol
    private var latestBooks: [Item] = []
    private var favoriteBooks: [Item] = []
    private var recommandedBooks: [Item] = []
    
    // MARK: - Initializer
    init(libraryService: LibraryServiceProtocol,
         layoutComposer: HomeLayoutComposer,
         categoryService: CategoryServiceProtocol) {
        self.libraryService = libraryService
        self.layoutComposer = layoutComposer
        self.categoryService = categoryService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Text.ControllerTitle.home
        emptyStateView.titleLabel.text = Text.Placeholder.homeControllerEmptyState
        configureCollectionView()
        configureRefresherControl()
        applySnapshot(animatingDifferences: false)
        fetchBookLists()
    }
    
    // MARK: - Setup
    private func configureCollectionView() {
        collectionView.dataSource = dataSource
        collectionView.register(cell: CategoryCollectionViewCell.self)
        collectionView.register(cell: BookCollectionViewCell.self)
        collectionView.register(cell: DetailedBookCollectionViewCell.self)
        collectionView.register(header: HeaderSupplementaryView.self)
        collectionView.delegate = self
    }
    
    private func configureRefresherControl() {
        refresherControl.addTarget(self, action: #selector(fetchBookLists), for: .valueChanged)
    }
    
    // MARK: - Api call
    @objc private func fetchBookLists() {
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
    }
    
    private func getBooks(for query: BookQuery, completion: @escaping ([Item]) -> Void) {
        showIndicator(activityIndicator)
        
        libraryService.getBookList(for: query, limit: 10, forMore: false) { [weak self] result in
            guard let self = self else { return }
            self.hideIndicator(self.activityIndicator)
            self.refresherControl.endRefreshing()
            switch result {
            case .success(let books):
                completion(books)
            case .failure(let error):
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
    
    // MARK: - Targets
    @objc private func showMoreButtonAction(_ sender: UIButton) {
        let section = HomeCollectionViewSections(rawValue: sender.tag)
        section == .categories ? showCategories() : showBookList(for: section?.sectionDataQuery)
    }
    
    // MARK: - Navigation
    private func showBookList(for query: BookQuery?, title: String? = nil) {
        guard let query = query else { return }
        let bookListVC = BookLibraryViewController(currentQuery: query,
                                                   queryService: QueryService(),
                                                   libraryService: LibraryService(),
                                                   layoutComposer: ListLayout())
        bookListVC.title = title
        navigationController?.show(bookListVC, sender: nil)
    }
    
    private func showCategories() {
        let categoryListVC = CategoriesViewController(settingBookCategory: false, categoryService: CategoryService())
        navigationController?.show(categoryListVC, sender: nil)
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
                    cell.configure(text: category.name)
                    return cell
                }
            case .newEntry, .favorites:
                if let book = item as? Item {
                    let cell: BookCollectionViewCell = collectionView.dequeue(for: indexPath)
                    cell.configure(with: book)
                    return cell
                }
            case .recommanding:
                if let book = item as? Item {
                    let cell: DetailedBookCollectionViewCell = collectionView.dequeue(for: indexPath)
                    cell.configure(with: book)
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
            showBookDetails(for: book, searchType: .librarySearch)
        }
    }
}
