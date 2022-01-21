//
//  NewViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit

class NewBookViewController: UITableViewController, NewBookPickerDelegate {
    
    // MARK: - Properties
    weak var bookCardDelegate: BookCardDelegate?
    let newBookView = NewBookControllerView()
    
    var bookCategories: [String] = []
    var bookDescription: String?
    var bookComment: String?
    var chosenLanguage: String?
    var chosenCurrency: String?
    
    private var newBook: Item?
    private let resultController: SearchViewController
    private let libraryService: LibraryServiceProtocol
    private let converter: ConverterProtocol
    private let validator: ValidatorProtocol
    private let newBookDataConfiguration: NewBookConfigure
    private let languageList = Locale.isoLanguageCodes
    private let currencyList = Locale.isoCurrencyCodes
    
    private var pickerDataSource: NewBookPickerDataSource?
    private var imagePicker: ImagePicker?
    private var sections: [[UITableViewCell]] = [[]]
    private var isEditingBook = false
    private var factory: Factory
   
    init(book: Item?,
         isEditing: Bool,
         bookCardDelegate: BookCardDelegate?,
         libraryService: LibraryServiceProtocol,
         resultViewController: SearchViewController,
         converter: ConverterProtocol,
         validator: ValidatorProtocol,
         newBookDataConfiguration: NewBookConfiguration) {
        self.newBook = book
        self.isEditingBook = isEditing
        self.bookCardDelegate = bookCardDelegate
        self.libraryService = libraryService
        self.converter = converter
        self.validator = validator
        self.newBookDataConfiguration = newBookDataConfiguration
        self.resultController = resultViewController
        self.factory = ViewControllerFactory()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerDataSource = NewBookPickerDataSource(newBookView: newBookView,
                                                   formatter: Formatter(),
                                                   delegate: self)
        imagePicker = ImagePicker(presentationController: self,
                                  delegate: self,
                                  permissions: PermissionManager())
        sections = newBookView.composeTableView()
        configureTableView()
        setDelegates()
        addNavigationBarButtons()
        configureSearchController()
        configureUI()
        setBookDetail()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setBookLanguage()
        setBookCurrency()
    }
    
    // MARK: - Setup
    private func configureTableView() {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .viewControllerBackgroundColor
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 50, right: 0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
    }
    
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
        newBookView.languageCell.pickerView.delegate = pickerDataSource
        newBookView.languageCell.pickerView.dataSource = pickerDataSource
        newBookView.currencyCell.pickerView.delegate = pickerDataSource
        newBookView.currencyCell.pickerView.dataSource = pickerDataSource
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
    
    // MARK: - Data Display
    func setBookDetail() {
        guard let book = newBook else { return }
        clearData()
        newBookDataConfiguration.configure(newBookView, with: book)
        bookDescription = book.volumeInfo?.volumeInfoDescription
        bookCategories = book.category ?? []
       dump(bookCategories)
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
            self.pickerDataSource?.pickerView(picker, didSelectRow: index, inComponent: 0)
        }
    }
    
    /// Uses data enterred to create a book.
    ///  - Returns: Book object of type Item
    private func createBookDocument() -> Item? {
        let isbn = newBookView.isbnCell.textField.text ?? "-"
        
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
            presentSheetController(barcodeScannerController, detents: [.medium()])
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
        let categoryListVC = factory.makeCategoryVC(settingCategory: true,
                                                    bookCategories: bookCategories,
                                                    newBookDelegate: self)
        navigationController?.show(categoryListVC, sender: nil)
    }
    
    private func presentDescriptionController() {
        let descriptionViewController = factory.makeBookDescriptionVC(description: bookDescription,
                                                                      newBookDelegate: self)
        guard UIDevice.current.userInterfaceIdiom == .pad else {
            navigationController?.show(descriptionViewController, sender: nil)
            return
        }
        let descriptionVC = UINavigationController(rootViewController: descriptionViewController)
        present(descriptionVC, animated: true, completion: nil)
    }
}

// MARK: - TextField Delegate
extension NewBookViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - BarcodeScanner Delegate
extension NewBookViewController: BarcodeScannerDelegate {
    /// Uses the barcode string returned from the BarcodeScannerViewController as a search keyword
    /// and pass it the SearchViewController.
    func processBarcode(with code: String) {
        resultController.searchType = .barCodeSearch
        resultController.currentSearchKeywords = code
    }
}

// MARK: - SearchBar Delegate
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
        DispatchQueue.main.async {
            self.newBookView.bookImageCell.pictureView.image = image?.resizeImage()
        }
    }
}

// MARK: - NewBookView Delegate
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
    
    func clearData() {
        newBookView.resetViews()
        tableView.setContentOffset(.zero, animated: true)
        newBookView.searchController.isActive = false
        resultController.searchedBooks.removeAll()
        bookCategories.removeAll()
        bookComment = nil
        bookDescription = nil
    }
}

extension NewBookViewController: NewBookDelegate {
    func displayBook(for item: Item?) {
        newBook = item
        setBookDetail()
    }
}

// MARK: - TableView DataSource & Delegate
extension NewBookViewController {
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 2:
            return Text.SectionTitle.newBookCategoriesHeader
        case 3:
            return Text.SectionTitle.newBookPublishingHeader
        case 4:
            return Text.SectionTitle.newBookDetailsHeader
        case 5:
            return Text.SectionTitle.newBookRatingHeader
        case 6:
            return Text.SectionTitle.newBookPriceHeader
        default:
            return ""
        }
    }
   
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = TextLabel(color: .secondaryLabel,
                              maxLines: 2,
                              alignment: .center,
                              font: .footerLabel)
        label.text = section == 7 ? Text.SectionTitle.newBookSaveFooter : ""
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
    
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
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            imagePicker?.present(from: newBookView.bookImageCell.pictureView)
        case (2, 0):
            showCategoryList()
        case (4, 0):
            presentDescriptionController()
        default:
            break
        }
    }
}
