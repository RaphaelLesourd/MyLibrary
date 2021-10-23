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
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
    }
    /// Set up each viewControllers in the TabBar
    /// - SFSymbols are used for icon images.
    private func setupViewcontrollers() {
        let homeIconImage = UIImage(systemName: "books.vertical.fill")!
        let homeViewController = createController(for: HomeViewController(),
                                                     title: "Home",
                                                     image: homeIconImage)
        
        let newIconImage = UIImage(systemName: "plus.app.fill")!
        let newViewController = createController(for: NewViewController(),
                                                    title: "New",
                                                    image: newIconImage)
        
        let settingsIconImage = UIImage(systemName: "gear")!
        let settingsViewController = createController(for: SettingsViewController(),
                                                         title: "Settings",
                                                         image: settingsIconImage)
        viewControllers = [homeViewController,
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
        navController.navigationBar.prefersLargeTitles = false
        rootViewController.navigationItem.title = title
        return navController
    }
}
