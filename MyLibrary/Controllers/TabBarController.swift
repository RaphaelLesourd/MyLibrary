//
//  TabBarViewController.swift
//  Le Baluchon
//
//  Created by Birkyboy on 05/08/2021.
//

import UIKit
import FirebaseAuth

/// Setup the app Tab Bar and add a navigation controller to the ViewController of each tabs.
class TabBarController: UITabBarController {
    
    // MARK: - Properties
    private let factory: Factory
    
    // MARK: - Initializer
    init(factory: Factory) {
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
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
        tabBarAppearance.backgroundColor = UIColor.tertiarySystemBackground.withAlphaComponent(0.5)
        
        let titleNormalColor: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel]
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = titleNormalColor
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor.secondaryLabel
        
        let titleSelectedColor: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: UIColor.appTintColor]
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = titleSelectedColor
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor.appTintColor
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
    
    /// Set up each viewControllers in the TabBar
    /// - SFSymbols are used for icon images.
    private func setupViewControllers() {
        // Home tab
        
        let homeViewController = createController(for: factory.makeHomeTabVC(),
                                                     title: Text.ControllerTitle.home,
                                                     image: Images.TabBarIcon.homeIcon)
        // Library tab
        let libraryViewController = createController(for: factory.makeBookListVC(with: .defaultAllBookQuery),
                                                        title: Text.ControllerTitle.myBooks,
                                                        image: Images.TabBarIcon.booksIcon)
        // Newbook tab
        let newViewController = createController(for: factory.makeNewBookVC(with: nil,
                                                                            isEditing: false,
                                                                            bookCardDelegate: nil),
                                                    title: Text.ControllerTitle.newBook,
                                                    image: Images.TabBarIcon.newBookIcon)
        // Account tab
        let accountViewController = createController(for: factory.makeAccountTabVC(),
                                                        title: Text.ControllerTitle.account,
                                                        image: Images.TabBarIcon.accountIcon)
        setViewControllers([homeViewController,
                            libraryViewController,
                            newViewController,
                            accountViewController],
                           animated: true)
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
