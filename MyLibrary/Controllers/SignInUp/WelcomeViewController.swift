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
        mainView.loginButton.addTarget(self, action: #selector(presentLoginViewController), for: .touchUpInside)
        mainView.signupButton.addTarget(self, action: #selector(presentSignupViewController), for: .touchUpInside)
    }

    // MARK: - Navigation
    @objc private func presentLoginViewController() {
        let loginViewController = LoginViewController()
        presentPanModal(loginViewController)
    }
    
    @objc private func presentSignupViewController() {
        let signupViewController = SignupViewController()
        presentPanModal(signupViewController)
    }
}
