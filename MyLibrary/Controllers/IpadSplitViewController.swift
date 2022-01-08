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
        setViewControllers()
        configure()
    }
    
    // MARK: - Setup
    private func configure() {
        self.primaryEdge = .leading
        self.primaryBackgroundStyle = .none
        self.showsSecondaryOnlyButton = true
        self.preferredPrimaryColumnWidthFraction = 0.5
    }
    
    private func setViewControllers() {
        let homeViewController = HomeViewController(libraryService: LibraryService(),
                                                    layoutComposer: HomeTabLayout(),
                                                    categoryService: CategoryService(),
                                                    recommendationService: RecommandationService())
        let newBookViewController = NewBookViewController(libraryService: LibraryService(),
                                                          converter: Converter(),
                                                          validator: Validator())
        newBookViewController.title = Text.ControllerTitle.newBook
        setViewController(newBookViewController, for: .primary)
        setViewController(UINavigationController(rootViewController: homeViewController), for: .secondary)
    }
}
