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

    private let factory: Factory

    init() {
        self.factory = ViewControllerFactory()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupTableViewTabs()
    }

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
    private func setupTableViewTabs() {

        let homeTab = makeTab(for: factory.makeHomeTabVC(),
                                 title: Text.ControllerTitle.home,
                                 image: Images.TabBarIcon.homeIcon)

        let libraryTab = makeTab(for: factory.makeBookLibraryVC(),
                                    title: Text.ControllerTitle.myBooks,
                                    image: Images.TabBarIcon.booksIcon)
        
        let newBookTab = makeTab(for: factory.makeNewBookVC(),
                                    title: Text.ControllerTitle.newBook,
                                    image: Images.TabBarIcon.newBookIcon)

        let accountTab = makeTab(for: factory.makeAccountTabVC(),
                                    title: Text.ControllerTitle.account,
                                    image: Images.TabBarIcon.accountIcon)
        setViewControllers([homeTab,
                            libraryTab,
                            newBookTab,
                            accountTab],
                           animated: true)
    }
    /// Make tab with an icon image and a title.
    /// - Parameters:
    ///   - rootViewController: Name of the ViewController assiciated to the tab
    ///   - title: Title name of the tab
    ///   - image: Name of the image
    /// - Returns: A modified ViewController
    private func makeTab(for rootViewController: UIViewController,
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
