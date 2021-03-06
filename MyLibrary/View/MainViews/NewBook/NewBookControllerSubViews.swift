//
//  NewBookControllerView.swift
//  MyLibrary
//
//  Created by Birkyboy on 21/11/2021.
//

import UIKit

class NewBookControllerSubViews {
    
    weak var delegate: NewBookViewDelegate?
   
    init() {
        addButtonActions()
    }
    
    // MARK: - Subviews
    let activityIndicator = UIActivityIndicatorView()
    var searchController = UISearchController()
    
    let bookImageCell = ImageStaticCell()
    let bookTileCell = TextFieldStaticCell(placeholder: Text.Book.bookName)
    let bookAuthorCell = TextFieldStaticCell(placeholder: Text.Book.authorName)
    
    let publisherCell = TextFieldStaticCell(placeholder: Text.Book.publisher)
    let publishDateCell = TextFieldStaticCell(placeholder: Text.Book.publishedDate)
    let numberOfPagesCell = TextFieldStaticCell(placeholder: Text.Book.numberOfPages,
                                                keyboardType: .numberPad)
    let languageCell = DisclosureTableViewCell(title: Text.Book.bookLanguage,
                                               icon: Images.ButtonIcon.language)
    
    let isbnCell = TextFieldStaticCell(placeholder: Text.Book.isbn,
                                       keyboardType: .numberPad)
    let purchasePriceCell = TextFieldStaticCell(placeholder: Text.Book.price,
                                                keyboardType: .decimalPad)
    let currencyCell = DisclosureTableViewCell(title: Text.Book.currency,
                                               icon: Images.ButtonIcon.currencies)
    
    let ratingCell = RatingInputStaticCell()
    let saveButtonCell = ButtonStaticCell(title: Text.ButtonTitle.save,
                                          systemImage: Images.ButtonIcon.done,
                                          tintColor: .appTintColor,
                                          backgroundColor: .appTintColor)
    let eraseButtonCell = ButtonStaticCell(title: Text.ButtonTitle.deleteNewBookInfos,
                                       tintColor: .systemRed,
                                       backgroundColor: .clear)
    
    lazy var descriptionCell = DisclosureTableViewCell(title: Text.Book.bookDescription,
                                                       icon: Images.ButtonIcon.quote)
    lazy var bookCategoryCell = DisclosureTableViewCell(title: Text.Book.bookCategories,
                                                        icon: Images.ButtonIcon.selectedCategoryBadge)
    
    lazy var textFields = [bookTileCell.textField,
                           bookAuthorCell.textField,
                           publisherCell.textField,
                           publishDateCell.textField,
                           isbnCell.textField,
                           numberOfPagesCell.textField,
                           purchasePriceCell.textField]
    
    // MARK: - Configure
    func composeTableView() -> [[UITableViewCell]] {
        return [[bookImageCell],
                [bookTileCell, bookAuthorCell],
                [bookCategoryCell],
                [publisherCell, publishDateCell],
                [descriptionCell, numberOfPagesCell, isbnCell],
                [languageCell],
                [ratingCell],
                [purchasePriceCell, currencyCell],
                [saveButtonCell],
                [eraseButtonCell]
        ]
    }
    
    func configure(with model: NewBookUI) {
        bookTileCell.textField.text = model.title
        bookAuthorCell.textField.text = model.authors
        ratingCell.ratingSegmentedControl.selectedSegmentIndex = model.rating ?? 0
        publisherCell.textField.text = model.publisher
        publishDateCell.textField.text = model.publishedDate
        isbnCell.textField.text = model.isbn
        if let price = model.price {
            purchasePriceCell.textField.text = String(price)
        }
        if let pages = model.pages {
            numberOfPagesCell.textField.text = String(pages)
        }
        bookImageCell.pictureView.getImage(for: model.coverImage) { [weak self] image in
            self?.bookImageCell.pictureView.image = image
        }
    }
    
    func reset() {
        bookImageCell.pictureView.image = Images.emptyStateBookImage
        textFields.forEach { $0.text = nil }
        ratingCell.ratingSegmentedControl.selectedSegmentIndex = 0
        searchController.isActive = false
        languageCell.textLabel?.text = Text.Book.bookLanguage
        currencyCell.textLabel?.text = Text.Book.currency
    }
    
    private func addButtonActions() {
        saveButtonCell.actionButton.addAction(UIAction(handler: { [weak self] _ in
            self?.delegate?.saveBook()
        }), for: .touchUpInside)
        eraseButtonCell.actionButton.addAction(UIAction(handler: { [weak self] _ in
            self?.delegate?.clearData()
        }), for: .touchUpInside)
    }
    
}
