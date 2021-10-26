//
//  SettingsViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit
import SwiftUI

class SettingsViewController: UIViewController {

    // MARK: - Properties
    var userManger: UserManagerProtocol
    
    // MARK: - Initializer
    init(userManager: UserManagerProtocol) {
        self.userManger = userManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    let signoutButton = ActionButton(title: "Déconnexion", systemImage: "rectangle.portrait.and.arrow.right.fill", tintColor: .systemRed)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .viewControllerBackgroundColor
        setSignOutButtonConstraints()
        setTargets()
    }
    
    // MARK: - Setup
    private func setTargets() {
        signoutButton.addTarget(self, action: #selector(signoutRequest), for: .touchUpInside)
    }
    
    // MARK: - Targets
    @objc private func signoutRequest() {
        presentAlert(withTitle: "Etes-vous sûr de vouloir vous déconnecter.", message: "", withCancel: true) { _ in
            self.signoutAccount()
        }
    }
    
    private func signoutAccount() {
        userManger.logout { result in
            switch result {
            case .success(_):
                print("success")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
extension SettingsViewController {
    private func setSignOutButtonConstraints() {
        view.addSubview(signoutButton)
        signoutButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            signoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            signoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
}
