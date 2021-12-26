//
//  NewViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit

class NewBookViewController: StaticTableViewController, NewBookDelegate {
    
    // MARK: - Properties
    weak var bookCardDelegate: BookCardDelegate?
    var isEditingBook = false
    var bookCategories: [String] = []
    var bookDescription: String?
    var bookComment: String?
    var newBook: Item? {
        didSet {
            setBookDetail()
        }
    }
    
    private let resultController = SearchViewController(apiManager: ApiManager(), layoutComposer: ListLayout())
    private let newBookView = NewBookControllerView()
    private let languageList = Locale.isoLanguageCodes
    private let currencyList = Locale.isoCurrencyCodes
    private let libraryService: LibraryServiceProtocol
    private let converter: ConverterProtocol
    private let formatter: FormatterProtocol
    private let validator: ValidatorProtocol
    private let newBookDataAdpater: NewBookAdapter?
   
    private var imagePicker: ImagePicker?
    private var chosenLanguage: String?
    private var chosenCurrency: String?
    
    init(libraryService: LibraryServiceProtocol,
         converter: ConverterProtocol,
         formatter: FormatterProtocol,
         validator: ValidatorProtocol) {
        self.libraryService = libraryService
        self.converter = converter
        self.formatter = formatter
        self.validator = validator
        self.newBookDataAdpater = NewBookDataAdapter(imageRetriever: KFImageRetriever(),
                                                     converter: converter,
                                                     formatter: formatter)
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
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setBookLanguage()
        setBookCurrency()
    }
    // MARK: - Setup
    private func addNavigationBarButtons() {
        let scannerButton = UIBarButtonItem(image: Images.NavIcon.scanBarcode,
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
        newBookView.delegate = self
        newBookView.textFields.forEach { $0.delegate = self }
        newBookView.languageCell.pickerView.delegate = self
        newBookView.languageCell.pickerView.dataSource = self
        newBookView.currencyCell.pickerView.delegate = self
        newBookView.currencyCell.pickerView.dataSource = self
    }
    
    private func configureSearchController() {
        newBookView.searchController = UISearchController(searchResultsController: resultController)
        newBookView.searchController.searchBar.delegate = self
        newBookView.searchController.obscuresBackgroundDuringPresentation = false
        newBookView.searchController.searchBar.placeholder = Text.Placeholder.search
        newBookView.searchController.definesPresentationContext = false
        resultController.newBookDelegate = self
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
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
    
    // MARK: - Data Display
    func setBookDetail() {
        guard let book = newBook else { return }
        clearData()
        newBookDataAdpater?.getNewBookData(for: book, completion: { [weak self] newBookData in
            self?.newBookView.displayBookDetail(with: newBookData)
        })
        
        bookDescription = book.volumeInfo?.volumeInfoDescription
        bookCategories = book.category ?? []
        
        setBookCurrency()
        setBookLanguage()
    }
    
    private func setBookLanguage() {
        if let bookLanguage = newBook?.volumeInfo?.language {
            setPickerValue(for: newBookView.languageCell.pickerView, list: languageList, with: bookLanguage)
        }
    }
    
    private func setBookCurrency() {
        if let bookCurrency = newBook?.saleInfo?.retailPrice?.currencyCode {
            setPickerValue(for: newBookView.currencyCell.pickerView, list: currencyList, with: bookCurrency)
        }
    }
    
    private func setPickerValue(for picker: UIPickerView, list: [String], with code: String) {
        if let index = list.firstIndex(where: { $0.lowercased() == code.lowercased() }) {
            picker.selectRow(index, inComponent: 0, animated: false)
            self.pickerView(picker, didSelectRow: index, inComponent: 0)
        }
    }
    
    private func clearData() {
        newBookView.resetViews()
        tableView.setContentOffset(.zero, animated: true)
        newBookView.searchController.isActive = false
        resultController.searchedBooks.removeAll()
        bookCategories.removeAll()
        bookComment = nil
        bookDescription = nil
    }
    /// Uses data enterred to create a book.
    ///  - Returns: Book object of type Item
    private func createBookDocument() -> Item? {
        let isbn = newBookView.isbnCell.textField.text ?? ""
        
        let volumeInfo = VolumeInfo(title: newBookView.bookTileCell.textField.text,
                                    authors: [newBookView.bookAuthorCell.textField.text ?? ""],
                                    publisher: newBookView.publisherCell.textField.text ?? "",
                                    publishedDate: newBookView.publishDateCell.textField.text ?? "",
                                    volumeInfoDescription: bookDescription,
                                    industryIdentifiers: [IndustryIdentifier(identifier: isbn)],
                                    pageCount: converter.convertStringToInt(newBookView.numberOfPagesCell.textField.text),
                                    ratingsCount: newBookView.ratingCell.ratingSegmentedControl.selectedSegmentIndex,
                                    imageLinks: ImageLinks(thumbnail: newBook?.volumeInfo?.imageLinks?.thumbnail),
                                    language: chosenLanguage ?? "")
        
        let price = converter.convertStringToDouble(newBookView.purchasePriceCell.textField.text)
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
        if #available(iOS 15.0, *) {
            if let sheet = barcodeScannerController.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.largestUndimmedDetentIdentifier = .large
                sheet.preferredCornerRadius = 23
                sheet.prefersGrabberVisible = true
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                sheet.prefersEdgeAttachedInCompactHeight = true
                sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
                present(barcodeScannerController, animated: true, completion: nil)
            }
        } else {
            navigationController?.pushViewController(barcodeScannerController, animated: true)
        }
    }
    
    @objc func returnToPreviousController() {
        bookCardDelegate?.fetchBookUpdate()
        clearData()
        navigationController?.popViewController(animated: true)
    }
    
    private func showCategoryList() {
        let categoryListVC = CategoriesViewController(settingBookCategory: true, categoryService: CategoryService())
        categoryListVC.newBookDelegate = self
        categoryListVC.selectedCategories = bookCategories
        navigationController?.show(categoryListVC, sender: nil)
    }
    
    private func presentTextInputController() {
        let textInputViewController = BookDescriptionViewController()
        textInputViewController.newBookDelegate = self
        textInputViewController.textViewText = bookDescription
        navigationController?.show(textInputViewController, sender: nil)
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
extension NewBookViewController: BarcodeScannerDelegate {
    /// Uses the barcode string returned from the BarcodeScannerViewController as a search keyword
    /// and pass it the SearchViewController.
    func processBarcode(with code: String) {
        resultController.searchType = .barCodeSearch
        resultController.currentSearchKeywords = code
    }
}

// MARK: - Searchbar delegate
extension NewBookViewController: UISearchBarDelegate {
    /// Pass the keyword entered int he searchBar to the SearchBookViewController.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        resultController.searchedBooks.removeAll()
        resultController.searchType = .keywordSearch
        resultController.currentSearchKeywords = newBookView.searchController.searchBar.text ?? ""
    }
}

// MARK: - ImagePicker Delegate
extension NewBookViewController: ImagePickerDelegate {
    /// Users the image returned from the ImagePickerViewController and assign it the BookImageCell as the book cover image.
    func didSelect(image: UIImage?) {
        newBookView.bookImageCell.pictureView.image = image?.resizeImage()
    }
}

// MARK: - UIPickerDelegate
/// PickerView delegate functions, handle the language and currency picker by using a switch statement .
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

// MARK: - Extension NewBookViewDelegate
/// Accessible functions for the view thru delegate protocol
extension NewBookViewController: NewBookViewDelegate {
    
    func saveBook() {
        newBookView.saveButtonCell.actionButton.displayActivityIndicator(true)
        guard let book = createBookDocument(),
              let imageData = newBookView.bookImageCell.pictureView.image?.jpegData(.high) else { return }
        
        libraryService.createBook(with: book, and: imageData) { [weak self] error in
            guard let self = self else { return }
            self.newBookView.saveButtonCell.actionButton.displayActivityIndicator(false)
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            AlertManager.presentAlertBanner(as: .success, subtitle: Text.Book.bookSaved)
            self.isEditingBook ? self.returnToPreviousController() : self.clearData()
        }
    }
}
