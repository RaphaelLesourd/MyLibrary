//
//  NewViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit

class NewBookViewController: UITableViewController {

    weak var bookCardDelegate: BookCardDelegate?
    let subViews = NewBookControllerSubViews()
    
    private let searchViewController: SearchViewController
    private let presenter: NewBookPresenter
    private var imagePicker: ImagePicker?
    private var sections: [[UITableViewCell]] = [[]]
    private var isEditingBook = false
    private var factory: Factory
   
    init(book: ItemDTO?,
         isEditing: Bool,
         bookCardDelegate: BookCardDelegate?,
         presenter: NewBookPresenter,
         resultViewController: SearchViewController,
         factory: Factory) {
        self.presenter = presenter
        self.presenter.book = book
        self.isEditingBook = isEditing
        self.bookCardDelegate = bookCardDelegate
        self.searchViewController = resultViewController
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
        presenter.displayBook()
    }

    // MARK: - Setup
    private func configureTableView() {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .viewControllerBackgroundColor
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 40, right: 0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
    }
    
    private func addNavigationBarButtons() {
        let scannerButton = UIBarButtonItem(image: Images.NavIcon.scanBarcode,
                                            style: .plain,
                                            target: self,
                                            action: #selector(presentBarcodeScannerVC))
        let activityIndicactorButton = UIBarButtonItem(customView: subViews.activityIndicator)
        navigationItem.rightBarButtonItems = isEditingBook ? [activityIndicactorButton] : [scannerButton, activityIndicactorButton]
    }
    
    private func configureUI() {
        view.backgroundColor = .viewControllerBackgroundColor
        title = isEditingBook ? Text.ControllerTitle.modify : Text.ControllerTitle.newBook
    }
    
    private func setDelegates() {
        subViews.delegate = self
        subViews.textFields.forEach { $0.delegate = self }
    }
    
    private func configureSearchController() {
        subViews.searchController = UISearchController(searchResultsController: searchViewController)
        subViews.searchController.searchBar.delegate = self
        subViews.searchController.obscuresBackgroundDuringPresentation = false
        subViews.searchController.searchBar.placeholder = Text.Placeholder.search
        subViews.searchController.definesPresentationContext = false
        searchViewController.newBookDelegate = self
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = isEditingBook ? nil : subViews.searchController
    }
    
    func clearData() {
        tableView.setContentOffset(.zero, animated: false)
        presenter.bookCategories.removeAll()
        presenter.bookDescription = nil
        subViews.reset()
    }
    
    // MARK: - Navigation
    @objc func returnToPreviousVC() {
        bookCardDelegate?.updateBook()
        clearData()
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func presentBarcodeScannerVC() {
        let barcodeScannerVC = factory.makeBarcodeScannerVC(delegate: self)
        if #available(iOS 15.0, *) {
            presentSheetController(barcodeScannerVC, detents: [.medium()])
        } else {
            navigationController?.pushViewController(barcodeScannerVC, animated: true)
        }
    }
    
    private func presentCategoryListController() {
        let categoryListVC = factory.makeCategoryVC(isSelecting: true,
                                                    bookCategories: presenter.bookCategories,
                                                    newBookDelegate: self)
        showController(categoryListVC)
    }
    
    private func presentDescriptionController() {
        let descriptionVC = factory.makeBookDescriptionVC(description: presenter.bookDescription,
                                                          newBookDelegate: self)
        showController(descriptionVC)
    }
    
    private func presentListViewController(for listType: ListDataType, with selectedData: String?) {
        let listViewController = factory.makeListVC(for: listType,
                                                       selectedData: selectedData,
                                                       newBookDelegate: self)
        showController(listViewController)
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
        searchViewController.presenter.searchType = .barCodeSearch
        searchViewController.presenter.currentSearchKeywords = code
    }
}

// MARK: - SearchBar Delegate
extension NewBookViewController: UISearchBarDelegate {
    /// Pass the keyword entered int he searchBar to the SearchBookViewController.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchViewController.presenter.clearData()
        searchViewController.presenter.searchType = .keywordSearch
        searchViewController.presenter.currentSearchKeywords = subViews.searchController.searchBar.text ?? ""
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchViewController.presenter.clearData()
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
        guard let imageData = subViews.bookImageCell.pictureView.image?.jpegData(.medium) else { return }
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
    
    func setBookData(with item: ItemDTO?) {
        clearData()
        presenter.book = item
        presenter.displayBook()
    }
}

// MARK: - NewBook Presenter
extension NewBookViewController: NewBookPresenterView {

    func displayLanguage(with name: String) {
        subViews.languageCell.textLabel?.text = name
    }
    
    func displayCurrencyView(with name: String) {
        subViews.currencyCell.textLabel?.text = name
    }
    
    func displayBook(with model: NewBookUI) {
        subViews.configure(with: model)
    }
    
    func toggleSaveButtonActivityIndicator(to play: Bool) {
        subViews.saveButtonCell.actionButton.toggleActivityIndicator(to: play)
    }
}

// MARK: - TableView Delegate
extension NewBookViewController {
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NewBookSections.allCases[section].headerTitle
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
        return 20
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
        case (0,0):
            imagePicker?.present(from: subViews.bookImageCell.pictureView)
        case (2,0):
            presentCategoryListController()
        case (4,0):
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
