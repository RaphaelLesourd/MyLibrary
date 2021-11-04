//
//  SettingsViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit
import PanModal
import FirebaseAuth
import XCTest

class SettingsViewController: StaticTableViewController {

    // MARK: - Properties
    private var accountService: AccountServiceProtocol
    private var userService: UserServiceProtocol
    private var imagePicker: ImagePicker?
    
    // MARK: - Cell
    private lazy var profileCell = ProfileStaticCell()
    private let signOutCell = ButtonStaticCell(title: "Déconnexion",
                                               systemImage: "rectangle.portrait.and.arrow.right.fill",
                                               tintColor: .systemPurple, backgroundColor: .systemPurple)
    private let deleteAccountCell = ButtonStaticCell(title: "Supprimer son compte",
                                                     systemImage: "",
                                                     tintColor: .systemRed,
                                                     backgroundColor: .clear)
    
    // MARK: - Initializer
    init(accountService: AccountServiceProtocol, userService: UserServiceProtocol) {
        self.accountService = accountService
        self.userService = userService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .viewControllerBackgroundColor
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        composeTableView()
        setDelegates()
        setTargets()
        setProfileData()
    }
    
    // MARK: - Setup
    private func setDelegates() {
        profileCell.userNameTextField.delegate = self
    }
    
    private func setTargets() {
        profileCell.profileImageButton.addTarget(self, action: #selector(presentImagePicker), for: .touchUpInside)
        signOutCell.actionButton.addTarget(self, action: #selector(signoutRequest), for: .touchUpInside)
        deleteAccountCell.actionButton.addTarget(self, action: #selector(deleteAccount), for: .touchUpInside)
    }
    
    /// Compose tableView cells and serctions using a 2 dimensional array of cells in  sections.
    private func composeTableView() {
        sections = [[profileCell],
                    [signOutCell],
                    [deleteAccountCell]]
    }
    
    // MARK: - Targets
    
    @objc private func presentImagePicker() {
        self.imagePicker?.present(from: profileCell.profileImageButton)
    }
    
    @objc private func signoutRequest() {
        presentAlert(withTitle: "Etes-vous sûr de vouloir vous déconnecter.", message: "", withCancel: true) { _ in
            self.signoutAccount()
        }
    }
    
    private func signoutAccount() {
        accountService.signOut { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            self.presentAlertBanner(as: .customMessage("A bientôt!"), subtitle: "")
        }
    }
    
    @objc private func deleteAccount() {
        presentAlert(withTitle: "Etes-vous sûr de vouloir supprimer votre compte?",
                     message: "Vous allez devoir vous re-authentifier.",
                     withCancel: true) { _ in
            
            let controller = SigningViewController(userManager: AccountService(), interfaceType: .deleteAccount)
            self.presentPanModal(controller)
        }
    }
    
    // MARK: - Data
    private func setProfileData() {
        userService.getSignedUser { [weak self] result in
            switch result {
            case .success(let currentUser):
                if let currentUser = currentUser {
                    self?.profileCell.emailLabel.text = "   \(currentUser.email)"
                    self?.profileCell.userNameTextField.text = currentUser.displayName
                }
            case .failure(let error):
                self?.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
    
    private func saveUserName() {
        let username = profileCell.userNameTextField.text
        userService.updateUserName(with: username) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            self.presentAlertBanner(as: .success, subtitle: "Nom d'utilisateur mis à jour.")
        }
    }
}
// MARK: - ImagePicker Delegate
extension SettingsViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        self.profileCell.profileImageButton.setImage(image, for: .normal)
    }
}

// MARK: - TextField Delegate
extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case profileCell.userNameTextField:
            saveUserName()
        default:
            return true
        }
        textField.resignFirstResponder()
        return true
    }
}
