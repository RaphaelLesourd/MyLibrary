//
//  SettingsViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit

class SearchViewController: UIViewController {

    // MARK: - Properties
    private var layoutComposer = LayoutComposer()
    
    // MARK: - Subviews
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .viewControllerBackgroundColor
        configureCollectionView()
        setCollectionViewConstraints()
        configureSearchController()
        addScannerButton()
    }

    // MARK: - Setup
    private func configureCollectionView() {
        let layout = layoutComposer.composeSearchCollectionViewLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HorizontalCollectionViewCell.self,
                                forCellWithReuseIdentifier: HorizontalCollectionViewCell.reuseIdentifier)
        collectionView.register(HeaderSupplementaryView.self,
                                forSupplementaryViewOfKind: HeaderSupplementaryView.kind,
                                withReuseIdentifier: HeaderSupplementaryView.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureSearchController() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Recherche"
        searchController.definesPresentationContext = true
        searchController.automaticallyShowsSearchResultsController = true
        self.navigationItem.searchController = searchController
    }
    
    private func addScannerButton() {
        let infoButton = UIBarButtonItem(image: UIImage(systemName: "barcode.viewfinder"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(showScannerController))
        navigationItem.rightBarButtonItem = infoButton
    }
    
    // MARK: - Navigation
    @objc private func showScannerController() {
        let barcodeScannerController = BarcodeScannerViewController()
        barcodeScannerController.hidesBottomBarWhenPushed = true
        barcodeScannerController.barcodeDelegate = self
        navigationController?.pushViewController(barcodeScannerController, animated: true)
    }
}
// MARK: - Search result updater
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
           return
        }
        searchController.searchBar.text = nil
        searchController.isActive = false
    }
}
// MARK: - CollectionView Datasource
extension SearchViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SearchCollectionViewSections.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch SearchCollectionViewSections(rawValue: section) {
        case .librarySearch:
            return 3
        case .apiSearch:
            return 10
        case nil:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch SearchCollectionViewSections(rawValue: indexPath.section) {
        case .librarySearch, .apiSearch:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalCollectionViewCell.reuseIdentifier,
                                                                for: indexPath) as? HorizontalCollectionViewCell  else {
                return UICollectionViewCell()
            }
            cell.configure()
            return cell
        case nil:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                               withReuseIdentifier: HeaderSupplementaryView.reuseIdentifier,
                                                                               for: indexPath) as? HeaderSupplementaryView else {
            return HeaderSupplementaryView()
        }
        switch SearchCollectionViewSections(rawValue: indexPath.section) {
        case .librarySearch:
            headerView.configureTitle(with: "Dans mes livres")
        case .apiSearch:
            headerView.configureTitle(with: "Trouvé en ligne")
        case .none:
            break
        }
        headerView.actionButton.isHidden = true
        return headerView
    }
}
// MARK: - CollectionView Delegate
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      showBookDetails()
    }
}
// MARK: - Barcode procol
extension SearchViewController: BarcodeProtocol {
    
    func processBarcode(with code: String) {
        presentAlert(withTitle: "Found barcode", message: code, actionHandler: nil)
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
