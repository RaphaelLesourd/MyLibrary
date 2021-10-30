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
    private var layoutComposer = LayoutComposer()
    private lazy var dataSource = makeDataSource()
    typealias Snapshot = NSDiffableDataSourceSnapshot<SearchType, Item>
    typealias DataSource = UICollectionViewDiffableDataSource<SearchType, Item>
    weak var newBookBookDelegate: NewBookDelegate?
    
    var searchType: SearchType?
    private var searchedBooks: [Item] = []
    
    // MARK: - Subviews
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private let searchController = UISearchController(searchResultsController: nil)
    
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
        configureSearchController()
        addScannerButton()
        applySnapshot(animatingDifferences: false)
    }
    
    // MARK: - Setup
    func configureSearchController() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Recherche"
        searchController.definesPresentationContext = true
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = searchController
    }
    
    private func addScannerButton() {
        let infoButton = UIBarButtonItem(image: Images.scanBarcode,
                                         style: .plain,
                                         target: self,
                                         action: #selector(showScannerController))
        navigationItem.rightBarButtonItem = infoButton
    }
    
    private func configureCollectionView() {
        let layout = layoutComposer.composeBookLibraryLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(VerticalCollectionViewCell.self,
                                forCellWithReuseIdentifier: VerticalCollectionViewCell.reuseIdentifier)
        collectionView.register(HeaderSupplementaryView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HeaderSupplementaryView.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = makeDataSource()
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - API call
    private func getBooks(_ query: AlamofireRouter) {
        networkService.getData(with: query) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let books):
                guard let books = books.items else { return }
                self.searchedBooks = books
                self.applySnapshot()
            case .failure(let error):
                self.presentAlertBanner(as: .error, subtitle: error.localizedDescription)
            }
        }
    }
   
    // MARK: - Navigation
    @objc private func showScannerController() {
        let barcodeScannerController = BarcodeScannerViewController()
        barcodeScannerController.hidesBottomBarWhenPushed = true
        barcodeScannerController.barcodeDelegate = self
        navigationController?.pushViewController(barcodeScannerController, animated: true)
    }
    
    private func returnToNewBookController(with book: Item) {
        newBookBookDelegate?.displayBookDetail(for: book)
        navigationController?.popViewController(animated: true)
    }
}
// MARK: - CollectionView Datasource
extension SearchViewController {
  
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, books) -> UICollectionViewCell? in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCollectionViewCell.reuseIdentifier,
                                                                    for: indexPath) as? VerticalCollectionViewCell else {
                    return UICollectionViewCell()
                }
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
            
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: HeaderSupplementaryView.reuseIdentifier,
                                                                       for: indexPath) as? HeaderSupplementaryView
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            let title = section == .librarySearch ? "Dans mes livres" : "\(self.searchedBooks.count) Trouvé en ligne"
            view?.configureTitle(with: title)
            view?.actionButton.isHidden = true
            return view
        }
    }
}
// MARK: - CollectionView Delegate
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let searchBook = dataSource.itemIdentifier(for: indexPath) else { return }
        searchType == .librarySearch ? showBookDetails(with: searchBook) : returnToNewBookController(with: searchBook)
    }
}
// MARK: - Barcode procol
extension SearchViewController: BarcodeProtocol {
    func processBarcode(with code: String) {
        getBooks(.withIsbn(isbn: code))
    }
}
// MARK: - Search result updater
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else { return }
        getBooks(.withKeyWord(words: searchText))
        searchController.isActive = false
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
