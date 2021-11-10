//
//  BookCardViewController.swift
//  MyBookLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit
import AlamofireImage

class BookCardViewController: UIViewController {

    // MARK: - Properties
    private let mainView = BookCardMainView()
    private var libraryService: LibraryServiceProtocol
    private weak var newBookBookDelegate: NewBookDelegate?
    private let activityIndicator = UIActivityIndicatorView()
    private var isFavorite = false {
        didSet {
            setFavoriteIcon(isFavorite)
        }
    }
    var searchType: SearchType?
    var book: Item? {
        didSet {
            dispayBookData()
        }
    }
    
    // MARK: - Intializers
    init(libraryService: LibraryServiceProtocol) {
        self.libraryService = libraryService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
        view.backgroundColor = .secondarySystemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = ""
        addNavigationBarButtons()
        setTargets()
        configureUi()
    }
    // MARK: - Setup
    private func addNavigationBarButtons() {
        let editButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(editBook))
        let activityIndicactorButton = UIBarButtonItem(customView: activityIndicator)
        navigationItem.rightBarButtonItems = [editButton, activityIndicactorButton]
    }
    
    private func setTargets() {
        mainView.deleteBookButton.addTarget(self, action: #selector(deleteBookAction), for: .touchUpInside)
        mainView.favoriteButton.addTarget(self, action: #selector(favoriteButtonAction), for: .touchUpInside)
    }
    
    private func configureUi() {
        mainView.commentLabel.isHidden = searchType == .apiSearch
        mainView.deleteBookButton.isHidden = searchType == .apiSearch
        let actionButtontitle = searchType == .apiSearch ? "Sauvegarder" : "Recommander"
        mainView.actionButton.setTitle(actionButtontitle, for: .normal)
    }
    
    // MARK: - Data
    private func dispayBookData() {
        let book = book?.volumeInfo
        mainView.titleLabel.text                                 = book?.title
        mainView.authorLabel.text                                = book?.authors?.first
        mainView.categoryiesLabel.text                           = book?.categories?.joined(separator: ", ")
        mainView.descriptionLabel.text                           = book?.volumeInfoDescription
        mainView.bookDetailView.publisherNameView.infoLabel.text = book?.publisher
        mainView.bookDetailView.publishedDateView.infoLabel.text = book?.publishedDate?.displayYearOnly
        mainView.bookDetailView.numberOfPageView.infoLabel.text  = "\(book?.pageCount ?? 0)"
        mainView.bookDetailView.languageView.infoLabel.text      = book?.language?.capitalized
        mainView.purchaseDetailView.titleLabel.text              = ""
        mainView.purchaseDetailView.purchasePriceLabel.text      = ""
        mainView.currentResellPriceView.titleLabel.text          = "Prix de vente"
        mainView.commentLabel.text                               = ""
       
        if let currency = self.book?.saleInfo?.retailPrice?.currencyCode,
           let price = self.book?.saleInfo?.retailPrice?.amount {
            mainView.currentResellPriceView.purchasePriceLabel.text = "\(currency.currencySymbol) \(price)"
        }
        if let isbn = book?.industryIdentifiers?.first?.identifier {
            mainView.isbnLabel.text = "ISBN \(isbn)"
        }
        if let favorite = self.book?.favorite {
            isFavorite = favorite
        }
        if let imageUrl = book?.imageLinks?.thumbnail, let url = URL(string: imageUrl) {
            mainView.bookCover.af.setImage(withURL: url,
                                           cacheKey: book?.industryIdentifiers?.first?.identifier,
                                           placeholderImage: Images.emptyStateBookImage,
                                           completion: nil)
        }
    }
    
    private func setFavoriteIcon(_ favorite: Bool) {
        mainView.favoriteButton.tintColor = favorite ? .systemPink : .systemGray
    }
    
    // MARK: - Api call
    func showSelectedBook(for id: String) {
       showIndicator(activityIndicator)
       
        libraryService.retrieveBook(for: id) { [weak self] result in
            guard let self = self else { return }
            self.hideIndicator(self.activityIndicator)
            switch result {
            case .success(let book):
                self.book = book
            case .failure(let error):
                self.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
    
    private func deleteBook() {
        guard let book = book else { return }
        showIndicator(activityIndicator)
        
        libraryService.deleteBook(book: book) { [weak self] error in
            guard let self = self else { return }
            self.hideIndicator(self.activityIndicator)
            if let error = error {
                self.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            self.presentAlertBanner(as: .success, subtitle: "Livre éffacé de votre bibliothèque.")
            self.navigationController?.popViewController(animated: true)
        }
    }

    private func updateFavoriteState(for isFavorite: Bool) {
        guard let bookId = book?.etag else { return }
        showIndicator(activityIndicator)
        
        libraryService.addToFavorite(isFavorite, for: bookId) { [weak self] error in
            guard let self = self else { return }
            self.hideIndicator(self.activityIndicator)
            if let error = error {
                self.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
   
    // MARK: - Targets
    @objc private func favoriteButtonAction() {
        isFavorite.toggle()
        updateFavoriteState(for: isFavorite)
    }
    
    @objc private func deleteBookAction() {
        presentAlert(withTitle: "Effacer un livre",
                     message: "Etes-vous sur de vouloir effacer ce livre?",
                     withCancel: true) { [weak self] _ in
            self?.deleteBook()
        }
    }
    // MARK: - Navigation
    @objc private func editBook() {
        let newBookController = NewBookViewController(libraryService: LibraryService())
        newBookController.newBook       = book
        newBookController.isEditingBook = true
        navigationController?.pushViewController(newBookController, animated: true)
    }
}
