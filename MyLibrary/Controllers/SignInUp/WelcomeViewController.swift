//
//  WelcomeViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 25/10/2021.
//

import UIKit
import PanModal

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
        mainView.loginButton.addTarget(self, action: #selector(presentLoginViewController(_:)), for: .touchUpInside)
        mainView.signupButton.addTarget(self, action: #selector(presentLoginViewController(_:)), for: .touchUpInside)
        mainView.termOfUserButton.addTarget(self, action: #selector(showTermOfUse), for: .touchUpInside)
    }

    // MARK: - Targets
    @objc private func presentLoginViewController(_ sender: UIButton) {
        let type: AccountInterfaceType = sender == mainView.loginButton ? .login : .signup
        let signingController = SigningViewController(userManager: UserManager(), interfaceType: type)
        presentPanModal(signingController)
    }
    
    @objc private func showTermOfUse() {
        let termOfUseController = TextInputViewController()
        presentPanModal(termOfUseController)
    }
}
