//
//  WelcomeViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 25/10/2021.
//

import UIKit
import FirebaseAuth

class WelcomeViewController: UIViewController {
    
    // MARK: - Properties
    private let mainView = WelcomeControllerMainView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
        view.backgroundColor = .black
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTargets()
    }
    // MARK: - Setup
    private func configureTargets() {
        mainView.loginButton.addAction(UIAction(handler: { [weak self] _ in
            self?.presentAccountViewController(for: .login)
        }), for: .valueChanged)
        mainView.signupButton.addAction(UIAction(handler: { [weak self] _ in
            self?.presentAccountViewController(for: .signup)
        }), for: .valueChanged)
    }
    
    // MARK: - Targets
    private func presentAccountViewController(for type: AccountInterfaceType) {
        let accountService = AccountService(userService: UserService(),
                                            libraryService: LibraryService(),
                                            categoryService: CategoryService())
        let accountSetupController = AccountSetupViewController(accountService: accountService,
                                                           validator: Validator(),
                                                           interfaceType: type)
        present(accountSetupController, animated: true, completion: nil)
    }
}
