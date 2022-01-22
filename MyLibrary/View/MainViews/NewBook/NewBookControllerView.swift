//
//  NewBookControllerView.swift
//  MyLibrary
//
//  Created by Birkyboy on 21/11/2021.
//

import UIKit

class NewBookControllerView {
    
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
    let languageCell = PickerViewStaticCell(placeholder: Text.Book.bookLanguage)
    
    let isbnCell = TextFieldStaticCell(placeholder: Text.Book.isbn,
                                       keyboardType: .numberPad)
    let purchasePriceCell = TextFieldStaticCell(placeholder: Text.Book.price,
                                                keyboardType: .decimalPad)
    let currencyCell = PickerViewStaticCell(placeholder: Text.Book.currency)
    
    let ratingCell = RatingInputStaticCell(placeholder: Text.Book.rating)
    let saveButtonCell = ButtonStaticCell(title: Text.ButtonTitle.save,
                                          systemImage: Images.ButtonIcon.done,
                                          tintColor: .appTintColor,
                                          backgroundColor: .appTintColor)
    let eraseButtonCell = ButtonStaticCell(title: Text.ButtonTitle.deleteNewBookInfos,
                                       tintColor: .systemRed,
                                       backgroundColor: .clear)
    
    lazy var descriptionCell = DisclosureTableViewCell(title: Text.Book.bookDescription)
    lazy var bookCategoryCell = DisclosureTableViewCell(title: Text.Book.bookCategories)
    
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
                [descriptionCell, numberOfPagesCell, languageCell, isbnCell],
                [ratingCell],
                [purchasePriceCell, currencyCell],
                [saveButtonCell],
                [eraseButtonCell]
        ]
    }
    
    private func addButtonActions() {
        saveButtonCell.actionButton.addAction(UIAction(handler: { [weak self] _ in
            self?.delegate?.saveBook()
        }), for: .touchUpInside)
        eraseButtonCell.actionButton.addAction(UIAction(handler: { [weak self] _ in
            self?.delegate?.clearData()
        }), for: .touchUpInside)
    }
    
    // MARK: - Display data
    func configure(with model: NewBookRepresentable) {
        bookTileCell.textField.text = model.title
        bookAuthorCell.textField.text = model.authors
        ratingCell.ratingSegmentedControl.selectedSegmentIndex = model.rating
        publisherCell.textField.text = model.publisher
        publishDateCell.textField.text = model.publishedDate
        purchasePriceCell.textField.text = model.price
        isbnCell.textField.text = model.isbn
        numberOfPagesCell.textField.text = model.pages
       
        bookImageCell.pictureView.getImage(for: model.coverImage) { [weak self] image in
            self?.bookImageCell.pictureView.image = image
        }
    }
    
    func resetViews() {
        bookImageCell.pictureView.image = Images.emptyStateBookImage
        textFields.forEach { $0.text = nil }
        ratingCell.ratingSegmentedControl.selectedSegmentIndex = 0
    }
}
