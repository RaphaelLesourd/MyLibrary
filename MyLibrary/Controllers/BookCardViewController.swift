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
    weak var newBookBookDelegate: NewBookDelegate?
    var searchType: SearchType?
    var book: Item
    
    // MARK: - Intializers
    init(book: Item) {
        self.book = book
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
        let infoButton = UIBarButtonItem(image: UIImage(systemName: "quote.bubble"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(addComment))
        navigationItem.rightBarButtonItem = infoButton
    }
    
    private func setTargets() {
        mainView.actionButton.addTarget(self, action: #selector(returnToNewBookController), for: .touchUpInside)
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
        mainView.bookDetailView.languageView.infoLabel.text = book?.language?.languageName
        mainView.purchaseDetailView.titleLabel.text = ""
        mainView.purchaseDetailView.purchasePriceLabel.text = ""
       
        mainView.currentResellPriceView.titleLabel.text = "Prix de vente"
        if let currency = self.book.saleInfo?.retailPrice?.currencyCode,
           let price = self.book.saleInfo?.retailPrice?.amount {
            mainView.currentResellPriceView.purchasePriceLabel.text = "\(currency.currencySymbol) \(price)"
        }
    
        if let isbn = book?.industryIdentifiers?.first?.identifier {
            mainView.isbnLabel.text = "ISBN \(isbn)"
        }
        mainView.commentLabel.text = "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla"
    }
    
    // MARK: - Navigation
    @objc private func addComment() {
        
    }
    
    @objc private func returnToNewBookController() {
        newBookBookDelegate?.newBook = book
    }
}
