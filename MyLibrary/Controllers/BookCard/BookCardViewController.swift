//
//  BookCardViewController.swift
//  MyBookLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit
import FirebaseAuth

class BookCardViewController: UIViewController {
    
    private let mainView = BookCardMainView()
    private let libraryService: LibraryServiceProtocol
    private let recommendationService: RecommendationServiceProtocol
    private var presenter: BookCardPresenter
    private var factory: Factory
    private let book: ItemDTO
    private var recommended = false {
        didSet {
            mainView.toggleRecommendButton(to: recommended)
        }
    }
    private var favoriteBook = false {
        didSet {
            mainView.toggleFavoriteButton(to: favoriteBook)
        }
    }

    init(book: ItemDTO,
         libraryService: LibraryServiceProtocol,
         recommendationService: RecommendationServiceProtocol,
         presenter: BookCardPresenter) {
        self.libraryService = libraryService
        self.recommendationService = recommendationService
        self.presenter = presenter
        self.book = book
        self.factory = ViewControllerFactory()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = mainView
        view.backgroundColor = .viewControllerBackgroundColor
        title = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.delegate = self
        presenter.view = self
        presenter.book = book
        mainView.showControlButtons(presenter.isBookEditable)
        addNavigationBarButtons()
        setBookRecommandStatus()
        setBookFavoriteStatus()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
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
        let itemsWithEditButton = [editButton, mainView.activityIndicatorButton]
        let indicatorOnly = [mainView.activityIndicatorButton]
        navigationItem.rightBarButtonItems = presenter.isBookEditable ? indicatorOnly : itemsWithEditButton
    }

    private func setBookFavoriteStatus() {
        if let favorite = self.presenter.book?.favorite {
            favoriteBook = favorite
        }
    }

    private func setBookRecommandStatus() {
        if let recommand = self.presenter.book?.recommanding {
            recommended = recommand
        }
    }
    
    // MARK: Navigation
    func presentCommentsViewController() {
        navigationController?.show(factory.makeCommentVC(with: presenter.book), sender: nil)
    }
    
    func displayBookCover() {
        guard let coverImage = mainView.bookCover.image else { return  }
        navigationController?.show(factory.makeBookCoverDisplayVC(with: coverImage), sender: nil)
    }
    
    @objc private func editBook() {
        let newBookController = factory.makeNewBookVC(with: presenter.book,
                                                      isEditing: true,
                                                      bookCardDelegate: self)
        navigationController?.show(newBookController, sender: nil)
    }
}

// MARK: - BookCard Delegate
extension BookCardViewController: BookCardDelegate {
    func updateBook() {
        presenter.fetchBookUpdate()
    }
}

// MARK: - BookCardMainView Delegate
/// Accessible functions for the view thru delegate protocol
extension BookCardViewController: BookCardMainViewDelegate {
    
    func toggleFavoriteBook() {
        favoriteBook.toggle()
        presenter.updateStatus(state: favoriteBook, documentKey: .favorite)
    }
    
    func toggleBookRecommendation() {
        recommended.toggle()
        presenter.recommendBook(recommended)
        presenter.updateStatus(state: recommended, documentKey: .recommanding)
    }
    
    func presentDeleteBookAlert() {
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
        setBookRecommandStatus()
        setBookFavoriteStatus()
    }
    
    func displayCategories(with list: NSAttributedString) {
        DispatchQueue.main.async {
            self.mainView.categoryiesLabel.attributedText = list
        }
    }
    
    func toggleRecommendButtonIndicator(on: Bool) {
        DispatchQueue.main.async {
            self.mainView.recommandButton.toggleActivityIndicator(to: on)
        }
    }
    
    func startActivityIndicator() {
        showIndicator(mainView.activityIndicator)
    }
    
    func stopActivityIndicator() {
        DispatchQueue.main.async {
            self.hideIndicator(self.mainView.activityIndicator)
        }
    }
}
