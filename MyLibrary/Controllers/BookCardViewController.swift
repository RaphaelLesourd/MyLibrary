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
    }
    
    // MARK: - Setup
    private func addCommentButton() {
        let infoButton = UIBarButtonItem(image: UIImage(systemName: "quote.bubble"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(addComment))
        navigationItem.rightBarButtonItem = infoButton
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
        mainView.purchaseDetailView.titleLabel.text = "Date d'achat Juillet 1999"
       
        if let currency = self.book.saleInfo?.retailPrice?.currencyCode,
           let price = self.book.saleInfo?.retailPrice?.amount {
            mainView.purchaseDetailView.purchasePriceLabel.text = "\(currency.currencySymbol) \(price)"
        }
        
        mainView.currentResellPriceView.titleLabel.text = "Côte actuelle"
        mainView.currentResellPriceView.purchasePriceLabel.text = "--"
        if let isbn = book?.industryIdentifiers?.first?.identifier {
            mainView.isbnLabel.text = "ISBN \(isbn)"
        }
        mainView.commentLabel.text = "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    }
    
    // MARK: - Navigation
    @objc private func addComment() {
        
    }
  
}
