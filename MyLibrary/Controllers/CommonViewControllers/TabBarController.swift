//
//  TabBarViewController.swift
//  Le Baluchon
//
//  Created by Birkyboy on 05/08/2021.
//

import UIKit
import PanModal
import FirebaseAuth

/// Setup the app tab bar and add a navigation controller to the ViewController of each tabs.
class TabBarController: UITabBarController {
    
    private let libraryService = LibraryService()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupViewControllers()
    }
    // MARK: - Setup
    /// Set up the tabBar appearance with standard darkmode compatible colors.
    private func setupTabBar() {
        
        let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        tabBarAppearance.backgroundColor = .tertiarySystemBackground
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.appTintColor]
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor.appTintColor
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel]
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor.secondaryLabel
        UITabBar.appearance().standardAppearance = tabBarAppearance
        
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
    
    /// Set up each viewControllers in the TabBar
    /// - SFSymbols are used for icon images.
    private func setupViewControllers() {
        let homeViewController = createController(for: HomeViewController(libraryService: LibraryService(),
                                                                          layoutComposer: HomeViewControllerLayout()),
                                                     title: Text.ControllerTitle.home,
                                                     image: Images.homeIcon!)
        
        let libraryIconImage = Images.booksIcon ?? Images.openBookIcon!
        let libraryViewController = createController(for: BookLibraryViewController(currentQuery: .defaultAllBookQuery,
                                                                                    libraryService: LibraryService(),
                                                                                    layoutComposer: ListLayout()),
                                                        title: Text.ControllerTitle.myBooks,
                                                        image: libraryIconImage)
        
        let newViewController = createController(for: NewBookViewController(libraryService: LibraryService(),
                                                                            formatter: Formatter(),
                                                                            validator: Validator()),
                                                    title: Text.ControllerTitle.newBook,
                                                    image: Images.newBookIcon!)
        
        let accountViewController = createController(for: AccountViewController(accountService: AccountService(),
                                                                                libraryService: LibraryService(),
                                                                                userService: UserService(),
                                                                                imageService: ImageStorageService(),
                                                                                feedbackManager: FeedbackManager(presentationController: self)),
                                                        title: Text.ControllerTitle.account,
                                                        image: Images.accountIcon!)
        viewControllers = [homeViewController,
                           libraryViewController,
                           newViewController,
                           accountViewController]
    }
    /// Adds tab with an icon image and a title.
    /// - Parameters:
    ///   - rootViewController: Name of the ViewController assiciated to the tab
    ///   - title: Title name of the tab
    ///   - image: Name of the image
    /// - Returns: A modified ViewController
    private func createController(for rootViewController: UIViewController,
                                  title: String,
                                  image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        return navController
    }
}
