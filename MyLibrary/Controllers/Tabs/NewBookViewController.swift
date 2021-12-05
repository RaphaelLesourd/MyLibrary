//
//  NewViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit
import PanModal

protocol NewBookDelegate: AnyObject {
    var newBook: Item? { get set }
    var bookDescription: String? { get set }
    var bookComment: String? { get set }
    var bookCategories : [String] { get set }
}
/// Protocol to pass barcode string value back to the requesting controller.
protocol BarcodeProtocol: AnyObject {
    func processBarcode(with code: String)
}

class NewBookViewController: CommonStaticTableViewController, NewBookDelegate {
   
    // MARK: - Properties
    private let resultController = SearchViewController(networkService: ApiManager(), layoutComposer: ListLayout())
    private let newBookView      = NewBookControllerView()
    private let languageList     = Locale.isoLanguageCodes
    private let currencyList     = Locale.isoCurrencyCodes
    
    private let formatter     : FormatterProtocol
    private let validator     : ValidatorProtocol
    private let libraryService: LibraryServiceProtocol
    private let imageLoader   : ImageRetriverProtocol
    private var imagePicker   : ImagePicker?
    private var chosenLanguage: String?
    private var chosenCurrency: String?
    
    weak var bookCardDelegate: BookCardDelegate?
    var isEditingBook  = false
    var bookCategories : [String] = []
    var bookDescription: String?
    var bookComment    : String?
    var newBook: Item? {
        didSet {
            displayBookDetail()
        }
    }
   
    init(libraryService: LibraryServiceProtocol,
         formatter: FormatterProtocol,
         validator: ValidatorProtocol,
         imageLoader: ImageRetriverProtocol) {
        self.libraryService = libraryService
        self.formatter      = formatter
        self.validator      = validator
        self.imageLoader    = imageLoader
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        sections = newBookView.composeTableView()
        setDelegates()
        addNavigationBarButtons()
        configureSearchController()
        setButtonTargets()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setBookLanguage()
        setBookCurrency()
    }
    // MARK: - Setup
    private func addNavigationBarButtons() {
        let scannerButton = UIBarButtonItem(image: Images.scanBarcode,
                                            style: .plain,
                                            target: self,
                                            action: #selector(showScannerController))
        let activityIndicactorButton = UIBarButtonItem(customView: newBookView.activityIndicator)
        navigationItem.rightBarButtonItems = isEditingBook ? [activityIndicactorButton] : [scannerButton, activityIndicactorButton]
    }
    
    private func configureUI() {
        view.backgroundColor = .viewControllerBackgroundColor
        title = isEditingBook ? Text.ControllerTitle.modify : Text.ControllerTitle.newBook
        self.navigationItem.searchController = isEditingBook ? nil : newBookView.searchController
    }
    
    private func setDelegates() {
        newBookView.textFields.forEach { $0.delegate = self }
        newBookView.languageCell.pickerView.delegate   = self
        newBookView.languageCell.pickerView.dataSource = self
        newBookView.currencyCell.pickerView.delegate   = self
        newBookView.currencyCell.pickerView.dataSource = self
    }
    
    private func setButtonTargets() {
        newBookView.saveButtonCell.actionButton.addTarget(self, action: #selector(saveBook), for: .touchUpInside)
    }

    private func configureSearchController() {
        newBookView.searchController = UISearchController(searchResultsController: resultController)
        newBookView.searchController.searchBar.delegate                   = self
        newBookView.searchController.obscuresBackgroundDuringPresentation = false
        newBookView.searchController.searchBar.placeholder                = Text.SearchBarPlaceholder.search
        newBookView.searchController.definesPresentationContext           = false
        resultController.newBookDelegate = self
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    // MARK: - Data Display
    func displayBookDetail() {
        guard let book = newBook else { return }
        clearData()
        newBookView.bookTileCell.textField.text      = book.volumeInfo?.title
        newBookView.bookAuthorCell.textField.text    = formatter.joinArrayToString(book.volumeInfo?.authors)
        newBookView.publisherCell.textField.text     = book.volumeInfo?.publisher
        newBookView.publishDateCell.textField.text   = formatter.formatDateToYearString(for: book.volumeInfo?.publishedDate)
        newBookView.isbnCell.textField.text          = book.volumeInfo?.industryIdentifiers?.first?.identifier
        newBookView.numberOfPagesCell.textField.text = "\(book.volumeInfo?.pageCount ?? 0)"
        bookDescription                              = book.volumeInfo?.volumeInfoDescription
        bookCategories                               = book.category ?? []
      
        displayBookCover(for: book)
        displayBookPrice(for: book)
        displayRating(for: book)
        setBookCurrency()
        setBookLanguage()
    }
    
    private func displayBookCover(for book: Item) {
        imageLoader.getImage(for: book.volumeInfo?.imageLinks?.thumbnail) { [weak self] image in
            self?.newBookView.bookImageCell.pictureView.image = image
        }
    }
    private func displayBookPrice(for book: Item) {
        if let price = book.saleInfo?.retailPrice?.amount {
            newBookView.purchasePriceCell.textField.text = "\(price)"
        }
    }
    private func displayRating(for book: Item) {
        if let rating = book.volumeInfo?.ratingsCount {
            newBookView.ratingCell.ratingSegmentedControl.selectedSegmentIndex = rating
        }
    }
    private func setBookLanguage() {
        let bookLanguage = newBook?.volumeInfo?.language ?? Bundle.main.preferredLocalizations[0]
        setPickerValue(for: newBookView.languageCell.pickerView, list: languageList, with: bookLanguage)
    }
    private func setBookCurrency() {
        let bookCurrency = newBook?.saleInfo?.retailPrice?.currencyCode ?? Locale.current.currencyCode
        setPickerValue(for: newBookView.currencyCell.pickerView, list: currencyList, with: bookCurrency ?? "")
    }
    private func setPickerValue(for picker: UIPickerView, list: [String], with code: String) {
        if let index = list.firstIndex(where: {
            $0.lowercased() == code.lowercased()
        }) {
            picker.selectRow(index, inComponent: 0, animated: false)
            self.pickerView(picker, didSelectRow: index, inComponent: 0)
        }
    }
    
    private func clearData() {
        newBookView.searchController.isActive = false
        newBookView.bookImageCell.pictureView.image = Images.emptyStateBookImage
        bookComment = nil
        bookDescription = nil
        bookCategories.removeAll()
        resultController.searchedBooks.removeAll()
        newBookView.textFields.forEach { $0.text = nil }
        newBookView.ratingCell.ratingSegmentedControl.selectedSegmentIndex = 0
        tableView.setContentOffset(.zero, animated: true)
    }
    
    // MARK: - Api Call
    @objc private func saveBook() {
        newBookView.saveButtonCell.actionButton.displayActivityIndicator(true)
        guard let book = createBookDocument(),
              let imageData = newBookView.bookImageCell.pictureView.image?.jpegData(.high) else { return }
        
        libraryService.createBook(with: book, and: imageData) { [weak self] error in
            guard let self = self else { return }
            
            self.newBookView.saveButtonCell.actionButton.displayActivityIndicator(false)
            if let error = error {
                self.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            self.presentAlertBanner(as: .success, subtitle: Text.Book.bookSaved)
            self.isEditingBook ? self.returnToPreviousController() : self.clearData()
        }
    }
    
    private func createBookDocument() -> Item? {
        let isbn = newBookView.isbnCell.textField.text ?? ""
        
        let volumeInfo = VolumeInfo(title: newBookView.bookTileCell.textField.text,
                                    authors: [newBookView.bookAuthorCell.textField.text ?? ""],
                                    publisher: newBookView.publisherCell.textField.text ?? "",
                                    publishedDate: newBookView.publishDateCell.textField.text ?? "",
                                    volumeInfoDescription: bookDescription,
                                    industryIdentifiers: [IndustryIdentifier(identifier: isbn)],
                                    pageCount: formatter.formatStringToInt(newBookView.numberOfPagesCell.textField.text),
                                    ratingsCount: newBookView.ratingCell.ratingSegmentedControl.selectedSegmentIndex,
                                    imageLinks: ImageLinks(thumbnail: newBook?.volumeInfo?.imageLinks?.thumbnail),
                                    language: chosenLanguage ?? "")
        
        let price = formatter.formatDecimalString(newBookView.purchasePriceCell.textField.text)
        let saleInfo = SaleInfo(retailPrice: SaleInfoListPrice(amount: price, currencyCode: chosenCurrency ?? ""))
        
        return Item(bookID: newBook?.bookID ?? "",
                    favorite: newBook?.favorite ?? false,
                    ownerID: newBook?.ownerID ?? "",
                    recommanding: newBook?.recommanding ?? false,
                    volumeInfo: volumeInfo,
                    saleInfo: saleInfo,
                    timestamp: validator.validateTimestamp(for: newBook?.timestamp),
                    category: bookCategories)
    }
    
    // MARK: - Navigation
    @objc private func showScannerController() {
        let barcodeScannerController = BarcodeScanViewController()
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
    
    private func presentTextInputController() {
        let textInputViewController = TextInputViewController()
        textInputViewController.newBookDelegate = self
        textInputViewController.textViewText    = bookDescription 
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
        resultController.currentSearchKeywords = newBookView.searchController.searchBar.text ?? ""
    }
}

// MARK: - TableView DataSource & Delegate
extension NewBookViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            imagePicker?.present(from: newBookView.bookImageCell.pictureView)
        case (2, 0):
            showCategoryList()
        case (4, 0):
            presentTextInputController()
        default:
            break
        }
    }
}
// MARK: - ImagePicker Delegate
extension NewBookViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        newBookView.bookImageCell.pictureView.image = image?.resizeImage()
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
        switch pickerView {
        case newBookView.languageCell.pickerView:
            let language = self.languageList[row]
            pickerLabel?.text = "  " + formatter.formatCodeToName(from: language, type: .language).capitalized
        case newBookView.currencyCell.pickerView:
            let currencyCode = self.currencyList[row]
            pickerLabel?.text = "  " + formatter.formatCodeToName(from: currencyCode, type: .currency).capitalized
        default:
            return UIView()
        }
        pickerLabel?.textColor = .label
        return pickerLabel ?? UILabel()
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case newBookView.languageCell.pickerView:
            return languageList.count
        case newBookView.currencyCell.pickerView:
            return currencyList.count
        default:
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case newBookView.languageCell.pickerView:
            chosenLanguage = languageList[row]
        case newBookView.currencyCell.pickerView:
            chosenCurrency = currencyList[row]
        default:
            return
        }
    }
}
