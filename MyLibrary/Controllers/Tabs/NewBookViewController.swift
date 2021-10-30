//
//  NewViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit
import PanModal
import AlamofireImage

protocol NewBookDelegate: AnyObject {
    func displayBookDetail(for book: Item?)
    var bookDescription: String? { get set }
    var bookComment: String? { get set }
}

class NewBookViewController: UITableViewController, NewBookDelegate {
   
    // MARK: - Properties
    var newBook: Item?
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
        addSearchButton()
    }

    // MARK: - Setup
    private func addSearchButton() {
        let infoButton = UIBarButtonItem(image: Images.searchIcon,
                                         style: .plain,
                                         target: self,
                                         action: #selector(showSearchController))
        navigationItem.rightBarButtonItem = infoButton
    }
    
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
   
    private func createDefaultCell(with text: String) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = text
        cell.backgroundColor = .tertiarySystemBackground
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    // MARK: - Data
    func displayBookDetail(for book: Item?) {
        guard let book = book else { return }
        newBook = book
        bookTileCell.textField.text = newBook?.volumeInfo?.title
        bookAuthorCell.textField.text = newBook?.volumeInfo?.authors?.joined(separator: " ")
        isbnCell.textField.text = "ISBN \(newBook?.volumeInfo?.industryIdentifiers?.first?.identifier ?? "--")"
        numberOfPagesCell.textField.text = "\(newBook?.volumeInfo?.pageCount ?? 0) pages"
        languageCell.textField.text = newBook?.volumeInfo?.language?.languageName
        bookDescription = newBook?.volumeInfo?.volumeInfoDescription
        if let url = newBook?.volumeInfo?.imageLinks?.thumbnail, let imageUrl = URL(string: url) {
            bookImage.bookImage.af.setImage(withURL: imageUrl,
                                            cacheKey: newBook?.volumeInfo?.industryIdentifiers?.first?.identifier,
                                            placeholderImage: Images.welcomeScreen)
        }
        if let currency = book.saleInfo?.retailPrice?.currencyCode,
           let price = book.saleInfo?.retailPrice?.amount {
            purchasePriceCell.textField.text = "\(currency.currencySymbol) \(price)"
        }
    }
    
    // MARK: - Navigation
    @objc private func showSearchController() {
        let searchController = SearchViewController(networkService: NetworkService())
        searchController.hidesBottomBarWhenPushed = true
        searchController.newBookBookDelegate = self
        searchController.searchType = .apiSearch
        navigationController?.pushViewController(searchController, animated: true)
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
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                print("show image picker")
            }
        case 2:
            if indexPath.row == 0 {
                presentTextInputController(for: .description)
            }
        case 4:
            if indexPath.row == 0 {
                presentTextInputController(for: .comment)
            }
        default:
            return
        }
    }
    
    private func presentTextInputController(for inputType: TextInputType) {
        let textInputViewController = TextInputViewController()
        textInputViewController.newBookDelegate = self
        textInputViewController.textInpuType = inputType
        textInputViewController.textViewText = inputType == .description ? bookDescription : bookComment
        presentPanModal(textInputViewController)
    }
}
