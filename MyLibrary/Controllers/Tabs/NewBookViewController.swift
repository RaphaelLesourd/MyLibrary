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
    private let resultController = SearchViewController(networkService: ApiManager())
    private var libraryService: LibraryServiceProtocol
    private var imagePicker: ImagePicker?
    var isEditingBook = false
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
    private lazy var  textFields = [bookTileCell.textField,
                                    bookAuthorCell.textField,
                                    bookCategoryCell.textField,
                                    isbnCell.textField,
                                    numberOfPagesCell.textField,
                                    languageCell.textField,
                                    purchasePriceCell.textField]
    
    init(libraryService: LibraryServiceProtocol) {
        self.libraryService = libraryService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        configureUI()
        composeTableView()
        configureSearchController()
        setButtonTargets()
        setDelegates()
    }

    // MARK: - Setup
    private func configureUI() {
        view.backgroundColor = .viewControllerBackgroundColor
        title = isEditingBook ? "Modifier" : Text.ControllerTitle.newBook
        let scannerButton = UIBarButtonItem(image: Images.scanBarcode,
                                         style: .plain,
                                         target: self,
                                         action: #selector(showScannerController))
        navigationItem.rightBarButtonItem = isEditingBook ? nil : scannerButton
        self.navigationItem.searchController = isEditingBook ? nil : searchController
    }
    private func setDelegates() {
        textFields.forEach { $0.delegate = self }
    }

    private func setButtonTargets() {
        saveButtonCell.actionButton.addTarget(self, action: #selector(saveBook), for: .touchUpInside)
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
    }
   
    // MARK: - Data
    func displayBookDetail() {
        guard let book = newBook else { return }
        clearData()
        bookTileCell.textField.text = book.volumeInfo?.title
        bookAuthorCell.textField.text = book.volumeInfo?.authors?.joined(separator: " ")
        bookCategoryCell.textField.text = book.volumeInfo?.categories?.first
        isbnCell.textField.text = "\(book.volumeInfo?.industryIdentifiers?.first?.identifier ?? "--")"
        numberOfPagesCell.textField.text = "\(book.volumeInfo?.pageCount ?? 0)"
        languageCell.textField.text = book.volumeInfo?.language
        bookDescription = book.volumeInfo?.volumeInfoDescription
        if let url = book.volumeInfo?.imageLinks?.thumbnail, let imageUrl = URL(string: url) {
            bookImageCell.pictureView.af.setImage(withURL: imageUrl,
                                            cacheKey: book.volumeInfo?.industryIdentifiers?.first?.identifier,
                                            placeholderImage: Images.emptyStateBookImage)
        }
        if let price = book.saleInfo?.retailPrice?.amount {
            purchasePriceCell.textField.text = "\(price)"
        }
    }
    
    @objc private func saveBook() {
        guard let book = createBookDocument() else { return }
        saveButtonCell.displayActivityIndicator(true)
        libraryService.createBook(with: book, completion: { [weak self] error in
            guard let self = self else { return }
            self.saveButtonCell.displayActivityIndicator(false)
            if let error = error {
                self.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            self.presentAlertBanner(as: .success, subtitle: "Livre enregistré.")
        })
        isEditingBook ? returnToPreviousController() :  clearData()
    }
    
    private func createBookDocument() -> Item? {
        guard let newBook = newBook else { return nil }
        let isbn = isbnCell.textField.text ?? UUID().uuidString
        let volumeInfo = VolumeInfo(title: bookTileCell.textField.text,
                                    authors: [bookAuthorCell.textField.text ?? ""],
                                    publisher: newBook.volumeInfo?.publisher,
                                    publishedDate: newBook.volumeInfo?.publishedDate,
                                    volumeInfoDescription: bookDescription,
                                    industryIdentifiers: [IndustryIdentifier(identifier: isbn)],
                                    pageCount: Int(numberOfPagesCell.textField.text ?? "0"),
                                    categories: [bookCategoryCell.textField.text ?? ""],
                                    ratingsCount: newBook.volumeInfo?.ratingsCount,
                                    imageLinks: ImageLinks(smallThumbnail: newBook.volumeInfo?.imageLinks?.smallThumbnail,
                                                           thumbnail: newBook.volumeInfo?.imageLinks?.thumbnail),
                                    language: languageCell.textField.text ?? "--")
        let saleInfo = SaleInfo(retailPrice: SaleInfoListPrice(amount: Double(purchasePriceCell.textField.text ?? "0"),
                                                               currencyCode: newBook.saleInfo?.retailPrice?.currencyCode))
        return Item(etag: isbn, volumeInfo: volumeInfo, saleInfo: saleInfo)
    }
    
    private func clearData() {
        searchController.isActive = false
        resultController.searchedBooks.removeAll()
        bookImageCell.pictureView.image = Images.emptyStateBookImage
        bookComment = nil
        bookDescription = nil
        textFields.forEach { $0.text = nil }
    }
    
    // MARK: - Navigation
    @objc private func showScannerController() {
        let barcodeScannerController = BarcodeScannerViewController()
        barcodeScannerController.barcodeDelegate = self
        presentPanModal(barcodeScannerController)
    }
    
    @objc func returnToPreviousController() {
        clearData()
        navigationController?.popViewController(animated: true)
    }
}
// MARK: - TextField Delegate
extension NewBookViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
