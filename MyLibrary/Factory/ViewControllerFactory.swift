//
//  ViewControllerFactory.swift
//  MyLibrary
//
//  Created by Birkyboy on 20/01/2022.
//
import UIKit

protocol Factory {
    func makeAccountTabViewcontroller() -> UIViewController
    func makeCategoryVC(settingCategory: Bool,
                        bookCategories: [String],
                        newBookDelegate: NewBookDelegate?) -> UIViewController
    func makeBookListVC(with query: BookQuery) -> UIViewController
    func makeAccountSetupController(for type: AccountInterfaceType) -> UIViewController
    func makeNewBookVC(with book: Item?, isEditing: Bool, bookCardDelegate: BookCardDelegate?) -> UIViewController
    func makeBookCardVC(book: Item, type: SearchType?, factory: Factory) -> UIViewController
    func makeBookDescriptionVC(description: String?, newBookDelegate: NewBookDelegate) -> UIViewController
    func makeCommentVC(with book: Item?) -> UIViewController
    func makeBookCoverDisplayVC(with image: UIImage) -> UIViewController
}

class ViewControllerFactory {
    // MARK: Services
    private let libraryService = LibraryService()
    private let userService = UserService()
    private let categoryService = CategoryService()
    private let imageRetriever = KFImageRetriever()
    private let imageStorageService = ImageStorageService()
    private let recommendationService = RecommandationService()
    private let feedbackManager = FeedbackManager()
    private let queryService = QueryService()
    private let commentService = CommentService()
    private let validation = Validator()
    private let formatter = Formatter()
    private let converter = Converter()
    
    private lazy var apiManager = ApiManager(session: .default, validator: validation)
    private lazy var accountService = AccountService(userService: userService,
                                                     libraryService: libraryService,
                                                     categoryService: categoryService)
    private lazy var messageService = MessageService(apiManager: apiManager)
    
    // MARK: Configurators
    private lazy var userCellConfigurator = UserCellConfiguration(imageRetriever: imageRetriever)
    private lazy var newBookConfiguration = NewBookConfiguration(imageRetriever: imageRetriever,
                                                                 converter: converter,
                                                                 formatter: formatter)
    private lazy var bookcardConfiguration = BookCardDataAdapter(formatter: formatter)
    private lazy var commentCellConfiguration = CommentCellConfiguration(imageRetriever: imageRetriever,
                                                                         formatter: formatter,
                                                                         commentService: commentService)
    private lazy var commentBookCellConfiguration = CommentBookCellConfiguration(imageRetriever: imageRetriever,
                                                                                 commentService: commentService)
    
    // MARK: Presenters
    private lazy var welcomeAccountPresenter = WelcomeAccountPresenter(accountService: accountService)
    private lazy var categoryPresenter = CategoryPresenter(categoryService: categoryService)
    private lazy var libraryPresenter = LibraryPresenter(libraryService: libraryService)
    private lazy var accountTabPresenter = AccountTabPresenter(userService: userService,
                                                               imageService: imageStorageService,
                                                               accountService: accountService)
    private lazy var homePresenter = HomePresenter(libraryService: libraryService,
                                                   categoryService: categoryService,
                                                   recommendationService: recommendationService)
    private lazy var commentPresenter = CommentPresenter(commentService: commentService,
                                                         messageService: messageService)
    private lazy var bookCardPresenter = BookCardPresenter(libraryService: libraryService,
                                                           recommendationService: recommendationService,
                                                           categoryService: categoryService)
    
    // MARK: Layout
    private let bookListLayout = BookListLayout()
    private let homeTabLayout = HomeTabLayout()
    
    private func makeResultViewController() -> SearchViewController {
        SearchViewController(presenter: SearchPresenter(apiManager: apiManager),
                             layoutComposer: bookListLayout)
    }
}

// MARK: - Factory
extension ViewControllerFactory: Factory {
   
    func makeHomeTabVC() -> UIViewController {
        return  HomeViewController(presenter: homePresenter,
                                   userCellConfigurator: userCellConfigurator,
                                   layoutComposer: homeTabLayout)
    }
    
    func makeAccountTabViewcontroller() -> UIViewController {
        return AccountViewController(presenter: accountTabPresenter,
                                     feedbackManager: feedbackManager)
    }
    
    func makeCategoryVC(settingCategory: Bool,
                        bookCategories: [String],
                        newBookDelegate: NewBookDelegate?) -> UIViewController {
        return CategoriesViewController(settingBookCategory: settingCategory,
                                        selectedCategories: bookCategories,
                                        newBookDelegate: newBookDelegate,
                                        categoryPresenter: categoryPresenter)
    }
    
    func makeBookListVC(with query: BookQuery) -> UIViewController {
        return BookLibraryViewController(currentQuery: query,
                                         queryService: queryService,
                                         presenter: libraryPresenter,
                                         layoutComposer: bookListLayout)
    }
    
    func makeAccountSetupController(for type: AccountInterfaceType) -> UIViewController {
        return AccountSetupViewController(presenter: welcomeAccountPresenter,
                                          validator: validation,
                                          interfaceType: type)
    }
    
    func makeNewBookVC(with book: Item?, isEditing: Bool, bookCardDelegate: BookCardDelegate?) -> UIViewController {
        return NewBookViewController(book: book,
                                     isEditing: isEditing,
                                     bookCardDelegate: bookCardDelegate,
                                     libraryService: libraryService,
                                     resultViewController: makeResultViewController(),
                                     converter: converter,
                                     validator: validation,
                                     newBookDataConfiguration: newBookConfiguration)
    }
    
    func makeBookCardVC(book: Item, type: SearchType?, factory: Factory) -> UIViewController {
        return BookCardViewController(book: book,
                                      searchType: type,
                                      dataAdapter: bookcardConfiguration,
                                      libraryService: libraryService,
                                      recommendationService: recommendationService,
                                      presenter: bookCardPresenter)
    }
    
    func makeBookDescriptionVC(description: String?, newBookDelegate: NewBookDelegate) -> UIViewController {
        return BookDescriptionViewController(bookDescription: description,
                                             newBookDelegate: newBookDelegate)
    }
    
    func makeCommentVC(with book: Item?) -> UIViewController {
        return CommentsViewController(book: book,
                                      presenter: commentPresenter,
                                      bookCellConfigurator: commentBookCellConfiguration,
                                      commentCellConfigurator: commentCellConfiguration,
                                      validator: validation)
    }
    
    func makeBookCoverDisplayVC(with image: UIImage) -> UIViewController {
        return BookCoverViewController(image: image)
    }
}
