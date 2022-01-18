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
        showsSecondaryOnlyButton = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers()
    }
    
    // MARK: - Setup
    private func setViewControllers() {
        let tabBarController = TabBarController()
        let homePresenter = HomePresenter(libraryService: LibraryService(),
                                          categoryService: CategoryService(),
                                          recommendationService: RecommandationService())
        let homeViewController = HomeViewController(homePresenter: homePresenter,
                                                    layoutComposer: HomeTabLayout())
        let newBookViewController = NewBookViewController(libraryService: LibraryService(),
                                                          converter: Converter(),
                                                          validator: Validator())
        setViewController(newBookViewController, for: .primary)
        setViewController(UINavigationController(rootViewController: homeViewController), for: .secondary)
        setViewController(tabBarController, for: .compact)
    }
}
