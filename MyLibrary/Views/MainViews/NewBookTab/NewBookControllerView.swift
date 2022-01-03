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
        setButtonTargets()
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
    let recommendSwitchCell = SwitchCell(placeholder: Text.ButtonTitle.recommend)
    let saveButtonCell = ButtonStaticCell(title: Text.ButtonTitle.save,
                                          systemImage: "arrow.down.doc.fill",
                                          tintColor: .appTintColor,
                                          backgroundColor: .appTintColor)
    let eraseButtonCell = ButtonStaticCell(title: Text.ButtonTitle.delete,
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
                [recommendSwitchCell],
                [saveButtonCell, eraseButtonCell]
        ]
    }
    
    func setButtonTargets() {
        saveButtonCell.actionButton.addTarget(self, action: #selector(saveBook), for: .touchUpInside)
        eraseButtonCell.actionButton.addTarget(self, action: #selector(eraseBook), for: .touchUpInside)
        recommendSwitchCell.valueSwitch.addTarget(self, action: #selector(recommendBook), for: .valueChanged)
    }
    
    // MARK: - Display data
    func resetViews() {
        bookImageCell.pictureView.image = Images.emptyStateBookImage
        textFields.forEach { $0.text = nil }
        ratingCell.ratingSegmentedControl.selectedSegmentIndex = 0
    }
    
    // MARK: - Targets
    @objc private func saveBook() {
        delegate?.saveBook()
    }
    
    @objc private func eraseBook() {
        delegate?.clearData()
    }
    
    @objc private func recommendBook() {
        delegate?.isRecommending = recommendSwitchCell.valueSwitch.isOn
    }
}
