//
//  SettingsViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - Properties
    var networkService: NetworkProtocol
    weak var newBookDelegate: NewBookDelegate?
    var searchType: SearchType?
    private var layoutComposer = LayoutComposer()
    private lazy var dataSource = makeDataSource()
    typealias Snapshot = NSDiffableDataSourceSnapshot<SearchType, Item>
    typealias DataSource = UICollectionViewDiffableDataSource<SearchType, Item>
    var currentSearchKeywords = "" {
        didSet {
            getBooks(currentSearchKeywords, fromIndex: 0)
        }
    }
   
    var searchedBooks: [Item] = [] {
        didSet {
            applySnapshot()
        }
    }
    
    // MARK: - Subviews
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    // MARK: - Initializer
    init(networkService: NetworkProtocol) {
        self.networkService = networkService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .viewControllerBackgroundColor
        title = Text.ControllerTitle.search
        configureCollectionView()
        setCollectionViewConstraints()
        applySnapshot(animatingDifferences: false)
    }
    
    // MARK: - Setup
    private func configureCollectionView() {
        let layout = layoutComposer.composeBookLibraryLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(cell: VerticalCollectionViewCell.self)
        collectionView.register(header: HeaderSupplementaryView.self)
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - API call
    func getBooks(_ query: String?, fromIndex: Int = 0) {
        networkService.getData(with: query, fromIndex: fromIndex) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let books):
                self.handleList(for: books)
            case .failure(let error):
                self.presentAlertBanner(as: .error, subtitle: error.localizedDescription)
            }
        }
    }
    
    private func handleList(for books: BookModel) {
        guard let bookList = books.items, !bookList.isEmpty else {
            self.presentAlertBanner(as: .customMessage("Oups!"), subtitle: "Rien trouvé")
            return
        }
        bookList.count > 1 ? searchedBooks.append(contentsOf: bookList) : (newBookDelegate?.newBook = bookList.first)
    }
}
// MARK: - CollectionView Datasource
extension SearchViewController {
  
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, books) -> UICollectionViewCell? in
                let cell: VerticalCollectionViewCell = collectionView.dequeue(for: indexPath)
                cell.configure(with: books)
                return cell
            })
        configureHeader(dataSource)
        return dataSource
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.apiSearch])
        snapshot.appendItems(searchedBooks, toSection: .apiSearch)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func configureHeader(_ dataSource: SearchViewController.DataSource) {
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            let view: HeaderSupplementaryView = collectionView.dequeue(kind: kind, for: indexPath)
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            let title = section == .librarySearch ? "Dans mes livres" : ""
            view.configureTitle(with: title)
            view.actionButton.isHidden = true
            return view
        }
    }
}
// MARK: - CollectionView Delegate
extension SearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
            getBooks(currentSearchKeywords, fromIndex: indexPath.row - 1)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let searchBook = dataSource.itemIdentifier(for: indexPath) else { return }
        newBookDelegate?.newBook = searchBook
    }
}
// MARK: - Constraints
extension SearchViewController {
    private func setCollectionViewConstraints() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
}
