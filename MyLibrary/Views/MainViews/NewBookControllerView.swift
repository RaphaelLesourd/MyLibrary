//
//  NewBookControllerView.swift
//  MyLibrary
//
//  Created by Birkyboy on 21/11/2021.
//

import Foundation
import UIKit

class NewBookControllerView {
    
    // MARK: - Subviews
    let commonStaticTableViewController = CommonStaticTableViewController()
    
    let activityIndicator = UIActivityIndicatorView()
    var searchController  = UISearchController()
    
    let bookImageCell  = ImageStaticCell()
    let bookTileCell   = TextFieldStaticCell(placeholder: Text.Book.bookName)
    let bookAuthorCell = TextFieldStaticCell(placeholder: Text.Book.authorName)
    
    lazy var bookCategoryCell = commonStaticTableViewController.createDefaultCell(with: Text.Book.bookCategories)
    
    let publisherCell   = TextFieldStaticCell(placeholder: Text.Book.publisher)
    let publishDateCell = TextFieldStaticCell(placeholder: Text.Book.publishedDate)
    
    let isbnCell             = TextFieldStaticCell(placeholder: Text.Book.isbn, keyboardType: .numberPad)
    let numberOfPagesCell    = TextFieldStaticCell(placeholder: Text.Book.numberOfPages, keyboardType: .numberPad)
    let languageCell         = PickerViewStaticCell(placeholder: Text.Book.bookLanguage)
    lazy var descriptionCell = commonStaticTableViewController.createDefaultCell(with: Text.Book.bookDescription)
    
    let purchasePriceCell = TextFieldStaticCell(placeholder: Text.Book.price, keyboardType: .decimalPad)
    let currencyCell      = PickerViewStaticCell(placeholder: Text.Book.currency)
    let ratingCell        = RatingInputStaticCell(placeholder: Text.Book.rating)
    let saveButtonCell    = ButtonStaticCell(title: Text.ButtonTitle.save,
                                             systemImage: "arrow.down.doc.fill",
                                             tintColor: .appTintColor,
                                             
                                             backgroundColor: .appTintColor)
    
    lazy var textFields = [bookTileCell.textField,
                           bookAuthorCell.textField,
                           publisherCell.textField,
                           publishDateCell.textField,
                           isbnCell.textField,
                           numberOfPagesCell.textField,
                           purchasePriceCell.textField]
    
    // MARK: - Sections
    func composeTableView() -> [[UITableViewCell]] {
        return [[bookImageCell],
                [bookTileCell, bookAuthorCell],
                [bookCategoryCell],
                [publisherCell, publishDateCell],
                [descriptionCell, numberOfPagesCell, languageCell, isbnCell],
                [ratingCell],
                [purchasePriceCell, currencyCell],
                [saveButtonCell]]
    }
}
