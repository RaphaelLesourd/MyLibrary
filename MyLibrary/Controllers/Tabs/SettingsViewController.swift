//
//  SettingsViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit
import PanModal
import FirebaseAuth

class SettingsViewController: StaticTableViewController {

    // MARK: - Properties
    var userManager: UserManagerProtocol
    private var imagePicker: ImagePicker?
    private let currentUserName = Auth.auth().currentUser?.displayName
    
    // MARK: - Cell
    private lazy var profileCell = ProfileStaticCell()
    private let signOutCell = ButtonStaticCell(title: "Déconnexion",
                                               systemImage: "rectangle.portrait.and.arrow.right.fill",
                                               tintColor: .systemPurple, backgroundColor: .systemPurple)
    private let deleteAccountCell = ButtonStaticCell(title: "Suppriner son compte",
                                                     systemImage: "",
                                                     tintColor: .systemRed,
                                                     backgroundColor: .clear)
    
    // MARK: - Initializer
    init(userManager: UserManagerProtocol) {
        self.userManager = userManager
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
        setTargets()
        setProfileData()
    }
    
    // MARK: - Setup
    private func setTargets() {
        profileCell.profileImageButton.addTarget(self, action: #selector(presentImagePicker), for: .touchUpInside)
        profileCell.saveProfileButton.addTarget(self, action: #selector(saveProfile), for: .touchUpInside)
        signOutCell.actionButton.addTarget(self, action: #selector(signoutRequest), for: .touchUpInside)
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
        presentAlert(withTitle: "Etes-vous sûr de vouloir vous déconnecter.", message: "", withCancel: true) { [weak self] _ in
            self?.signoutAccount()
        }
    }
    
    private func signoutAccount() {
        userManager.logout { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            self.presentAlertBanner(as: .customMessage("A bientôt!"), subtitle: "")
        }
    }
    
    @objc private func saveProfile() {
        saveUserName()
        view.endEditing(true)
    }
    
    // MARK: - Data
    private func setProfileData() {
        profileCell.emailLabel.text = "   \(Auth.auth().currentUser?.email ?? "")"
        profileCell.userNameTextField.text = currentUserName
    }
    
    private func saveUserName() {
        guard let userName = profileCell.userNameTextField.text, !userName.isEmpty else {
            presentAlertBanner(as: .error, subtitle: "Nom d'utilisateur vide")
            return
        }
        guard currentUserName != userName else {
            presentAlertBanner(as: .customMessage(userName), subtitle: "Il n'y rien de nouveau à sauver.")
            return
        }
        userManager.saveUserDisplayName(userName) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            self.presentAlertBanner(as: .success, subtitle: "Profil mis à jour.")
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
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - TableView Delegate
// extension SettingsViewController {
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        switch indexPath {
//        case [0, 0]:
//            let profileVC = ProfileViewController(userManager: UserManager())
//            presentPanModal(profileVC)
//        default:
//            return
//        }
//    }
// }
