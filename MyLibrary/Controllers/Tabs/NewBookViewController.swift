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
    var newBook: Item? { get set }
    var bookDescription: String? { get set }
    var bookComment: String? { get set }
}

class NewBookViewController: StaticTableViewController, NewBookDelegate {
   
    // MARK: - Properties
    private var searchController = UISearchController()
    private let resultController = SearchViewController(networkService: NetworkService())
    private var imagePicker: ImagePicker?
    var bookDescription: String?
    var bookComment: String?
    var newBook: Item? {
        didSet {
            displayBookDetail()
        }
    }
   
    // MARK: - Subviews
    private let bookImageCell = ImageStaticCell()
    private let bookTileCell = TextFieldStaticCell(placeholder: "Titre du livre")
    private let bookAuthorCell = TextFieldStaticCell(placeholder: "Nom de l'auteur")
    private let bookCategoryCell = TextFieldStaticCell(placeholder: "Catégorie")
    
    private let isbnCell = TextFieldStaticCell(placeholder: "ISBN", keyboardType: .numberPad)
    private let numberOfPagesCell = TextFieldStaticCell(placeholder: "Nombre de pages", keyboardType: .numberPad)
    private let languageCell = TextFieldStaticCell(placeholder: "Langue du livre")
    private lazy var descriptionCell = createDefaultCell(with: "Description")
    
    private let purchasePriceCell = TextFieldStaticCell(placeholder: "Prix d'achat", keyboardType: .numberPad)
    private let resellPriceCell = TextFieldStaticCell(placeholder: "Côte actuelle", keyboardType: .numberPad)
    
    private lazy var commentCell = createDefaultCell(with: "Commentaire")
    private let saveButtonCell = ButtonStaticCell(title: "Enregistrer",
                                                  systemImage: "arrow.down.doc.fill",
                                                  tintColor: .appTintColor,
                                                  backgroundColor: .appTintColor)
   
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .viewControllerBackgroundColor
        title = Text.ControllerTitle.newBook
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        composeTableView()
        configureSearchController()
        addNavigationBarButton()
        setButtonTargets()
    }

    // MARK: - Setup
    private func addNavigationBarButton() {
        let scannerButton = UIBarButtonItem(image: Images.scanBarcode,
                                         style: .plain,
                                         target: self,
                                         action: #selector(showScannerController))
        navigationItem.rightBarButtonItem = scannerButton
    }
    
    private func setButtonTargets() {
        saveButtonCell.actionButton.addTarget(self, action: #selector(showBookCardViewController), for: .touchUpInside)
    }

    /// Compose tableView cells and serctions using a 2 dimensional array of cells in  sections.
    private func composeTableView() {
        sections = [[bookImageCell],
                    [bookTileCell, bookAuthorCell],
                    [bookCategoryCell],
                    [descriptionCell, numberOfPagesCell, languageCell, isbnCell],
                    [purchasePriceCell, resellPriceCell],
                    [commentCell],
                    [saveButtonCell]
        ]
    }
    
    private func configureSearchController() {
        searchController = UISearchController(searchResultsController: resultController)
        searchController.searchBar.delegate = self
        resultController.newBookDelegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Recherche"
        searchController.definesPresentationContext = false
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = searchController
    }
   
    // MARK: - Data
    func displayBookDetail() {
        guard let book = newBook else { return }
        clearData()
        bookTileCell.textField.text = book.volumeInfo?.title
        bookAuthorCell.textField.text = book.volumeInfo?.authors?.joined(separator: " ")
        bookCategoryCell.textField.text = book.volumeInfo?.categories?.first
        isbnCell.textField.text = "ISBN \(book.volumeInfo?.industryIdentifiers?.first?.identifier ?? "--")"
        numberOfPagesCell.textField.text = "\(book.volumeInfo?.pageCount ?? 0) pages"
        languageCell.textField.text = book.volumeInfo?.language?.languageName
        bookDescription = book.volumeInfo?.volumeInfoDescription
        if let url = book.volumeInfo?.imageLinks?.thumbnail, let imageUrl = URL(string: url) {
            bookImageCell.pictureView.af.setImage(withURL: imageUrl,
                                            cacheKey: book.volumeInfo?.industryIdentifiers?.first?.identifier,
                                            placeholderImage: Images.emptyStateBookImage)
        }
        if let currency = book.saleInfo?.retailPrice?.currencyCode,
           let price = book.saleInfo?.retailPrice?.amount {
            purchasePriceCell.textField.text = "\(currency.currencySymbol) \(price)"
        }
    }
    
    private func clearData() {
        searchController.isActive = false
        resultController.searchedBooks.removeAll()
        bookTileCell.textField.text = nil
        bookAuthorCell.textField.text = nil
        bookCategoryCell.textField.text = nil
        isbnCell.textField.text = nil
        numberOfPagesCell.textField.text = nil
        languageCell.textField.text = nil
        bookDescription = nil
        bookImageCell.pictureView.image = Images.emptyStateBookImage
        purchasePriceCell.textField.text = nil
        bookComment = nil
        bookDescription = nil
    }
    
    // MARK: - Navigation
    @objc private func showScannerController() {
        let barcodeScannerController = BarcodeScannerViewController()
        barcodeScannerController.barcodeDelegate = self
        presentPanModal(barcodeScannerController)
    }
    
    @objc private func showBookCardViewController() {
        guard let book = newBook else { return }
        showBookDetails(with: book, searchType: .librarySearch)
        clearData()
    }
}
// MARK: - Barcode protocol
extension NewBookViewController: BarcodeProtocol {
    func processBarcode(with code: String) {
        resultController.searchType = .barCodeSearch
        resultController.currentSearchKeywords = code
    }
}
// MARK: - Searchbar delegate
extension NewBookViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        resultController.searchedBooks.removeAll()
        resultController.searchType = .apiSearch
        resultController.currentSearchKeywords = searchController.searchBar.text ?? ""
    }
}

// MARK: - TableView DataSource & Delegate
extension NewBookViewController {
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                self.imagePicker?.present(from: bookImageCell.pictureView)
            }
        case 3:
            if indexPath.row == 0 {
                presentTextInputController(for: .description)
            }
        case 5:
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
// MARK: - ImagePicker Delegate
extension NewBookViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        self.bookImageCell.pictureView.image = image
    }
}