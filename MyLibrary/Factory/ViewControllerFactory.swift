//
//  ViewControllerFactory.swift
//  MyLibrary
//
//  Created by Birkyboy on 20/01/2022.
//
import UIKit

/// Makes ViewControllers with their dependncies used thru the app.
class ViewControllerFactory {

    // MARK: Services
    private let libraryService = LibraryService()
    private let userService = UserService()
    private let categoryService = CategoryService()
    private let imageStorageService = ImageStorageService()
    private let recommendationService = RecommandationService()
    private let queryService = QueryService()
    private let feedbackManager = FeedbackManager()
    private let validation = Validation()
    private let formatter = Formatter()
    private let converter = Converter()
    private let categoryFormatter = CategoriesFormatter()

    private lazy var googleBooksService = GoogleBooksService(session: .default, validation: validation)

    private lazy var postNotificationService = FirebaseCloudMessagingService(session: .default)

    private lazy var accountService = AccountService(userService: userService,
                                                     libraryService: libraryService,
                                                     categoryService: categoryService)

    private lazy var messageService = MessageService(postNotificationService: postNotificationService)

    private lazy var commentService = CommentService(userService: userService)

    // MARK: Presenters
    private lazy var welcomeAccountPresenter = SetupAccountPresenter(accountService: accountService,
                                                                     validation: validation)

    private lazy var categoryPresenter = CategoryPresenter(categoryService: categoryService)

    private lazy var libraryPresenter = LibraryPresenter(libraryService: libraryService, queryService: queryService)

    private lazy var accountTabPresenter = AccountTabPresenter(userService: userService,
                                                               imageService: imageStorageService,
                                                               accountService: accountService)

    private lazy var homePresenter = HomePresenter(libraryService: libraryService,
                                                   categoryService: categoryService,
                                                   recommendationService: recommendationService)

    private lazy var commentPresenter = CommentPresenter(commentService: commentService,
                                                         messageService: messageService,
                                                         userService: userService,
                                                         formatter: formatter)

    private lazy var bookCardPresenter = BookCardPresenter(libraryService: libraryService,
                                                           recommendationService: recommendationService,
                                                           categoryService: categoryService,
                                                           formatter: formatter,
                                                           categoryFormatter: categoryFormatter)

    private lazy var newCategoryPresenter = NewCategoryPresenter(categoryService: categoryService)

    private lazy var newBookPresenter = NewBookPresenter(libraryService: libraryService,
                                                         formatter: formatter,
                                                         converter: converter,
                                                         validator: validation)
    private let onboardingPresenter = OnboardingPresenter()

    private lazy var searchPresenter = SearchPresenter(apiManager: googleBooksService)
    
    // MARK: Layout
    private let bookListLayout = BookListLayout()
    private let homeTabLayout = HomeTabLayout()
    private let onboardingLayout = OnboardingLayout()
    
    private func makeResultViewController() -> SearchViewController {
        SearchViewController(presenter: searchPresenter,
                             layoutComposer: bookListLayout)
    }
}

// MARK: - Factory
extension ViewControllerFactory: Factory {
    
    func makeHomeTabVC() -> UIViewController {
        return  HomeViewController(presenter: homePresenter,
                                   layoutComposer: homeTabLayout,
                                   factory: self)
    }
    
    func makeAccountTabVC() -> UIViewController {
        return AccountViewController(presenter: accountTabPresenter,
                                     feedbackManager: feedbackManager,
                                     factory: self)
    }
    
    func makeCategoryVC(isSelecting: Bool,
                        bookCategories: [String],
                        newBookDelegate: NewBookViewControllerDelegate?) -> UIViewController {
        return CategoriesViewController(isSelecting: isSelecting,
                                        selectedCategories: bookCategories,
                                        newBookDelegate: newBookDelegate,
                                        categoryPresenter: categoryPresenter,
                                        factory: self)
    }
    
    func makeNewCategoryVC(category: CategoryDTO?) -> UIViewController {
        return NewCategoryViewController(category: category,
                                         presenter: newCategoryPresenter)
    }
    
    func makeBookLibraryVC(with query: BookQuery?, title: String?) -> UIViewController {
        return BookLibraryViewController(currentQuery: query,
                                         title: title,
                                         presenter: libraryPresenter,
                                         layoutComposer: bookListLayout,
                                         factory: self)
    }
    
    func makeAccountSetupVC(for type: AccountInterfaceType) -> UIViewController {
        return AccountSetupViewController(presenter: welcomeAccountPresenter,
                                          interfaceType: type)
    }
    
    func makeNewBookVC(with book: ItemDTO?, isEditing: Bool, bookCardDelegate: BookCardDelegate?) -> UIViewController {
        return NewBookViewController(book: book,
                                     isEditing: isEditing,
                                     bookCardDelegate: bookCardDelegate,
                                     presenter: newBookPresenter,
                                     resultViewController: makeResultViewController(),
                                     factory: self)
    }
    
    func makeBookCardVC(book: ItemDTO) -> UIViewController {
        return BookCardViewController(book: book,
                                      libraryService: libraryService,
                                      recommendationService: recommendationService,
                                      presenter: bookCardPresenter,
                                      factory: self)
    }
    
    func makeBookDescriptionVC(description: String?, newBookDelegate: NewBookViewControllerDelegate?) -> UIViewController {
        return BookDescriptionViewController(bookDescription: description,
                                             newBookDelegate: newBookDelegate)
    }
    
    func makeCommentVC(with book: ItemDTO?) -> UIViewController {
        return CommentsViewController(book: book,
                                      presenter: commentPresenter,
                                      validation: validation)
    }
    
    func makeBookCoverDisplayVC(with image: UIImage) -> UIViewController {
        return BookCoverViewController(image: image)
    }
    
    func makeListVC(for dataType: ListDataType,
                    selectedData: String?,
                    newBookDelegate: NewBookViewControllerDelegate?) -> UIViewController {
        let presenter = ListPresenter(listDataType: dataType, formatter: formatter)

        return ListTableViewController(receivedData: selectedData,
                                       newBookDelegate: newBookDelegate,
                                       presenter: presenter)
    }
    
    func makeBarcodeScannerVC(delegate: BarcodeScannerDelegate?) -> UIViewController {
        return BarcodeScanViewController(barcodeDelegate: delegate)
    }
    
    func makeOnboardingVC() -> UIViewController {
        return OnboardingViewController(layoutComposer: onboardingLayout,
                                        presenter: onboardingPresenter)
    }
}
