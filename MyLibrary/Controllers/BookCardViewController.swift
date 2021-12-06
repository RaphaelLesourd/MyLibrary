//
//  BookCardViewController.swift
//  MyBookLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit
import FirebaseAuth

protocol BookCardDelegate: AnyObject {
    func fetchBookUpdate()
}

class BookCardViewController: UIViewController {
    
    // MARK: - Properties
    private let mainView             = BookCardMainView()
    private let categoryService      = CategoryService.shared
    private let formatter            : FormatterProtocol
    private let imageLoader          : ImageRetriverProtocol
    private let libraryService       : LibraryServiceProtocol
    private let recommendationService: RecommendationServiceProtocol
    
    private var coverImage          : UIImage?
    private var isRecommandedStatus = false {
        didSet {
            setRecommandationButton(isRecommanding: isRecommandedStatus)
        }
    }
    private var isFavorite = false {
        didSet {
            setFavoriteIcon(isFavorite)
        }
    }
    var searchType: SearchType?
    var book: Item? {
        didSet {
            dispayBookData()
        }
    }
    // MARK: - Intializers
    init(libraryService: LibraryServiceProtocol,
         recommendationService: RecommendationServiceProtocol,
         formatter: FormatterProtocol,
         imageLoader: ImageRetriverProtocol) {
        self.libraryService        = libraryService
        self.recommendationService = recommendationService
        self.formatter             = formatter
        self.imageLoader           = imageLoader
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
        title = nil
        addNavigationBarButtons()
        setTargets()
        configureUI()
        mainView.commentView.animationView.play()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.largeTitleDisplayMode = .always
    }
    
    // MARK: - Setup
    private func addNavigationBarButtons() {
        mainView.editButton = UIBarButtonItem(image: Images.editBookIcon,
                                              style: .plain,
                                              target: self,
                                              action: #selector(editBook))
        mainView.activityIndicatorButton = UIBarButtonItem(customView: mainView.activityIndicator)
        navigationItem.rightBarButtonItems = [mainView.editButton, mainView.activityIndicatorButton]
    }
    
    private func setTargets() {
        mainView.actionButton.addTarget(self, action: #selector(recommandButtonAction), for: .touchUpInside)
        mainView.deleteBookButton.addTarget(self, action: #selector(deleteBookAction), for: .touchUpInside)
        mainView.favoriteButton.addTarget(self, action: #selector(favoriteButtonAction), for: .touchUpInside)
        mainView.commentView.goToCommentButton.addTarget(self, action: #selector(showComments), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        mainView.bookCover.addGestureRecognizer(tap)
    }
    
    func configureUI() {
        mainView.deleteBookButton.isHidden = searchType == .apiSearch
        if searchType == .apiSearch {
            mainView.actionButton.setTitle(Text.ButtonTitle.save, for: .normal)
        }
        if book?.ownerID != Auth.auth().currentUser?.uid || Networkconnectivity.shared.isReachable == false {
            mainView.deleteBookButton.isHidden = true
            mainView.actionButton.isHidden     = true
            mainView.favoriteButton.isHidden   = true
            navigationItem.rightBarButtonItems = [mainView.activityIndicatorButton]
        }
    }
    
    private func setFavoriteIcon(_ isFavorite: Bool) {
        mainView.favoriteButton.tintColor = isFavorite ? .favoriteColor : .notFavorite
    }
    
    private func setRecommandationButton(isRecommanding: Bool) {
        let title = isRecommanding ? "Ne plus recommander" : "Recommander"
        mainView.actionButton.setTitle(title, for: .normal)
        mainView.commentView.isHidden = !isRecommanding
    }
    
    // MARK: - Display Data
    private func dispayBookData() {
        mainView.titleLabel.text                                 = book?.volumeInfo?.title?.capitalized
        mainView.authorLabel.text                                = book?.volumeInfo?.authors?.first?.capitalized
        mainView.descriptionLabel.text                           = book?.volumeInfo?.volumeInfoDescription
        mainView.bookDetailView.publisherNameView.infoLabel.text = book?.volumeInfo?.publisher?.capitalized
        mainView.bookDetailView.publishedDateView.infoLabel.text = book?.volumeInfo?.publishedDate
        mainView.bookDetailView.numberOfPageView.infoLabel.text  = "\(book?.volumeInfo?.pageCount ?? 0)"
        mainView.bookDetailView.languageView.infoLabel.text      = formatter.formatCodeToName(from: book?.volumeInfo?.language,
                                                                                              type: .language).capitalized
        mainView.purchaseDetailView.titleLabel.text              = "Prix de vente"
        mainView.ratingView.rating                               = book?.volumeInfo?.ratingsCount ?? 0
        
        displayCategoryNames()
        displayBookPrice()
        displayBookCover()
        displayIsbn()
        setFavoriteState()
        setRecommandState()
    }
    
    private func displayBookCover() {
        imageLoader.getImage(for: book?.volumeInfo?.imageLinks?.thumbnail) { [weak self] image in
            self?.mainView.bookCover.image = image
            self?.coverImage = image
            self?.animateBackgroundImage()
        }
    }
    
    private func animateBackgroundImage() {
        mainView.backgroundImage.image = coverImage
        UIView.animate(withDuration: 7, delay: 0, options: [.curveEaseOut, .allowUserInteraction, .preferredFramesPerSecond60]) {
            let transformation = CGAffineTransform.identity.scaledBy(x: 1.2, y: 1.2).translatedBy(x: 0, y: -10)
            self.mainView.backgroundImage.transform = transformation
        }
    }
    
    private func displayBookPrice() {
        let currency = self.book?.saleInfo?.retailPrice?.currencyCode
        let price = self.book?.saleInfo?.retailPrice?.amount
        mainView.purchaseDetailView.purchasePriceLabel.text = formatter.formatCurrency(with: price, currencyCode: currency)
    }
   
    private func displayIsbn() {
        if let isbn = book?.volumeInfo?.industryIdentifiers?.first?.identifier {
            mainView.isbnLabel.text = Text.Book.isbn + isbn
        }
    }
    
    private func setFavoriteState() {
        if let favorite = self.book?.favorite {
            isFavorite = favorite
        }
    }
    
    private func setRecommandState() {
        if let recommand = self.book?.recommanding {
            isRecommandedStatus = recommand
        }
    }
    
    private func displayCategoryNames() {
        guard let categoryIds = book?.category,
              let bookOwnerID = book?.ownerID else { return }
        categoryService.getCategoryNameList(for: categoryIds, bookOwnerID: bookOwnerID) { [weak self] categoryNames in
            self?.mainView.categoryiesLabel.text = self?.formatter.joinArrayToString(categoryNames).uppercased()
        }
    }

    // MARK: - Api call
    private func deleteBook() {
        guard let book = book else { return }
        showIndicator(mainView.activityIndicator)
        
        libraryService.deleteBook(book: book) { [weak self] error in
            guard let self = self else { return }
            self.hideIndicator(self.mainView.activityIndicator)
            if let error = error {
                self.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            self.presentAlertBanner(as: .success, subtitle: "Livre éffacé de votre bibliothèque.")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func updateBookStatus(_ state: Bool, fieldKey: DocumentKey) {
        guard let bookID = book?.bookID else { return }
        showIndicator(mainView.activityIndicator)
        libraryService.setStatusTo(state, field: fieldKey, for: bookID) { [weak self] error in
            guard let self = self else { return }
            self.hideIndicator(self.mainView.activityIndicator)
            if let error = error {
                self.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
    
    private func recommnandBook(_ recommanded: Bool) {
        guard let book = book else { return }
        mainView.actionButton.displayActivityIndicator(true)
        guard recommanded == false else {
            recommendationService.addToRecommandation(for: book) { [weak self] error in
                self?.mainView.actionButton.displayActivityIndicator(false)
                if let error = error {
                    self?.presentAlertBanner(as: .error, subtitle: error.description)
                }
            }
            return
        }
        recommendationService.removeFromRecommandation(for: book) { [weak self] error in
            self?.mainView.actionButton.displayActivityIndicator(false)
            if let error = error {
                self?.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
    // MARK: - Targets
    @objc private func favoriteButtonAction() {
        isFavorite.toggle()
        updateBookStatus(isFavorite, fieldKey: .favorite)
    }
    
    @objc private func recommandButtonAction() {
        isRecommandedStatus.toggle()
        recommnandBook(isRecommandedStatus)
        updateBookStatus(isRecommandedStatus, fieldKey: .recommanding)
    }
    
    @objc private func deleteBookAction() {
        presentAlert(withTitle: "Effacer un livre",
                     message: "Etes-vous sur de vouloir effacer ce livre?",
                     withCancel: true) { [weak self] _ in
            self?.deleteBook()
        }
    }
    
    @objc func handleTapGesture(_ sender: UITapGestureRecognizer) {
        guard let coverImage = coverImage else { return  }
        let bookCoverController = BookCoverViewController()
        bookCoverController.image = coverImage
        navigationController?.pushViewController(bookCoverController, animated: true)
    }
    
    // MARK: - Navigation
    @objc private func editBook() {
        let newBookController = NewBookViewController(libraryService: LibraryService(),
                                                      formatter: Formatter(),
                                                      validator: Validator(),
                                                      imageLoader: ImageRetriver())
        newBookController.newBook          = book
        newBookController.isEditingBook    = true
        newBookController.bookCardDelegate = self
        navigationController?.pushViewController(newBookController, animated: true)
    }
    
    @objc private func showComments() {
        guard let book = book else { return }
        let commentsViewController = CommentsViewController(book: book,
                                                            commentService: CommentService(),
                                                            messageService: MessageService(),
                                                            validator: Validator())
        navigationController?.pushViewController(commentsViewController, animated: true)
    }
}
// MARK: - BookCardDelegate
extension BookCardViewController: BookCardDelegate {
    func fetchBookUpdate() {
        showIndicator(mainView.activityIndicator)
        guard let bookID = book?.bookID else { return }
        libraryService.getBook(for: bookID) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.hideIndicator(self.mainView.activityIndicator)
                switch result {
                case .success(let book):
                    self.book = book
                case .failure(let error):
                    self.presentAlertBanner(as: .error, subtitle: error.description)
                }
            }
        }
    }
}
