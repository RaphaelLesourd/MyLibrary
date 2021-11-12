//
//  BookCardViewController.swift
//  MyBookLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit
import FirebaseAuth
import Alamofire
import AlamofireImage

class BookCardViewController: UIViewController {
    
    // MARK: - Properties
    private let mainView = BookCardMainView()
    private let activityIndicator = UIActivityIndicatorView()
    
    private var libraryService          : LibraryServiceProtocol
    private var recommandationService   : RecommandationServiceProtocol
    private weak var newBookBookDelegate: NewBookDelegate?
    
    private var isRecommanded = false {
        didSet {
            setRecommandationButton(isRecommanded)
        }
    }
    private var isFavorite = false {
        didSet {
            setFavoriteIcon(isFavorite)
        }
    }
    private var coverImage: UIImage? {
        didSet {
            guard let coverImage = coverImage else { return }
            mainView.bookCover.image = coverImage
        }
    }
    var searchType: SearchType?
    var book: Item? {
        didSet {
            dispayBookData()
        }
    }
    
    // MARK: - Intializers
    init(libraryService: LibraryServiceProtocol, recommandationService: RecommandationServiceProtocol) {
        self.libraryService        = libraryService
        self.recommandationService = recommandationService
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
        configureUI()
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
        mainView.actionButton.addTarget(self, action: #selector(recommandButtonAction), for: .touchUpInside)
        mainView.deleteBookButton.addTarget(self, action: #selector(deleteBookAction), for: .touchUpInside)
        mainView.favoriteButton.addTarget(self, action: #selector(favoriteButtonAction), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        mainView.addGestureRecognizer(tap)
    }
    
    private func configureUI() {
        mainView.commentLabel.isHidden = searchType == .apiSearch
        mainView.deleteBookButton.isHidden = searchType == .apiSearch
        let actionButtontitle = searchType == .apiSearch ? "Sauvegarder" : "Recommander"
        mainView.actionButton.setTitle(actionButtontitle, for: .normal)
       
        if book?.ownerID != Auth.auth().currentUser?.uid {
            mainView.deleteBookButton.isHidden = true
            mainView.actionButton.isHidden = true
            mainView.favoriteButton.isHidden = true
        }
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
        if let recommand = self.book?.recommanding {
            isRecommanded = recommand
        }
        if let url = book?.imageLinks?.thumbnail, let imageURL = URL(string: url) {
            AF.request(imageURL).responseImage { [weak self] response in
                if case .success(let image) = response.result {
                    self?.coverImage = image
                }
            }
        }
    }
    
    private func setFavoriteIcon(_ isFavorite: Bool) {
        mainView.favoriteButton.tintColor = isFavorite ? .systemPink : .systemGray
    }
    
    private func setRecommandationButton(_ isRecommanding: Bool) {
        let title = isRecommanding ? "Ne plus recommander" : "Recommander"
        mainView.actionButton.setTitle(title, for: .normal)
    }
    
    // MARK: - Api call
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
            self.recommnandBook(false)
            self.presentAlertBanner(as: .success, subtitle: "Livre éffacé de votre bibliothèque.")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func updateBookFieldStatus(_ state: Bool, fieldKey: BookDocumentKey) {
        guard let bookID = book?.etag else { return }
        showIndicator(activityIndicator)
        
        libraryService.setStatusTo(state, field: fieldKey, for: bookID) { [weak self] error in
            guard let self = self else { return }
            self.hideIndicator(self.activityIndicator)
            if let error = error {
                self.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
    
    private func recommnandBook(_ recommanded: Bool) {
        guard let book = book, let bookID = book.etag else {
            return
        }
        if recommanded == true {
            recommandationService.addToRecommandation(for: book) { [weak self] error in
                if let error = error {
                    self?.presentAlertBanner(as: .error, subtitle: error.description)
                }
            }
        } else {
            recommandationService.removeFromRecommandation(for: bookID) { [weak self] error in
                if let error = error {
                    self?.presentAlertBanner(as: .error, subtitle: error.description)
                }
            }
        }
        updateBookFieldStatus(recommanded, fieldKey: .recommanding)
    }
    
    // MARK: - Targets
    @objc private func favoriteButtonAction() {
        isFavorite.toggle()
        updateBookFieldStatus(isFavorite, fieldKey: .favorite)
    }
    
    @objc private func recommandButtonAction() {
        isRecommanded.toggle()
        recommnandBook(isRecommanded)
        
    }
    
    @objc private func deleteBookAction() {
        presentAlert(withTitle: "Effacer un livre",
                     message: "Etes-vous sur de vouloir effacer ce livre?",
                     withCancel: true) { [weak self] _ in
            self?.deleteBook()
        }
    }
        
    @objc func handleTapGesture(_ sender: UITapGestureRecognizer) {
        let bookCoverController = BookCoverViewController()
        bookCoverController.imageView.image = coverImage
        navigationController?.pushViewController(bookCoverController, animated: true)
    }
    
    // MARK: - Navigation
    @objc private func editBook() {
        let newBookController = NewBookViewController(libraryService: LibraryService(),
                                                      imageStorageService: ImageStorageService())
        newBookController.newBook       = book
        newBookController.isEditingBook = true
        navigationController?.pushViewController(newBookController, animated: true)
    }
}
