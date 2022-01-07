//
//  NewBookDataPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 26/12/2021.
//

import UIKit

class NewBookDataPresenter {
    
    // MARK: - Properties
    private let imageRetriever: ImageRetriever
    private let converter: ConverterProtocol
    private let formatter: FormatterProtocol
    
    // MARK: - Initializer
    init(imageRetriever: ImageRetriever,
         converter: ConverterProtocol,
         formatter: FormatterProtocol) {
        self.imageRetriever = imageRetriever
        self.converter = converter
        self.formatter = formatter
    }
}
// MARK: - NewBook presenter protocol
extension NewBookDataPresenter: NewBookPresenter {
    
    func configure(_ view: NewBookControllerView, with book: Item) {
        view.bookTileCell.textField.text = book.volumeInfo?.title?.capitalized ?? ""
        view.bookAuthorCell.textField.text = book.volumeInfo?.authors?.joined(separator: ", ") ?? ""
        view.ratingCell.ratingSegmentedControl.selectedSegmentIndex = book.volumeInfo?.ratingsCount ?? 0
        view.publisherCell.textField.text = book.volumeInfo?.publisher?.capitalized ?? ""
        view.publishDateCell.textField.text = formatter.formatDateToYearString(for: book.volumeInfo?.publishedDate)
        view.purchasePriceCell.textField.text = String(book.saleInfo?.retailPrice?.amount ?? 0)
        view.isbnCell.textField.text = book.volumeInfo?.industryIdentifiers?.first?.identifier ?? ""
        view.numberOfPagesCell.textField.text = String(book.volumeInfo?.pageCount ?? 0)
       
        imageRetriever.getImage(for: book.volumeInfo?.imageLinks?.thumbnail, completion: { image in
            view.bookImageCell.pictureView.image = image
        })
    }
}
