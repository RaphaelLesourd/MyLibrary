//
//  TabBarViewController.swift
//  Le Baluchon
//
//  Created by Birkyboy on 05/08/2021.
//

import UIKit

/// Setup the app tab bar and add a navigation controller to the ViewController of each tabs.
class TabBarController: UITabBarController {
    
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
        let homeIconImage = UIImage(systemName: "house.fill")!
        let homeViewController = createController(for: HomeViewController(),
                                                     title: "Acceuil",
                                                     image: homeIconImage)
        
        let libraryIconImage = UIImage(systemName: "books.vertical.fill")!
        let libraryViewController = createController(for: BookLibraryViewController(),
                                                     title: "Mes livres",
                                                     image: libraryIconImage)
    
        let searchIconImage = UIImage(systemName: "magnifyingglass.circle.fill")!
        let searchViewController = createController(for: SearchViewController(),
                                                    title: "Chercher",
                                                    image: searchIconImage)
        
        let settingsIconImage = UIImage(systemName: "gearshape.fill")!
        let settingsViewController = createController(for: SettingsViewController(),
                                                         title: "Réglages",
                                                         image: settingsIconImage)
        viewControllers = [homeViewController,
                           libraryViewController,
                         //  newViewController,
                           searchViewController,
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
