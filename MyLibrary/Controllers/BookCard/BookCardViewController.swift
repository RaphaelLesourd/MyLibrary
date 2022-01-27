//
//  BookCardViewController.swift
//  MyBookLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit
import FirebaseAuth

class BookCardViewController: UIViewController {
    
    // MARK: Properties
    private var searchType: SearchType?
    private let mainView = BookCardMainView()
    private let libraryService: LibraryServiceProtocol
    private let recommendationService: RecommendationServiceProtocol
    private var presenter: BookCardPresenter
    private var factory: Factory
    private var recommended = false {
        didSet {
            mainView.setRecommandedButtonAs(recommended)
        }
    }
    private var favoriteBook = false {
        didSet {
            mainView.setFavoriteButtonAs(favoriteBook)
        }
    }
    
    // MARK: Intializers
    init(book: ItemDTO,
         searchType: SearchType?,
         libraryService: LibraryServiceProtocol,
         recommendationService: RecommendationServiceProtocol,
         presenter: BookCardPresenter) {
        self.searchType = searchType
        self.libraryService = libraryService
        self.recommendationService = recommendationService
        self.factory = ViewControllerFactory()
        self.presenter = presenter
        self.presenter.book = book
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: Lifecycle
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
        presenter.view = self
        addNavigationBarButtons()
        configureUI()
        displayBookDetails()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.largeTitleDisplayMode = .always
    }
    
    // MARK: Setup
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
        if presenter.book?.ownerID != Auth.auth().currentUser?.uid || Networkconnectivity.shared.isReachable == false {
            mainView.deleteBookButton.isHidden = true
            mainView.recommandButton.isHidden = true
            mainView.favoriteButton.isHidden = true
            navigationItem.rightBarButtonItems = [mainView.activityIndicatorButton]
        }
    }
    
    // MARK: Data display
    private func displayBookDetails() {
        if let book = presenter.book {
            presenter.convertToBookRepresentable(from: book)
            presenter.fetchCategoryNames()
            presenter.fetchCategoryNames()
            setBookRecommandState()
            setBookFavoriteState()
        }
    }
    
    private func setBookFavoriteState() {
        if let favorite = self.presenter.book?.favorite {
            favoriteBook = favorite
        }
    }

    private func setBookRecommandState() {
        if let recommand = self.presenter.book?.recommanding {
            recommended = recommand
        }
    }
    
    // MARK: Navigation
    func showCommentsViewController() {
        navigationController?.show(factory.makeCommentVC(with: presenter.book), sender: nil)
    }
    
    func showBookCover() {
        guard let coverImage = mainView.bookCover.image else { return  }
        navigationController?.show(factory.makeBookCoverDisplayVC(with: coverImage), sender: nil)
    }
    
    @objc private func editBook() {
        let newBookController = factory.makeNewBookVC(with: presenter.book, isEditing: true, bookCardDelegate: self)
        navigationController?.show(newBookController, sender: nil)
    }
}

// MARK: - BookCard Delegate
extension BookCardViewController: BookCardDelegate {
    func fetchBookUpdate() {
        presenter.updateBook()
    }
}

// MARK: - BookCardMainView Delegate
/// Accessible functions for the view thru delegate protocol
extension BookCardViewController: BookCardMainViewDelegate {
    
    func favoriteButtonAction() {
        favoriteBook.toggle()
        presenter.updateStatus(state: favoriteBook, documentKey: .favorite)
    }
    
    func recommandButtonAction() {
        recommended.toggle()
        presenter.recommendBook(recommended)
        presenter.updateStatus(state: recommended, documentKey: .recommanding)
    }
    
    func deleteBookAction() {
        AlertManager.presentAlert(title: Text.Alert.deleteBookTitle,
                                  message: Text.Alert.deleteBookMessage,
                                  cancel: true,
                                  on: self) { [weak self] _ in
            self?.presenter.deleteBook()
        }
    }
}

// MARK: - BoorkCard PresenterView
extension BookCardViewController: BookCardPresenterView {
   
    func displayBook(with data: BookCardUI) {
        mainView.configure(with: data)
        setBookRecommandState()
        setBookFavoriteState()
    }
    
    func displayCategories(with list: NSAttributedString) {
        DispatchQueue.main.async {
            self.mainView.categoryiesLabel.attributedText = list
        }
    }
    
    func playRecommendButtonIndicator(_ play: Bool) {
        DispatchQueue.main.async {
            self.mainView.recommandButton.displayActivityIndicator(play)
        }
    }
    
    func showActivityIndicator() {
        showIndicator(mainView.activityIndicator)
    }
    
    func stopActivityIndicator() {
        DispatchQueue.main.async {
            self.hideIndicator(self.mainView.activityIndicator)
        }
    }
}
