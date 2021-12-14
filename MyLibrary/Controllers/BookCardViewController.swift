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
    private let mainView = BookCardMainView(frame: .zero, formatter: Formatter())
    private let categoryService: CategoryServiceProtocol
    private let imageLoader: ImageRetriverProtocol
    private let libraryService: LibraryServiceProtocol
    private let recommendationService: RecommendationServiceProtocol
    
    private var book: Item
    private var searchType: SearchType
    private var coverImage: UIImage?
    private var recommandedBook = false {
        didSet {
            setRecommandationButton(isRecommanding: recommandedBook)
        }
    }
    private var favoriteBook = false {
        didSet {
            setFavoriteIcon(favoriteBook)
        }
    }

    // MARK: - Intializers
    init(book: Item,
         searchType: SearchType,
         libraryService: LibraryServiceProtocol,
         recommendationService: RecommendationServiceProtocol,
         imageLoader: ImageRetriverProtocol,
         categoryService: CategoryServiceProtocol) {
        self.book = book
        self.searchType = searchType
        self.libraryService = libraryService
        self.recommendationService = recommendationService
        self.imageLoader = imageLoader
        self.categoryService = categoryService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
        view.backgroundColor = .secondarySystemBackground
        title = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.delegate = self
        addNavigationBarButtons()
        configureUI()
        mainView.displayBookInfos(with: book)
        displayBookCover()
        displayCategoryNames()
        setFavoriteState()
        setRecommandState()
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
   
    func configureUI() {
        mainView.deleteBookButton.isHidden = searchType == .apiSearch
        if searchType == .apiSearch {
            mainView.recommandButton.setTitle(Text.ButtonTitle.save, for: .normal)
        }
        if book.ownerID != Auth.auth().currentUser?.uid || Networkconnectivity.shared.isReachable == false {
            mainView.deleteBookButton.isHidden = true
            mainView.recommandButton.isHidden = true
            mainView.favoriteButton.isHidden = true
            navigationItem.rightBarButtonItems = [mainView.activityIndicatorButton]
        }
    }
    
    private func setFavoriteIcon(_ isFavorite: Bool) {
        mainView.favoriteButton.tintColor = isFavorite ? .favoriteColor : .notFavorite
    }
    
    private func setRecommandationButton(isRecommanding: Bool) {
        let title = isRecommanding ? "Ne plus recommander" : "Recommander"
        mainView.recommandButton.setTitle(title, for: .normal)
        mainView.commentView.isHidden = !isRecommanding
        isRecommanding ? mainView.commentView.animationView.play() : mainView.commentView.animationView.stop()
    }
    
    private func setFavoriteState() {
        if let favorite = self.book.favorite {
            favoriteBook = favorite
        }
    }
    
    private func setRecommandState() {
        if let recommand = self.book.recommanding {
            recommandedBook = recommand
        }
    }
    
    // MARK: - Api call
    private func deleteBook() {
        showIndicator(mainView.activityIndicator)
        
        libraryService.deleteBook(book: book) { [weak self] error in
            guard let self = self else { return }
            self.hideIndicator(self.mainView.activityIndicator)
            if let error = error {
                return AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
            }
            AlertManager.presentAlertBanner(as: .success, subtitle: "Livre éffacé de votre bibliothèque.")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func updateBookStatus(to state: Bool, for documentKey: DocumentKey) {
        guard let bookID = book.bookID else { return }
        showIndicator(mainView.activityIndicator)
      
        libraryService.setStatusTo(to: state, field: documentKey, for: bookID) { [weak self] error in
            guard let self = self else { return }
            self.hideIndicator(self.mainView.activityIndicator)
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
    
    private func recommnandBook(_ recommanded: Bool) {
        mainView.recommandButton.displayActivityIndicator(true)
        guard recommanded == false else {
            recommendationService.addToRecommandation(for: book) { [weak self] error in
                self?.mainView.recommandButton.displayActivityIndicator(false)
                if let error = error {
                    AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                }
            }
            return
        }
        recommendationService.removeFromRecommandation(for: book) { [weak self] error in
            self?.mainView.recommandButton.displayActivityIndicator(false)
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
    
    // MARK: - Configure view
    private func displayBookCover() {
        imageLoader.getImage(for: book.volumeInfo?.imageLinks?.thumbnail) { [weak self] image in
            guard let image = image else { return }
            self?.coverImage = image
            self?.mainView.configureBookCoverImage(with: image)
        }
    }
    
    private func displayCategoryNames() {
        guard let categoryIds = book.category,
              let bookOwnerID = book.ownerID else { return }
        categoryService.getCategoryNameList(for: categoryIds, bookOwnerID: bookOwnerID) { [weak self] categoryNames in
            self?.mainView.displayCategories(with: categoryNames)
        }
    }
    
    // MARK: - Navigation
    @objc private func editBook() {
        let newBookController = NewBookViewController(libraryService: LibraryService(),
                                                      formatter: Formatter(),
                                                      validator: Validator())
        newBookController.newBook = book
        newBookController.isEditingBook = true
        newBookController.bookCardDelegate = self
        navigationController?.show(newBookController, sender: nil)
    }
}
// MARK: - BookCardDelegate
extension BookCardViewController: BookCardDelegate {
    func fetchBookUpdate() {
        showIndicator(mainView.activityIndicator)
        guard let bookID = book.bookID,
              let ownerID = book.ownerID else { return }
        
        libraryService.getBook(for: bookID, ownerID: ownerID) { [weak self] result in
            guard let self = self else { return }
            
            self.hideIndicator(self.mainView.activityIndicator)
            switch result {
            case .success(let book):
                DispatchQueue.main.async {
                    self.book = book
                }
            case .failure(let error):
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
}
// MARK: Extension BookCardMainViewDelegate
extension BookCardViewController: BookCardMainViewDelegate {
    func favoriteButtonAction() {
        favoriteBook.toggle()
        updateBookStatus(to: favoriteBook, for: .favorite)
    }
    
    func recommandButtonAction() {
        recommandedBook.toggle()
        recommnandBook(recommandedBook)
        updateBookStatus(to: recommandedBook, for: .recommanding)
    }
    
    func deleteBookAction() {
        AlertManager.presentAlert(withTitle: "Effacer un livre",
                                  message: "Etes-vous sur de vouloir effacer ce livre?",
                                  withCancel: true,
                                  on: self) { [weak self] _ in
            self?.deleteBook()
        }
    }
    
    func showComments() {
        let commentsViewController = CommentsViewController(book: book,
                                                            commentService: CommentService(),
                                                            messageService: MessageService(),
                                                            validator: Validator())
        navigationController?.show(commentsViewController, sender: nil)
    }
    
    func showBookCover() {
        guard let coverImage = coverImage else { return  }
        let bookCoverController = BookCoverViewController(image: coverImage)
        navigationController?.show(bookCoverController, sender: nil)
    }
}
