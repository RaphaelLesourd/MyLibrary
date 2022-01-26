//
//  NewBookPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 21/01/2022.
//
import Foundation

protocol NewBookPresenterView: AnyObject {
    func showSaveButtonActivityIndicator(_ show: Bool)
    func returnToPreviousVC()
    func displayBook(with model: NewBookRepresentable)
    func updateLanguageView(with language: String)
    func updateCurrencyView(with currency: String)
    func clearData()
}

class NewBookPresenter {
    
    weak var view: NewBookPresenterView?
    var mainView: NewBookControllerSubViews?
    var book: Item?
    var bookCategories: [String] = []
    var bookDescription: String?
    var isEditing = false
    var language: String?
    var currency: String?
    
    private let libraryService: LibraryServiceProtocol
    private let formatter: Formatter
    private let converter: ConverterProtocol
    private let validator: ValidatorProtocol
    
    init(libraryService: LibraryServiceProtocol,
         formatter: Formatter,
         converter: ConverterProtocol,
         validator: ValidatorProtocol) {
        self.libraryService = libraryService
        self.formatter = formatter
        self.converter = converter
        self.validator = validator
    }
    
    func saveBook(with imageData: Data) {
        let book = createBookDocument(from: mainView)
        view?.showSaveButtonActivityIndicator(true)
        
        libraryService.createBook(with: book, and: imageData) { [weak self] error in
            guard let self = self else { return }
            
            self.view?.showSaveButtonActivityIndicator(false)
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            AlertManager.presentAlertBanner(as: .success, subtitle: Text.Book.bookSaved)
            self.isEditing ? self.view?.returnToPreviousVC() : self.view?.clearData()
        }
    }
    
    func setBookData() {
        bookDescription = book?.volumeInfo?.volumeInfoDescription
        bookCategories = book?.category ?? []
        setBookLanguage(with: book?.volumeInfo?.language)
        setBookCurrency(with: book?.saleInfo?.retailPrice?.currencyCode)
        
        let bookRepresentable = createBookRepresentable()
        view?.displayBook(with: bookRepresentable)
    }
    
    func setBookLanguage(with code: String?) {
        guard let code = code else { return }
        language = code
        let data = formatter.formatCodeToName(from: code, type: .languages)
        view?.updateLanguageView(with: data.capitalized)
    }
    
    func setBookCurrency(with code: String?) {
        guard let code = code else { return }
        currency = code
        let data = formatter.formatCodeToName(from: code, type: .currency)
        view?.updateCurrencyView(with: data.uppercased())
    }
    
    /// Uses data enterred to create a book.
    ///  - Returns: Book object of type Item
    private func createBookDocument(from mainView: NewBookControllerSubViews?) -> Item {
        let isbn = mainView?.isbnCell.textField.text ?? "-"
        
        let volumeInfo = VolumeInfo(title: mainView?.bookTileCell.textField.text,
                                    authors: [mainView?.bookAuthorCell.textField.text ?? ""],
                                    publisher: mainView?.publisherCell.textField.text ?? "",
                                    publishedDate: mainView?.publishDateCell.textField.text ?? "",
                                    volumeInfoDescription: bookDescription,
                                    industryIdentifiers: [IndustryIdentifier(identifier: isbn)],
                                    pageCount: converter.convertStringToInt(mainView?.numberOfPagesCell.textField.text),
                                    ratingsCount: mainView?.ratingCell.ratingSegmentedControl.selectedSegmentIndex,
                                    imageLinks: ImageLinks(thumbnail: book?.volumeInfo?.imageLinks?.thumbnail),
                                    language: language ?? "")
        
        let price = converter.convertStringToDouble(mainView?.purchasePriceCell.textField.text)
        let saleInfo = SaleInfo(retailPrice: SaleInfoListPrice(amount: price,
                                                               currencyCode: currency ?? ""))
        return Item(bookID: book?.bookID,
                    favorite: book?.favorite,
                    ownerID: book?.ownerID,
                    recommanding: book?.recommanding,
                    volumeInfo: volumeInfo,
                    saleInfo: saleInfo,
                    timestamp: validator.validateTimestamp(for: book?.timestamp),
                    category: bookCategories)
    }
    
    private func createBookRepresentable() -> NewBookRepresentable {
        return NewBookRepresentable(title: book?.volumeInfo?.title?.capitalized,
                                    authors: book?.volumeInfo?.authors?.joined(separator: ", "),
                                    rating: book?.volumeInfo?.ratingsCount,
                                    publisher: book?.volumeInfo?.publisher?.capitalized,
                                    publishedDate: formatter.formatDateToYearString(for: book?.volumeInfo?.publishedDate),
                                    price: book?.saleInfo?.retailPrice?.amount,
                                    isbn: book?.volumeInfo?.industryIdentifiers?.first?.identifier,
                                    pages: book?.volumeInfo?.pageCount,
                                    coverImage: book?.volumeInfo?.imageLinks?.thumbnail)
    }
}
