//
//  NewViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit
import PanModal
import Alamofire
import Kingfisher

protocol NewBookDelegate: AnyObject {
    var newBook: Item? { get set }
    var bookDescription: String? { get set }
    var bookComment: String? { get set }
    func setCategories(with: [String])
}

class NewBookViewController: CommonStaticTableViewController, NewBookDelegate {
   
    // MARK: - Properties
    private let resultController  = SearchViewController(networkService: ApiManager())
    private var searchController  = UISearchController()
    private let activityIndicator = UIActivityIndicatorView()
    
    weak var bookCardDelegate  : BookCardDelegate?
    private var libraryService : LibraryServiceProtocol
    private var imagePicker    : ImagePicker?
    private var chosenLanguage : String?
    private var bookCategories : [String] = [] {
        didSet {
            let joinedList = bookCategories.joined(separator: ", ").capitalized
            bookCategoryCell.textLabel?.text = bookCategories.isEmpty ? Text.ControllerTitle.category : joinedList
        }
    }
    
    var isEditingBook  = false
    var bookDescription: String?
    var bookComment    : String?
    var newBook: Item? {
        didSet {
            displayBookDetail()
        }
    }
    // MARK: - Subviews
    private let bookImageCell  = ImageStaticCell()
    private let bookTileCell   = TextFieldStaticCell(placeholder: Text.Book.bookName)
    private let bookAuthorCell = TextFieldStaticCell(placeholder: Text.Book.authorName)
 
    private lazy var bookCategoryCell = createDefaultCell(with: Text.Book.bookCategories)
    
    private let publisherCell   = TextFieldStaticCell(placeholder: Text.Book.publisher)
    private let publishDateCell = TextFieldStaticCell(placeholder: Text.Book.publishedDate)
    
    private let isbnCell             = TextFieldStaticCell(placeholder: Text.Book.isbn, keyboardType: .numberPad)
    private let numberOfPagesCell    = TextFieldStaticCell(placeholder: Text.Book.numberOfPages, keyboardType: .numberPad)
    private let languageCell         = LanguageChoiceStaticCell(placeholder: Text.Book.bookLanguage)
    private lazy var descriptionCell = createDefaultCell(with: Text.Book.bookDescription)
    
    private let purchasePriceCell = TextFieldStaticCell(placeholder: Text.Book.price, keyboardType: .decimalPad)
    private let resellPriceCell   = TextFieldStaticCell(placeholder: Text.Book.resellPrice, keyboardType: .decimalPad)
    private let ratingCell        = RatingInputStaticCell(placeholder: Text.Book.rating)
    private let saveButtonCell    = ButtonStaticCell(title: Text.ButtonTitle.save,
                                                     systemImage: "arrow.down.doc.fill",
                                                     tintColor: .appTintColor,
                                                     backgroundColor: .appTintColor)
    private lazy var textFields = [bookTileCell.textField,
                                   bookAuthorCell.textField,
                                   publisherCell.textField,
                                   publishDateCell.textField,
                                   isbnCell.textField,
                                   numberOfPagesCell.textField,
                                   purchasePriceCell.textField]
    private let languageList = Locale.isoLanguageCodes
    
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
        setDelegates()
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        addNavigationBarButtons()
        composeTableView()
        configureSearchController()
        setButtonTargets()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let newBook = newBook else { return }
        setLanguage(for: newBook)
    }
    // MARK: - Setup
    private func addNavigationBarButtons() {
        let scannerButton = UIBarButtonItem(image: Images.scanBarcode,
                                            style: .plain,
                                            target: self,
                                            action: #selector(showScannerController))
        let activityIndicactorButton = UIBarButtonItem(customView: activityIndicator)
        navigationItem.rightBarButtonItems = isEditingBook ? [activityIndicactorButton] : [scannerButton, activityIndicactorButton]
    }
    
    private func configureUI() {
        view.backgroundColor = .viewControllerBackgroundColor
        title = isEditingBook ? Text.ControllerTitle.modify : Text.ControllerTitle.newBook
        self.navigationItem.searchController = isEditingBook ? nil : searchController
    }
    private func setDelegates() {
        textFields.forEach { $0.delegate = self }
        languageCell.pickerView.delegate = self
        languageCell.pickerView.dataSource = self
    }
    
    private func setButtonTargets() {
        saveButtonCell.actionButton.addTarget(self, action: #selector(saveBook), for: .touchUpInside)
    }
    
    /// Compose tableView cells and serctions using a 2 dimensional array of cells in  sections.
    private func composeTableView() {
        sections = [[bookImageCell],
                    [bookTileCell, bookAuthorCell],
                    [bookCategoryCell],
                    [publisherCell, publishDateCell],
                    [descriptionCell, numberOfPagesCell, languageCell, isbnCell],
                    [ratingCell],
                    [purchasePriceCell, resellPriceCell],
                    [saveButtonCell]
        ]
    }
    
    private func configureSearchController() {
        searchController = UISearchController(searchResultsController: resultController)
        searchController.searchBar.delegate                   = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder                = Text.SearchBarPlaceholder.search
        searchController.definesPresentationContext           = false
        resultController.newBookDelegate                      = self
        self.navigationItem.hidesSearchBarWhenScrolling       = false
    }
    
    // MARK: - Data
    func displayBookDetail() {
        guard let book = newBook else { return }
        clearData()
        bookTileCell.textField.text      = book.volumeInfo?.title
        bookAuthorCell.textField.text    = book.volumeInfo?.authors?.joined(separator: ", ")
        publisherCell.textField.text     = book.volumeInfo?.publisher
        publishDateCell.textField.text   = book.volumeInfo?.publishedDate?.displayYearOnly()
        isbnCell.textField.text          = book.volumeInfo?.industryIdentifiers?.first?.identifier
        bookDescription                  = book.volumeInfo?.volumeInfoDescription
        numberOfPagesCell.textField.text = "\(book.volumeInfo?.pageCount ?? 0)"
        
        displayCategories(for: book)
        displayBookCover(for: book)
        displayBookPrice(for: book)
        displayRating(for: book)
        setLanguage(for: book)
    }
    
    private func displayBookCover(for book: Item) {
        if let url = book.volumeInfo?.imageLinks?.thumbnail,
           let imageURL = URL(string: url) {
            
            KingfisherManager.shared.retrieveImage(with: imageURL,
                                                   options: [.cacheOriginalImage, .progressiveJPEG(.default)],
                                                   progressBlock: nil) { result in
                if case .success(let value) = result {
                    self.bookImageCell.pictureView.image = value.image
                }
            }
        }
    }
    
    private func displayCategories(for book: Item) {
        if let categories = book.volumeInfo?.categories {
            bookCategories = categories
        }
    }
    
    private func displayBookPrice(for book: Item) {
        if let price = book.saleInfo?.retailPrice?.amount {
            purchasePriceCell.textField.text = "\(price)"
        }
    }
    
    private func displayRating(for book: Item) {
        if let rating = book.volumeInfo?.ratingsCount {
            ratingCell.ratingSegmentedControl.selectedSegmentIndex = rating
        }
    }
    
    private func setLanguage(for book: Item) {
        guard let code = book.volumeInfo?.language else { return }
        if let index = languageList.firstIndex(where: { $0.lowercased() == code.lowercased() }) {
            languageCell.pickerView.selectRow(index, inComponent: 0, animated: false)
            self.pickerView(self.languageCell.pickerView, didSelectRow: index, inComponent: 0)
        }
    }
    
    func setCategories(with categories: [String]) {
        bookCategories = categories
    }
    
    private func clearData() {
        searchController.isActive = false
        bookImageCell.pictureView.image = Images.emptyStateBookImage
        bookComment = nil
        bookDescription = nil
        bookCategories.removeAll()
        resultController.searchedBooks.removeAll()
        textFields.forEach { $0.text = nil }
        ratingCell.ratingSegmentedControl.selectedSegmentIndex = 0
        tableView.setContentOffset(.zero, animated: true)
    }
    
    // MARK: Api Call
    @objc private func saveBook() {
        saveButtonCell.displayActivityIndicator(true)
        guard let book = createBookDocument() else { return }
        guard let imageData = bookImageCell.pictureView.image?.jpegData(.high) else { return }
        
        libraryService.createBook(with: book, and: imageData) { [weak self] error in
            guard let self = self else { return }
            self.saveButtonCell.displayActivityIndicator(false)
            if let error = error {
                self.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            self.presentAlertBanner(as: .success, subtitle: Text.Book.bookSaved)
            self.isEditingBook ? self.returnToPreviousController() : self.clearData()
        }
    }
    
    private func createBookDocument() -> Item? {
        let isbn = isbnCell.textField.text ?? ""
        let volumeInfo = VolumeInfo(title: bookTileCell.textField.text,
                                    authors: [bookAuthorCell.textField.text ?? ""],
                                    publisher: publisherCell.textField.text ?? "",
                                    publishedDate: publishDateCell.textField.text ?? "",
                                    volumeInfoDescription: bookDescription,
                                    industryIdentifiers: [IndustryIdentifier(identifier: isbn)],
                                    pageCount: Int(numberOfPagesCell.textField.text ?? "0"),
                                    categories: bookCategories,
                                    ratingsCount: ratingCell.ratingSegmentedControl.selectedSegmentIndex,
                                    imageLinks: ImageLinks(thumbnail: newBook?.volumeInfo?.imageLinks?.thumbnail),
                                    language: chosenLanguage ?? "")
        let price = Double(purchasePriceCell.textField.text?.formatDecimalString ?? "0")
        let saleInfo = SaleInfo(retailPrice: SaleInfoListPrice(amount: price,
                                                               currencyCode: newBook?.saleInfo?.retailPrice?.currencyCode ?? "EUR"))
        return Item(etag: newBook?.etag ?? "",
                    favorite: newBook?.favorite ?? false,
                    ownerID: newBook?.ownerID ?? "",
                    recommanding: newBook?.recommanding ?? false,
                    volumeInfo: volumeInfo,
                    saleInfo: saleInfo,
                    timestamp: newBook?.timestamp ?? Date().timeIntervalSince1970)
    }
    
    // MARK: - Navigation
    @objc private func showScannerController() {
        let barcodeScannerController = BarcodeScannerViewController()
        barcodeScannerController.barcodeDelegate = self
        presentPanModal(barcodeScannerController)
    }
    
    @objc func returnToPreviousController() {
        bookCardDelegate?.fetchBookUpdate()
        clearData()
        navigationController?.popViewController(animated: true)
    }
    
    private func showCategoryList() {
        let categoryListVC = CategoriesViewController()
        categoryListVC.newBookDelegate    = self
        categoryListVC.selectedCategories = bookCategories
        navigationController?.pushViewController(categoryListVC, animated: true)
    }
    
    private func presentTextInputController(for inputType: TextInputType) {
        let textInputViewController = TextInputViewController()
        textInputViewController.newBookDelegate = self
        textInputViewController.textInpuType    = inputType
        textInputViewController.textViewText    = inputType == .description ? bookDescription : bookComment
        navigationController?.pushViewController(textInputViewController, animated: true)
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
                imagePicker?.present(from: bookImageCell.pictureView)
            }
        case 2:
            if indexPath.row == 0 {
                showCategoryList()
            }
        case 4:
            if indexPath.row == 0 {
                presentTextInputController(for: .description)
            }
        default:
            return
        }
    }
}
// MARK: - ImagePicker Delegate
extension NewBookViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        bookImageCell.pictureView.image = image?.resizeImage()
    }
}
// MARK: - UIPickerDelegate
extension NewBookViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
            pickerLabel?.textAlignment = .left
        }
        pickerLabel?.text = "  " + languageList[row].languageName.capitalized
        pickerLabel?.textColor = .label
        
        return pickerLabel!
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languageList.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chosenLanguage = languageList[row]
    }
}
