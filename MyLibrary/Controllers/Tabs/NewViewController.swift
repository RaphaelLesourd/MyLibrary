//
//  NewViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit

class NewViewController: UIViewController {

    // MARK: - Properties
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .viewControllerBackgroundColor
        configureSearchController()
        addScannerButton()
    }

    // MARK: - Setup
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
extension NewViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
           return
        }
        searchController.searchBar.text = nil
        searchController.isActive = false
    }
}
// MARK: - Barcode procol
extension NewViewController: BarcodeProtocol {
    
    func processBarcode(with code: String) {
        presentAlert(withTitle: "New Found barcode", message: code, actionHandler: nil)
    }
}
