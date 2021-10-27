//
//  ProfileViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 27/10/2021.
//

import UIKit
import PanModal

class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    private var userManager: UserManagerProtocol?
    private let mainView = ProfileControllerMainView()
    
    // MARK: - Lifecyle
    override func loadView() {
        view = mainView
        view.backgroundColor = .viewControllerBackgroundColor
        title = "Profil"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        setTargets()
    }
    
    // MARK: - Setup
    private func setDelegates() {
        mainView.userNameTextField.delegate = self
    }
    
    private func setTargets() {
        mainView.actionButton.addTarget(self, action: #selector(addUserName), for: .touchUpInside)
    }
    
    // MARK: - Targets
    @objc private func addUserName() {
        guard let userName = mainView.userNameTextField.text, !userName.isEmpty else {
            presentAlertBanner(as: .error, subtitle: "Nom d'utilisateur vide")
            return
        }
        dismiss(animated: true)
    }
}
// MARK: - TextField Delegate
extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
// MARK: - PanModal setup
extension ProfileViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(100)
    }
    
    var cornerRadius: CGFloat {
        return 20
    }
}
