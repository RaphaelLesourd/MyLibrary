//
//  IpadSplitViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 02/01/2022.
//

import UIKit

class IpadSplitViewController: UISplitViewController {
    
    // MARK: - Initializers
    override init(style: UISplitViewController.Style) {
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setViewControllers()
    }
    
    // MARK: - Setup
    private func configure() {
        primaryEdge = .leading
        primaryBackgroundStyle = .none
        showsSecondaryOnlyButton = true
        preferredDisplayMode = UISplitViewController.DisplayMode.secondaryOnly
    }
    
    private func setViewControllers() {
        let homeViewController = HomeViewController(libraryService: LibraryService(),
                                                    layoutComposer: IpadHomeTabLayout(),
                                                    categoryService: CategoryService())
        
        let accountService = AccountService(userService: UserService(),
                                            libraryService: LibraryService(),
                                            categoryService: CategoryService())
        let feedBackManger = FeedbackManager(presentationController: homeViewController)
        let accountViewController = AccountViewController(accountService: accountService,
                                                          userService: UserService(),
                                                          imageService: ImageStorageService(),
                                                          feedbackManager: feedBackManger)
        let newBookViewController = NewBookViewController(libraryService: LibraryService(),
                                                          converter: Converter(),
                                                          validator: Validator())
        
        viewControllers = [accountViewController,
                           newBookViewController,
                           UINavigationController(rootViewController: homeViewController)]
    }
}
