//
//  BookCardData.swift
//  MyLibrary
//
//  Created by Birkyboy on 26/12/2021.
//

import UIKit

class BookCardDataPresenter {
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
    
    private func formattedString(for categories: [CategoryModel]) -> NSAttributedString {
        let text = NSMutableAttributedString()
        categories.forEach {
            let attachment = imageStringAttachment(for: $0, size: 11)
            let imgString = NSAttributedString(attachment: attachment)
            let name = $0.name?.uppercased() ?? ""
            text.append(imgString)
            text.append(NSAttributedString(string: "\u{00a0}\(name)    "))
        }
        return text
    }
    
    private func imageStringAttachment(for category: CategoryModel, size: CGFloat) -> NSTextAttachment {
        let color = UIColor(hexString: category.color ?? "FFFFFF")
        let image = Images.ButtonIcon.selectedCategoryBadge.withTintColor(color)
        let attachment = NSTextAttachment()
        attachment.bounds = CGRect(x: 0, y: 0, width: size, height: size)
        attachment.image = image
        return attachment
    }
}
// MARK: - BookCard presenter protocol
extension BookCardDataPresenter: BookCardPresenter {
    
    func configure(_ view: BookCardMainView, with book: Item) {
        view.titleLabel.text = book.volumeInfo?.title?.capitalized ?? ""
        view.authorLabel.text = book.volumeInfo?.authors?.joined(separator: ", ") ?? ""
        view.ratingView.rating = book.volumeInfo?.ratingsCount ?? 0
        view.descriptionLabel.text = book.volumeInfo?.volumeInfoDescription
        view.isbnLabel.text = Text.Book.isbn + (book.volumeInfo?.industryIdentifiers?.first?.identifier ?? "")
        
        view.bookDetailView.languageView.infoLabel.text = formatter.formatCodeToName(from: book.volumeInfo?.language,
                                                                                     type: .language).capitalized
        view.bookDetailView.publisherNameView.infoLabel.text = book.volumeInfo?.publisher?.capitalized  ?? ""
        view.bookDetailView.publishedDateView.infoLabel.text = formatter.formatDateToYearString(for: book.volumeInfo?.publishedDate)
        view.bookDetailView.numberOfPageView.infoLabel.text = String(book.volumeInfo?.pageCount ?? 0)
        
        view.purchaseDetailView.titleLabel.text = Text.Book.price
        let currency = book.saleInfo?.retailPrice?.currencyCode
        let value = book.saleInfo?.retailPrice?.amount
        view.purchaseDetailView.purchasePriceLabel.text = formatter.formatDoubleToPrice(with: value, currencyCode: currency)
        
        imageRetriever.getImage(for: book.volumeInfo?.imageLinks?.thumbnail, completion: { image in
            view.bookCover.image = image
            view.backgroundImage.image = image
            view.animateBookImage()
        })
    }
    
    func setCategoriesLabel(_ view: BookCardMainView, for categoryIds: [String], bookOwnerID: String) {
        categoryService.getCategoryList(for: categoryIds, bookOwnerID: bookOwnerID) { [weak self] categories in
            let categories = categories.sorted { $0.name?.lowercased() ?? "" < $1.name?.lowercased() ?? "" }
            view.categoryiesLabel.attributedText = self?.formattedString(for: categories)
        }
    }
}
