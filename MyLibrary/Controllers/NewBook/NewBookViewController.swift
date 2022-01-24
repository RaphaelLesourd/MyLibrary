//
//  NewViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit

class NewBookViewController: UITableViewController {
    
    // MARK: - Properties
    weak var bookCardDelegate: BookCardDelegate?
    let subViews = NewBookControllerSubViews()
    
    private let resultController: SearchViewController
    private let presenter: NewBookPresenter
    
    private var imagePicker: ImagePicker?
    private var sections: [[UITableViewCell]] = [[]]
    private var isEditingBook = false
    private var factory: Factory
   
    init(book: Item?,
         isEditing: Bool,
         bookCardDelegate: BookCardDelegate?,
         presenter: NewBookPresenter,
         resultViewController: SearchViewController) {
        self.presenter = presenter
        self.presenter.book = book
        self.isEditingBook = isEditing
        self.bookCardDelegate = bookCardDelegate
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
        presenter.view = self
        presenter.mainView = subViews
        presenter.isEditing = isEditingBook
        imagePicker = ImagePicker(presentationController: self,
                                  delegate: self,
                                  permissions: PermissionManager())
        sections = subViews.composeTableView()
        configureTableView()
        setDelegates()
        addNavigationBarButtons()
        configureSearchController()
        configureUI()
        clearData()
        presenter.setBookData()
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
        let activityIndicactorButton = UIBarButtonItem(customView: subViews.activityIndicator)
        navigationItem.rightBarButtonItems = isEditingBook ? [activityIndicactorButton] : [scannerButton, activityIndicactorButton]
    }
    
    private func configureUI() {
        view.backgroundColor = .viewControllerBackgroundColor
        title = isEditingBook ? Text.ControllerTitle.modify : Text.ControllerTitle.newBook
        self.navigationItem.searchController = isEditingBook ? nil : subViews.searchController
    }
    
    private func setDelegates() {
        subViews.delegate = self
        subViews.textFields.forEach { $0.delegate = self }
    }
    
    private func configureSearchController() {
        subViews.searchController = UISearchController(searchResultsController: resultController)
        subViews.searchController.searchBar.delegate = self
        subViews.searchController.obscuresBackgroundDuringPresentation = false
        subViews.searchController.searchBar.placeholder = Text.Placeholder.search
        subViews.searchController.definesPresentationContext = false
        resultController.newBookDelegate = self
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func clearData() {
        tableView.setContentOffset(.zero, animated: true)
        presenter.bookCategories.removeAll()
        presenter.bookDescription = nil
        subViews.reset()
    }
    
    // MARK: - Navigation
    @objc func returnToPreviousController() {
        bookCardDelegate?.fetchBookUpdate()
        clearData()
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func showScannerController() {
        let barcodeScannerController = BarcodeScanViewController()
        barcodeScannerController.barcodeDelegate = self
        if #available(iOS 15.0, *) {
            presentSheetController(barcodeScannerController, detents: [.medium()])
        } else {
            navigationController?.pushViewController(barcodeScannerController, animated: true)
        }
    }
    
    private func showCategoryList() {
        let categoryListVC = factory.makeCategoryVC(settingCategory: true,
                                                    bookCategories: presenter.bookCategories,
                                                    newBookDelegate: self)
        navigationController?.show(categoryListVC, sender: nil)
    }
    
    private func presentDescriptionController() {
        let descriptionViewController = factory.makeBookDescriptionVC(description: presenter.bookDescription,
                                                                      newBookDelegate: self)
        guard UIDevice.current.userInterfaceIdiom == .pad else {
            navigationController?.show(descriptionViewController, sender: nil)
            return
        }
        let descriptionVC = UINavigationController(rootViewController: descriptionViewController)
        present(descriptionVC, animated: true, completion: nil)
    }
    
    private func presentListViewController(for listType: ListDataType, with selectedData: String?) {
        let controller = factory.makeListVC(for: listType,
                                                           selectedData: selectedData,
                                                           newBookDelegate: self)
        navigationController?.show(controller, sender: nil)
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
        resultController.presenter.searchType = .barCodeSearch
        resultController.presenter.currentSearchKeywords = code
    }
}

// MARK: - SearchBar Delegate
extension NewBookViewController: UISearchBarDelegate {
    /// Pass the keyword entered int he searchBar to the SearchBookViewController.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        resultController.presenter.searchedBooks.removeAll()
        resultController.presenter.searchType = .keywordSearch
        resultController.presenter.currentSearchKeywords = subViews.searchController.searchBar.text ?? ""
    }
}

// MARK: - ImagePicker Delegate
extension NewBookViewController: ImagePickerDelegate {
    /// Users the image returned from the ImagePickerViewController and assign it the BookImageCell as the book cover image.
    func didSelect(image: UIImage?) {
        DispatchQueue.main.async {
            self.subViews.bookImageCell.pictureView.image = image?.resizeImage()
        }
    }
}

// MARK: - NewBookView Delegate
extension NewBookViewController: NewBookViewDelegate {
    
    func saveBook() {
        guard let imageData = subViews.bookImageCell.pictureView.image?.jpegData(.high) else { return }
        presenter.saveBook(with: imageData)
    }
}

// MARK: - NewBookController Delegate
extension NewBookViewController: NewBookViewControllerDelegate {
    func setDescription(with text: String) {
        presenter.bookDescription = text
    }
    
    func setCategories(with list: [String]) {
        presenter.bookCategories = list
    }
    
    func setLanguage(with code: String?) {
        presenter.setBookLanguage(with: code)
    }
    
    func setCurrency(with code: String?) {
        presenter.setBookCurrency(with: code)
    }
    
    func displayBook(for item: Item?) {
        clearData()
        presenter.book = item
        presenter.setBookData()
    }
}

// MARK: - NewBook Presenter
extension NewBookViewController: NewBookPresenterView {
    func updateLanguageView(with language: String) {
        subViews.languageCell.textLabel?.text = language
    }
    
    func updateCurrencyView(with currency: String) {
        subViews.currencyCell.textLabel?.text = currency
    }
    
    func displayBook(with model: NewBookRepresentable) {
        subViews.configure(with: model)
    }
    
    func showSaveButtonActicityIndicator(_ show: Bool) {
        subViews.saveButtonCell.actionButton.displayActivityIndicator(show)
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
            return Text.Book.bookLanguage
        case 6:
            return Text.SectionTitle.newBookRatingHeader
        case 7:
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
        label.text = section == 8 ? Text.SectionTitle.newBookSaveFooter : ""
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
            imagePicker?.present(from: subViews.bookImageCell.pictureView)
        case (2, 0):
            showCategoryList()
        case (4, 0):
            presentDescriptionController()
        case (5,0):
            presentListViewController(for: .languages, with: presenter.language)
        case (7,1):
            presentListViewController(for: .currency, with: presenter.currency)
        default:
            return
        }
    }
}
