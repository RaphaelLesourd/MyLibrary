//
//  SettingsViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit
import PanModal
import FirebaseAuth
import Kingfisher

class SettingsViewController: CommonStaticTableViewController {

    // MARK: - Properties
    private var accountService    : AccountServiceProtocol
    private var userService       : UserServiceProtocol
    private var imageService      : ImageStorageProtocol
    private var imagePicker       : ImagePicker?
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
    init(accountService: AccountServiceProtocol, userService: UserServiceProtocol, imageService: ImageStorageProtocol) {
        self.accountService = accountService
        self.userService    = userService
        self.imageService   = imageService
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
        title = Text.ControllerTitle.settings
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
        presentAlert(withTitle: "Etes-vous sûr de vouloir vous déconnecter.", message: "", withCancel: true) { _ in
            self.signoutAccount()
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
                self.presentAlertBanner(as: .error, subtitle: error.description)
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
                self.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            self.presentAlertBanner(as: .success, subtitle: "Nom d'utilisateur mis à jour.")
        }
    }
    
    private func saveProfileImage(_ image: UIImage) {
        let profileImageData = image.jpegData(.medium)
        profileCell.activityIndicator.startAnimating()
        
        imageService.updateUserImage(for:profileImageData) { [weak self] error in
            self?.profileCell.activityIndicator.stopAnimating()
            if let error = error {
                self?.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            self?.presentAlertBanner(as: .success, subtitle: "Photo de profil mise à jour.")
        }
    }
    
    private func signoutAccount() {
        showIndicator(activityIndicator)
        
        accountService.signOut { [weak self] error in
            guard let self = self else { return }
            self.hideIndicator(self.activityIndicator)
            if let error = error {
                self.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            self.presentAlertBanner(as: .customMessage("A bientôt!"), subtitle: "")
        }
    }
    
    // MARK: - UI update
    private func updateProfileInfos(for currentUser: CurrentUser) {
        profileCell.emailLabel.text = "   \(currentUser.email)"
        profileCell.userNameTextField.text = currentUser.displayName
        if let imageURL = URL(string: currentUser.photoURL) {
            profileCell.profileImageButton.kf.setImage(with: imageURL,
                                                       for: .normal,
                                                       placeholder: Images.emptyStateBookImage,
                                                       options: [.cacheOriginalImage, .progressiveJPEG(.default)],
                                                       completionHandler: nil)
        }
    }
}

// MARK: - ImagePicker Delegate
extension SettingsViewController: ImagePickerDelegate {    
    func didSelect(image: UIImage?) {
        guard let image = image else { return }
        profileCell.profileImageButton.setImage(image, for: .normal)
        saveProfileImage(image)
    }
}

// MARK: - TextField Delegate
extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == profileCell.userNameTextField {
            saveUserName()
        }
        textField.resignFirstResponder()
        return true
    }
}
