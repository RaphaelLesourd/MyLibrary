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
    
    var currentUser = Auth.auth().currentUser
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupViewcontrollers()
    }
    // MARK: - Setup
    /// Set up the tabBar appearance with standard darkmode compatible colors.
    private func setupTabBar() {
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.backgroundEffect = UIBlurEffect(style: .regular)
            appearance.stackedLayoutAppearance.selected.iconColor = .label
            appearance.stackedLayoutAppearance.normal.iconColor = .secondaryLabel
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel]
            tabBar.scrollEdgeAppearance = appearance
        } else {
            view.backgroundColor = .systemBackground
            tabBar.barTintColor = .systemBackground
            tabBar.tintColor = .label
        }
    }
    /// Set up each viewControllers in the TabBar
    /// - SFSymbols are used for icon images.
    private func setupViewcontrollers() {
        let homeViewController = createController(for: HomeViewController(),
                                                     title: Text.ControllerTitle.home,
                                                     image: Images.homeIcon!)
        
        let libraryIconImage = Images.booksIcon ?? Images.openBookIcon!
        let libraryViewController = createController(for: BookLibraryViewController(),
                                                        title: Text.ControllerTitle.myBooks,
                                                     image: libraryIconImage)
    
        let newViewController = createController(for: NewBookViewController(),
                                                       title: Text.ControllerTitle.newBook,
                                                       image: Images.newBookIcon!)
        
        let settingsIconImage = Images.newSettingsIcon  ?? Images.oldSettingsIcon!
        let settingsViewController = createController(for: SettingsViewController(userManager: UserManager()),
                                                         title: Text.ControllerTitle.settings,
                                                         image: settingsIconImage)
        viewControllers = [homeViewController,
                           libraryViewController,
                           newViewController,
                           settingsViewController]
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
