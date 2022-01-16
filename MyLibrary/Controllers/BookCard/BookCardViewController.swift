//
//  BookCardViewController.swift
//  MyBookLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit
import FirebaseAuth

class BookCardViewController: UIViewController {
    
    // MARK: - Properties
    var searchType: SearchType?
    
    private let mainView = BookCardMainView()
    private let libraryService: LibraryServiceProtocol
    private let recommendationService: RecommendationServiceProtocol
    private let bookCardPresenter: BookCardConfigure?
    private var book: Item
    private var recommanded = false {
        didSet {
            mainView.setRecommandedButtonAs(recommanded)
        }
    }
    private var favoriteBook = false {
        didSet {
            mainView.setFavoriteButtonAs(favoriteBook)
        }
    }
    
    // MARK: - Intializers
    init(book: Item,
         libraryService: LibraryServiceProtocol,
         recommendationService: RecommendationServiceProtocol) {
        self.book = book
        self.libraryService = libraryService
        self.recommendationService = recommendationService
        self.bookCardPresenter = BookCardConfiguration(imageRetriever: KFImageRetriever(),
                                                       formatter: Formatter(),
                                                       categoryService: CategoryService())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
        view.backgroundColor = .viewControllerBackgroundColor
        title = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.delegate = self
        addNavigationBarButtons()
        configureUI()
        displayBookData()
        displayCategoryNames()
        setBookFavoriteState()
        setBookRecommandState()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.largeTitleDisplayMode = .always
    }
    
    // MARK: - Setup
    private func addNavigationBarButtons() {
        let editButton = UIBarButtonItem(image: Images.NavIcon.editBookIcon,
                                         style: .plain,
                                         target: self,
                                         action: #selector(editBook))
        navigationItem.rightBarButtonItems = [editButton, mainView.activityIndicatorButton]
    }
    
    private func configureUI() {
        if searchType == .keywordSearch {
            mainView.recommandButton.setTitle(Text.ButtonTitle.save, for: .normal)
            mainView.deleteBookButton.isHidden = true
        }
        if book.ownerID != Auth.auth().currentUser?.uid || Networkconnectivity.shared.isReachable == false {
            mainView.deleteBookButton.isHidden = true
            mainView.recommandButton.isHidden = true
            mainView.favoriteButton.isHidden = true
            navigationItem.rightBarButtonItems = [mainView.activityIndicatorButton]
        }
    }
    
    private func setBookFavoriteState() {
        if let favorite = self.book.favorite {
            favoriteBook = favorite
        }
    }
    
    private func setBookRecommandState() {
        if let recommand = self.book.recommanding {
            recommanded = recommand
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
            AlertManager.presentAlertBanner(as: .success, subtitle: Text.Banner.bookDeleted)
            self.dismissController()
        }
    }
    
    private func updateBookStatus(to state: Bool, for documentKey: DocumentKey) {
        guard let bookID = book.bookID else { return }
        showIndicator(mainView.activityIndicator)
        
        libraryService.setStatus(to: state, field: documentKey, for: bookID) { [weak self] error in
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
    
    // MARK: - Data display
    private func displayBookData() {
        bookCardPresenter?.configure(mainView, with: book)
    }
    
    private func displayCategoryNames() {
        guard let categoryIds = book.category,
              let bookOwnerID = book.ownerID else { return }
        bookCardPresenter?.setCategoriesLabel(mainView,
                                              for: categoryIds,
                                              bookOwnerID: bookOwnerID)
    }
    
    // MARK: - Navigation
    @objc private func editBook() {
        let newBookController = NewBookViewController(libraryService: LibraryService(),
                                                      converter: Converter(),
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
        guard let bookID = book.bookID,
              let ownerID = book.ownerID else { return }
        showIndicator(mainView.activityIndicator)
        
        libraryService.getBook(for: bookID, ownerID: ownerID) { [weak self] result in
            guard let self = self else { return }
            
            self.hideIndicator(self.mainView.activityIndicator)
            switch result {
            case .success(let book):
                DispatchQueue.main.async {
                    self.book = book
                    self.displayBookData()
                    self.displayCategoryNames()
                    self.setBookRecommandState()
                }
            case .failure(let error):
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
}
// MARK: - BookCardMainViewDelegate
/// Accessible functions for the view thru delegate protocol
extension BookCardViewController: BookCardMainViewDelegate {
    
    func favoriteButtonAction() {
        favoriteBook.toggle()
        updateBookStatus(to: favoriteBook, for: .favorite)
    }
    
    func recommandButtonAction() {
        recommanded.toggle()
        recommnandBook(recommanded)
        updateBookStatus(to: recommanded, for: .recommanding)
    }
    
    func deleteBookAction() {
        AlertManager.presentAlert(title: Text.Alert.deleteBookTitle,
                                  message: Text.Alert.deleteBookMessage,
                                  cancel: true,
                                  on: self) { [weak self] _ in
            self?.deleteBook()
        }
    }
    
    func showCommentsViewController() {
        let commentsViewController = CommentsViewController(book: book,
                                                            commentService: CommentService(),
                                                            messageService: MessageService(),
                                                            validator: Validator())
        navigationController?.show(commentsViewController, sender: nil)
    }
    
    func showBookCover() {
        guard let coverImage = mainView.bookCover.image else { return  }
        let bookCoverController = BookCoverViewController(image: coverImage)
        navigationController?.show(bookCoverController, sender: nil)
    }
}
