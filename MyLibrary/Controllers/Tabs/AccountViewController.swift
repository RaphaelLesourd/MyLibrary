//
//  SettingsViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit
import PanModal

class AccountViewController: StaticTableViewController {

    // MARK: - Properties
    private let accountService: AccountServiceProtocol
    private let userService   : UserServiceProtocol
    private let imageService  : ImageStorageProtocol
    private let imageLoader   : ImageRetriverProtocol
    private var imagePicker   : ImagePicker?
    private var activityIndicator = UIActivityIndicatorView()
    
    // MARK: - Cell
    private lazy var profileCell  = ProfileStaticCell()
    private let signOutCell       = ButtonStaticCell(title: Text.ButtonTitle.signOut,
                                                     systemImage: "rectangle.portrait.and.arrow.right.fill",
                                                     tintColor: .systemPurple,
                                                     backgroundColor: .systemPurple)
    private let deleteAccountCell = ButtonStaticCell(title: "Supprimer le compte",
                                                     systemImage: "",
                                                     tintColor: .systemRed,
                                                     backgroundColor: .clear)
    
    // MARK: - Initializer
    init(accountService: AccountServiceProtocol,
         userService: UserServiceProtocol,
         imageService: ImageStorageProtocol,
         imageLoader: ImageRetriverProtocol = ImageRetriver()) {
        self.accountService = accountService
        self.userService    = userService
        self.imageService   = imageService
        self.imageLoader    = imageLoader
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        configureViewController()
        addNavigationBarButtons()
        composeTableView()
        setDelegates()
        setTargets()
        getProfileData()
    }
    
    // MARK: - Setup
    private func addNavigationBarButtons() {
        let activityIndicactorButton = UIBarButtonItem(customView: activityIndicator)
        navigationItem.rightBarButtonItems = [activityIndicactorButton]
    }
    
    private func configureViewController() {
        view.backgroundColor = .viewControllerBackgroundColor
        title = Text.ControllerTitle.account
    }
    
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
        AlertManager.presentAlert(withTitle: "Etes-vous sûr de vouloir vous déconnecter.",
                                  message: "",
                                  withCancel: true,
                                  on: self) { _ in
            self.signoutAccount()
        }
    }
    
    @objc private func deleteAccount() {
        AlertManager.presentAlert(withTitle: "Etes-vous sûr de vouloir supprimer votre compte?",
                     message: "Vous allez devoir vous re-authentifier.",
                     withCancel: true,
                     on: self) { _ in
            let controller = SigningViewController(userManager: AccountService(), validator: Validator(), interfaceType: .deleteAccount)
            self.presentPanModal(controller)
        }
    }
    
    // MARK: - Api call
    private func getProfileData() {
        profileCell.activityIndicator.startAnimating()
        
        userService.retrieveUser { [weak self] result in
            guard let self = self else { return }
            self.profileCell.activityIndicator.stopAnimating()
            switch result {
            case .success(let currentUser):
                guard let currentUser = currentUser else { return }
                self.updateProfileInfos(for: currentUser)
            case .failure(let error):
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
    
    private func saveUserName() {
        let username = profileCell.userNameTextField.text
        profileCell.activityIndicator.startAnimating()
        
        userService.updateUserName(with: username) { [weak self] error in
            guard let self = self else { return }
            self.profileCell.activityIndicator.stopAnimating()
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            AlertManager.presentAlertBanner(as: .success, subtitle: "Nom d'utilisateur mis à jour.")
        }
    }
    
    private func saveProfileImage(_ image: UIImage) {
        let profileImageData = image.jpegData(.medium)
        profileCell.activityIndicator.startAnimating()
        
        imageService.updateUserImage(for: profileImageData) { [weak self] error in
            self?.profileCell.activityIndicator.stopAnimating()
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            AlertManager.presentAlertBanner(as: .success, subtitle: "Photo de profil mise à jour.")
        }
    }
    
    private func signoutAccount() {
        showIndicator(activityIndicator)
        signOutCell.actionButton.displayActivityIndicator(true)
        accountService.signOut { [weak self] error in
            guard let self = self else { return }
            self.signOutCell.actionButton.displayActivityIndicator(false)
            self.hideIndicator(self.activityIndicator)
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            AlertManager.presentAlertBanner(as: .customMessage("A bientôt!"), subtitle: "")
        }
    }
    
    // MARK: - UI update
    private func updateProfileInfos(for currentUser: UserModel) {
        profileCell.emailLabel.text = "   \(currentUser.email)"
        profileCell.userNameTextField.text = currentUser.displayName
      
        imageLoader.getImage(for: currentUser.photoURL) { [weak self] image in
            self?.profileCell.profileImageButton.setImage(image, for: .normal)
        }
    }
}

// MARK: - ImagePicker Delegate
extension AccountViewController: ImagePickerDelegate {
        func didSelect(image: UIImage?) {
        guard let image = image else { return }
        profileCell.profileImageButton.setImage(image, for: .normal)
        saveProfileImage(image)
    }
}

// MARK: - TextField Delegate
extension AccountViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == profileCell.userNameTextField {
            saveUserName()
        }
        textField.resignFirstResponder()
        return true
    }
}
