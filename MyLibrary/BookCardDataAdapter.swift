//
//  BookCardData.swift
//  MyLibrary
//
//  Created by Birkyboy on 26/12/2021.
//

import UIKit

class BookCardData {
    // MARK: - Properties
    private let imageRetriever: ImageRetriever
    private let formatter: FormatterProtocol
    private let categoryService: CategoryServiceProtocol
    
    // MARK: - Initializer
    init(imageRetriever: ImageRetriever,
         formatter: FormatterProtocol,
         categoryService: CategoryService) {
        self.imageRetriever = imageRetriever
        self.formatter = formatter
        self.categoryService = categoryService
    }
}
// MARK: - BookCard adapater protocol
extension BookCardData: BookCardDataPresenter {
    
    func configure(_ view: BookCardMainView, with book: Item) {
        view.titleLabel.text = book.volumeInfo?.title?.capitalized  ?? ""
        view.authorLabel.text = book.volumeInfo?.authors?.joined(separator: ", ") ?? ""
        view.ratingView.rating = book.volumeInfo?.ratingsCount ?? 0
        view.descriptionLabel.text = book.volumeInfo?.volumeInfoDescription
        view.isbnLabel.text = book.volumeInfo?.industryIdentifiers?.first?.identifier ?? ""
        
        view.bookDetailView.languageView.infoLabel.text = formatter.formatCodeToName(from: book.volumeInfo?.language,
                                                                                     type: .language).capitalized
        view.bookDetailView.publisherNameView.infoLabel.text = book.volumeInfo?.publisher?.capitalized  ?? ""
        view.bookDetailView.publishedDateView.infoLabel.text = formatter.formatDateToYearString(for: book.volumeInfo?.publishedDate)
        view.bookDetailView.numberOfPageView.infoLabel.text = String(book.volumeInfo?.pageCount ?? 0)
        
        view.purchaseDetailView.titleLabel.text = Text.Book.price
        let currency = book.saleInfo?.retailPrice?.currencyCode
        let value = book.saleInfo?.retailPrice?.amount
        view.purchaseDetailView.purchasePriceLabel.text = formatter.formatDoubleToPrice(with: value,
                                                                                        currencyCode: currency)
        
        imageRetriever.getImage(for: book.volumeInfo?.imageLinks?.thumbnail, completion: { image in
            view.bookCover.image = image
            view.backgroundImage.image = image
        })
    }
    
    func setCategoriesLabel(_ view: BookCardMainView, for categoryIds: [String], bookOwnerID: String) {
        categoryService.getCategoryNameList(for: categoryIds, bookOwnerID: bookOwnerID) { categoryNames in
            let sortedCategories = categoryNames
                .map({ $0.uppercased() })
                .sorted()
                .joined(separator: ", ")
            view.categoryiesLabel.text = sortedCategories
        }
    }
    
}
