//
//  NewViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit
import PanModal
import SwiftUI

protocol NewBookDelegate: AnyObject {
    var bookDescription: String? { get set }
    var bookComment: String? { get set }
}

class NewBookViewController: UITableViewController, NewBookDelegate {
    // MARK: - Properties
    var bookDescription: String?
    var bookComment: String?
    private var sections: [[UITableViewCell]] = [[]]
    
    // MARK: - Subviews
    private let searchController = UISearchController(searchResultsController: nil)
    private let bookImage = ImageStaticCell()
    private let bookTileCell = TextFieldStaticCell(placeholder: "Titre du livre")
    private let bookAuthorCell = TextFieldStaticCell(placeholder: "Nom de l'auteur")
    private let isbnCell = TextFieldStaticCell(placeholder: "ISBN", keyboardType: .numberPad)
    private let numberOfPagesCell = TextFieldStaticCell(placeholder: "Nombre de pages", keyboardType: .numberPad)
    private let languageCell = TextFieldStaticCell(placeholder: "Langue du livre")
    private let saveButtonCell = ButtonStaticCell(title: "Enregistrer", systemImage: "arrow.down.doc.fill", tintColor: .appTintColor)
    private var descriptionCell = UITableViewCell()
    private let purchasePriceCell = TextFieldStaticCell(placeholder: "Prix d'achat", keyboardType: .numberPad)
    private let resellPriceCell = TextFieldStaticCell(placeholder: "Côte actuelle", keyboardType: .numberPad)
    private var commentCell = UITableViewCell()
   
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .viewControllerBackgroundColor
        title = Text.ControllerTitle.newBook
        configureTableView()
        configureCells()
        configureSearchController()
        addScannerButton()
    }

    // MARK: - Setup
    private func configureTableView() {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .viewControllerBackgroundColor
    }
    
    private func configureCells() {
        descriptionCell = createDefaultCell(with: "Description")
        commentCell = createDefaultCell(with: "Commentaire")
        sections = [[bookImage],
                    [bookTileCell, bookAuthorCell],
                    [descriptionCell, numberOfPagesCell, languageCell, isbnCell],
                    [purchasePriceCell, resellPriceCell],
                    [commentCell],
                    [saveButtonCell]
        ]
    }
    
    private func configureSearchController() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Recherche"
        searchController.definesPresentationContext = true
        searchController.automaticallyShowsSearchResultsController = true
        self.navigationItem.searchController = searchController
    }
    
    private func addScannerButton() {
        let infoButton = UIBarButtonItem(image: Images.scanBarcode,
                                         style: .plain,
                                         target: self,
                                         action: #selector(showScannerController))
        navigationItem.rightBarButtonItem = infoButton
    }
    
    private func createDefaultCell(with text: String) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = text
        cell.backgroundColor = .tertiarySystemBackground
        cell.accessoryType = .disclosureIndicator
        return cell
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
extension NewBookViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
           return
        }
        searchController.searchBar.text = nil
        searchController.isActive = false
    }
}
// MARK: - Barcode protocol
extension NewBookViewController: BarcodeProtocol {
    
    func processBarcode(with code: String) {
        presentAlert(withTitle: "New Found barcode", message: code, actionHandler: nil)
    }
}
// MARK: - TableView DataSource & Delegate
extension NewBookViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return sections[indexPath.section][indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let textInputViewController = TextInputViewController()
        textInputViewController.newBookDelegate = self
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                print("show image picker")
            }
        case 2:
            if indexPath.row == 0 {
                textInputViewController.textInpuType = .description
                textInputViewController.textViewText = bookDescription
                presentPanModal(textInputViewController)
            }
        case 4:
            if indexPath.row == 0 {
                textInputViewController.textInpuType = .comment
                textInputViewController.textViewText = bookComment
                presentPanModal(textInputViewController)
            }
        default:
            return
        }
    }
}
