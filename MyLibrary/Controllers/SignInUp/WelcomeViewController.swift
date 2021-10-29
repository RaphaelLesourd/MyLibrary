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
//        let button = UIButton(type: .roundedRect)
//        button.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
//        button.setTitleColor(.white, for: .normal)
//        button.setTitle("Test Crash", for: [])
//        button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
//        view.addSubview(button)
    }
    
//    @objc func crashButtonTapped(_ sender: AnyObject) {
//          let numbers = [0]
//          let _ = numbers[1]
//      }
    
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
