//
//  IpadSplitViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 02/01/2022.
//

import UIKit

class IpadSplitViewController: UISplitViewController {

    private let factory: Factory

    override init(style: UISplitViewController.Style) {
        self.factory = ViewControllerFactory()
        super.init(style: style)
        showsSecondaryOnlyButton = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers()
    }
    
    private func setViewControllers() {
        let tabBarController = TabBarController()
        let homeViewController = factory.makeHomeTabVC()
        let newBookViewController = factory.makeNewBookVC()
        newBookViewController.title = Text.ControllerTitle.newBook

        setViewController(newBookViewController, for: .primary)
        setViewController(UINavigationController(rootViewController: homeViewController), for: .secondary)
        setViewController(tabBarController, for: .compact)
    }
}
