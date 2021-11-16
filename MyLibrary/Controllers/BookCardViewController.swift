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
import SwiftUI

protocol BookCardDelegate: AnyObject {
    func fetchBookUpdate()
}

class BookCardViewController: UIViewController {
    
    // MARK: - Properties
    private let mainView = BookCardMainView()
    private let activityIndicator = UIActivityIndicatorView()
    
    private var libraryService        : LibraryServiceProtocol
    private var recommandationService : RecommandationServiceProtocol
    
    private var isRecommandedStatus = false {
        didSet {
            setRecommandationButton(isRecommanding: isRecommandedStatus)
        }
    }
    private var isFavorite = false {
        didSet {
            setFavoriteIcon(isFavorite)
        }
    }
    private var coverImage: UIImage?
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.largeTitleDisplayMode = .always
    }
    
    // MARK: - Setup
    private func addNavigationBarButtons() {
        let editButton = UIBarButtonItem(image: Images.editBookIcon,
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
        mainView.commentLabel.isHidden     = searchType == .apiSearch
        mainView.deleteBookButton.isHidden = searchType == .apiSearch
        if  searchType == .apiSearch {
            mainView.actionButton.setTitle("Sauvegarder", for: .normal)
        }
        if book?.ownerID != Auth.auth().currentUser?.uid {
            mainView.deleteBookButton.isHidden = true
            mainView.actionButton.isHidden     = true
            mainView.favoriteButton.isHidden   = true
        }
    }
    
    // MARK: - Data
    private func dispayBookData() {
        mainView.titleLabel.text                                 = book?.volumeInfo?.title?.capitalized
        mainView.authorLabel.text                                = book?.volumeInfo?.authors?.first?.capitalized
        mainView.categoryiesLabel.text                           = book?.volumeInfo?.categories?.joined(separator: ", ")
        mainView.descriptionLabel.text                           = book?.volumeInfo?.volumeInfoDescription
        mainView.bookDetailView.publisherNameView.infoLabel.text = book?.volumeInfo?.publisher?.capitalized
        mainView.bookDetailView.publishedDateView.infoLabel.text = book?.volumeInfo?.publishedDate
        mainView.bookDetailView.numberOfPageView.infoLabel.text  = "\(book?.volumeInfo?.pageCount ?? 0)"
        mainView.bookDetailView.languageView.infoLabel.text      = book?.volumeInfo?.language?.languageName.capitalized
        mainView.purchaseDetailView.titleLabel.text              = "Prix de vente"
        mainView.resellPriceView.titleLabel.text                 = "Côte actuelle"
        mainView.resellPriceView.purchasePriceLabel.text         = ""
        mainView.commentLabel.text                               = ""
        mainView.ratingView.rating                               = book?.volumeInfo?.ratingsCount ?? 0
        
        if let currency = self.book?.saleInfo?.retailPrice?.currencyCode,
           let price = self.book?.saleInfo?.retailPrice?.amount {
            mainView.purchaseDetailView.purchasePriceLabel.text = price.formatCurrency(currencyCode: currency)
        }
        if let isbn = book?.volumeInfo?.industryIdentifiers?.first?.identifier {
            mainView.isbnLabel.text = "ISBN \(isbn)"
        }
        if let favorite = self.book?.favorite {
            isFavorite = favorite
        }
        if let recommand = self.book?.recommanding {
            isRecommandedStatus = recommand
        }
        if let url = book?.volumeInfo?.imageLinks?.thumbnail, let imageURL = URL(string: url) {
            mainView.bookCover.af.setImage(withURL: imageURL,
                                           cacheKey: imageURL.absoluteString,
                                           completion: { [weak self] response in
                if case .success(let image) = response.result {
                    self?.coverImage = image
                }
            })
        }
    }
    
    private func setFavoriteIcon(_ isFavorite: Bool) {
        mainView.favoriteButton.tintColor = isFavorite ? .favoriteColor : .notFavorite
    }
    
    private func setRecommandationButton(isRecommanding: Bool) {
        let title = isRecommanding ? "Ne plus recommander" : "Recommander"
        mainView.actionButton.setTitle(title, for: .normal)
    }
    
    // MARK: - Api call
    private func deleteBook() {
        guard let book = book else { return }
        showIndicator(activityIndicator)
        
        libraryService.deleteBook(book: book) { [weak self] error in
            guard let self = self else { return }
            DispatchQueue.main.async {
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
    }
    
    private func updateBookStatus(_ state: Bool, fieldKey: BookDocumentKey) {
        guard let bookID = book?.etag else { return }
        showIndicator(activityIndicator)
        libraryService.setStatusTo(state, field: fieldKey, for: bookID) { [weak self] _ in
            guard let self = self else { return }
            self.hideIndicator(self.activityIndicator)
        }
    }
    
    private func recommnandBook(_ recommanded: Bool) {
        guard let book = book else { return  }
        updateBookStatus(recommanded, fieldKey: .recommanding)
        if recommanded == true {
            recommandationService.addToRecommandation(for: book) { [weak self] error in
                if let error = error {
                    self?.presentAlertBanner(as: .error, subtitle: error.description)
                }
            }
        } else {
            recommandationService.removeFromRecommandation(for: book) { [weak self] error in
                if let error = error {
                    self?.presentAlertBanner(as: .error, subtitle: error.description)
                }
            }
        }
    }
    
    // MARK: - Targets
    @objc private func favoriteButtonAction() {
        isFavorite.toggle()
        updateBookStatus(isFavorite, fieldKey: .favorite)
    }
    
    @objc private func recommandButtonAction() {
        isRecommandedStatus.toggle()
        recommnandBook(isRecommandedStatus)
    }
    
    @objc private func deleteBookAction() {
        presentAlert(withTitle: "Effacer un livre",
                     message: "Etes-vous sur de vouloir effacer ce livre?",
                     withCancel: true) { [weak self] _ in
            self?.deleteBook()
        }
    }
    
    @objc func handleTapGesture(_ sender: UITapGestureRecognizer) {
        guard let coverImage = coverImage else { return  }
        let bookCoverController = BookCoverViewController()
        bookCoverController.image = coverImage
        navigationController?.pushViewController(bookCoverController, animated: true)
    }
    
    // MARK: - Navigation
    @objc private func editBook() {
        let newBookController = NewBookViewController(libraryService: LibraryService())
        newBookController.newBook          = book
        newBookController.isEditingBook    = true
        newBookController.bookCardDelegate = self
        navigationController?.pushViewController(newBookController, animated: true)
    }
}
// MARK: - BookCardDelegate
extension BookCardViewController: BookCardDelegate {
    func fetchBookUpdate() {
        guard let bookID = book?.etag else { return }
        libraryService.getBook(for: bookID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let book):
                    self?.book = book
                    self?.presentAlertBanner(as: .customMessage("Mis à jour"))
                case .failure(let error):
                    self?.presentAlertBanner(as: .error, subtitle: error.description)
                }
            }
        }
    }
}
