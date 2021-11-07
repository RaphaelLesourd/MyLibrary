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
    weak var newBookBookDelegate: NewBookDelegate?
    var searchType: SearchType?
    var book: Item
    
    // MARK: - Intializers
    init(book: Item, libraryService: LibraryServiceProtocol) {
        self.book = book
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
        dispayBookData()
        addCommentButton()
        setTargets()
        configureUi()
    }
    
    // MARK: - Setup
    private func addCommentButton() {
        let editButton = UIBarButtonItem(image: UIImage(systemName: "quote.bubble"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(editBook))
        navigationItem.rightBarButtonItem = editButton
    }
    
    private func setTargets() {
       // mainView.actionButton.addTarget(self, action: #selector(returnToNewBookController), for: .touchUpInside)
        mainView.deleteBookButton.addTarget(self, action: #selector(deleteBookAction), for: .touchUpInside)
    }
    
    private func configureUi() {
        mainView.commentLabel.isHidden = searchType == .apiSearch
        mainView.deleteBookButton.isHidden = searchType == .apiSearch
        let actionButtontitle = searchType == .apiSearch ? "Sauvegarder" : "Recommander"
        mainView.actionButton.setTitle(actionButtontitle, for: .normal)
    }
    
    // MARK: - Data
    private func dispayBookData() {
        let book = book.volumeInfo
        if let imageUrl = book?.imageLinks?.smallThumbnail, let url = URL(string: imageUrl) {
            mainView.bookCover.af.setImage(withURL: url,
                                           cacheKey: book?.industryIdentifiers?.first?.identifier,
                                           placeholderImage: Images.welcomeScreen,
                                           completion: nil)
        }
        mainView.titleLabel.text = book?.title
        mainView.authorLabel.text = book?.authors?.first
        mainView.categoryiesLabel.text = book?.categories?.joined(separator: " ")
        mainView.descriptionLabel.text = book?.volumeInfoDescription
        mainView.bookDetailView.publisherNameView.infoLabel.text = book?.publisher
        mainView.bookDetailView.publishedDateView.infoLabel.text = book?.publishedDate?.displayYearOnly
        mainView.bookDetailView.numberOfPageView.infoLabel.text = "\(book?.pageCount ?? 0)"
        mainView.bookDetailView.languageView.infoLabel.text = book?.language
        mainView.purchaseDetailView.titleLabel.text = ""
        mainView.purchaseDetailView.purchasePriceLabel.text = ""
       
        mainView.currentResellPriceView.titleLabel.text = "Prix de vente"
        if let currency = self.book.saleInfo?.retailPrice?.currencyCode,
           let price = self.book.saleInfo?.retailPrice?.amount {
            mainView.currentResellPriceView.purchasePriceLabel.text = "\(currency.currencySymbol) \(Int(price))"
        }
    
        if let isbn = book?.industryIdentifiers?.first?.identifier {
            mainView.isbnLabel.text = "ISBN \(isbn)"
        }
        mainView.commentLabel.text = ""
    }
    
    @objc private func deleteBookAction() {
        presentAlert(withTitle: "Effacer un livre", message: "Etes-vous sur de vouloir effacer ce livre?", withCancel: true) { [weak self] _ in
            self?.deleteBook()
        }
    }
    // MARK: - Api call
    private func deleteBook() {
        libraryService.deleteBook(book: book) { [weak self] error in
            if let error = error {
                self?.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            self?.presentAlertBanner(as: .success, subtitle: "Livre éffacé de votre bibliothèque.")
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Navigation
    @objc private func editBook() {
        let newBookViewController = NewBookViewController(libraryService: LibraryService())
        newBookViewController.newBook = book
        newBookViewController.isEditingBook = true
        navigationController?.pushViewController(newBookViewController, animated: true)
    }
}
