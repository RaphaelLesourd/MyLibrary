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
    let signoutButton = ActionButton(title: "Déconnexion", systemImage: "rectangle.portrait.and.arrow.right.fill", tintColor: .systemPurple)
    
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
        presentAlert(withTitle: "Etes-vous sûr de vouloir vous déconnecter.", message: "", withCancel: true) { [weak self] _ in
            self?.signoutAccount()
        }
    }
    
    private func signoutAccount() {
        userManger.logout { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.presentAlertBanner(as: .error, subtitle: error.localizedDescription)
                return
            }
            self.presentAlertBanner(as: .custom("A bientôt!"), subtitle: "")
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
