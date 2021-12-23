//
//  SettingsViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit
import FirebaseAuth

/// Class inherits from a base class seting a common static tableView
class AccountViewController: StaticTableViewController {
    
    // MARK: - Properties
    private let accountService: AccountServiceProtocol
    private let userService: UserServiceProtocol
    private let imageService: ImageStorageProtocol
    private var imagePicker: ImagePicker?
    private let feedbackManager: FeedbackSender?
    private let mainView = AccountControllerView(imageRetriever: KingFisherImageRetriever())
    
    // MARK: - Initializer
    init(accountService: AccountServiceProtocol,
         userService: UserServiceProtocol,
         imageService: ImageStorageProtocol,
         feedbackManager: FeedbackSender) {
        self.accountService = accountService
        self.userService = userService
        self.imageService = imageService
        self.feedbackManager = feedbackManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        sections = mainView.composeTableView()
        configureViewController()
        addNavigationBarButtons()
        setDelegates()
        getProfileData()
    }
    
    // MARK: - Setup
    private func addNavigationBarButtons() {
        let activityIndicactorButton = UIBarButtonItem(customView: mainView.activityIndicator)
        navigationItem.rightBarButtonItems = [activityIndicactorButton]
    }
    
    private func configureViewController() {
        view.backgroundColor = .viewControllerBackgroundColor
        title = Text.ControllerTitle.account
    }
    
    private func setDelegates() {
        mainView.displayNameCell.textField.delegate = self
        mainView.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 3 ? ("\(UIApplication.appName) " + Text.Misc.informations) : ""
    }
  
    // MARK: - Api call
    private func getProfileData() {
        mainView.activityIndicator.startAnimating()
        
        userService.retrieveUser { [weak self] result in
            guard let self = self else { return }
            self.mainView.activityIndicator.stopAnimating()
            switch result {
            case .success(let currentUser):
                guard let currentUser = currentUser else { return }
                self.mainView.updateProfileInfos(for: currentUser)
            case .failure(let error):
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
    
    private func saveUserName() {
        let username = mainView.displayNameCell.textField.text
        mainView.activityIndicator.startAnimating()
        
        userService.updateUserName(with: username) { [weak self] error in
            guard let self = self else { return }
            self.mainView.activityIndicator.stopAnimating()
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            AlertManager.presentAlertBanner(as: .success, subtitle: Text.Banner.userNameUpdated)
        }
    }
    
    private func saveProfileImage(_ image: UIImage) {
        let profileImageData = image.jpegData(.medium)
        mainView.activityIndicator.startAnimating()
        
        imageService.updateUserImage(for: profileImageData) { [weak self] error in
            self?.mainView.activityIndicator.stopAnimating()
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            AlertManager.presentAlertBanner(as: .success, subtitle: Text.Banner.profilePhotoUpdated)
        }
    }
    
    private func signoutAccount() {
        let userDisplayName = Auth.auth().currentUser?.displayName ?? ""
        showIndicator(mainView.activityIndicator)
        mainView.signOutCell.actionButton.displayActivityIndicator(true)
        
        accountService.signOut { [weak self] error in
            guard let self = self else { return }
            self.mainView.signOutCell.actionButton.displayActivityIndicator(false)
            self.hideIndicator(self.mainView.activityIndicator)
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            AlertManager.presentAlertBanner(as: .customMessage(Text.Banner.seeYouSoon), subtitle: userDisplayName)
        }
    }
}

// MARK: - ImagePicker Delegate
extension AccountViewController: ImagePickerDelegate {
    /// User the image return from the ImagePicker to set the profile image.
    func didSelect(image: UIImage?) {
        guard let image = image else { return }
        mainView.profileCell.profileImageButton.setImage(image, for: .normal)
        saveProfileImage(image)
    }
}

// MARK: - TextField Delegate
extension AccountViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == mainView.displayNameCell.textField {
            saveUserName()
        }
        textField.resignFirstResponder()
        return true
    }
}
// MARK: - Extension SettingViewProtocol

/// Accessible functions for the view thru delegate protocol
extension AccountViewController: AccountViewDelegate {
    
    func presentImagePicker() {
        self.imagePicker?.present(from: mainView.profileCell.profileImageButton)
    }
    
    func signoutRequest() {
        AlertManager.presentAlert(withTitle: Text.Alert.signout, message: "", withCancel: true, on: self) { _ in
            self.signoutAccount()
        }
    }
    
    func deleteAccount() {
        AlertManager.presentAlert(withTitle: Text.Alert.deleteAccountTitle,
                                  message: Text.Alert.deleteAccountMessage,
                                  withCancel: true,
                                  on: self) { _ in
            let accountService = AccountService(userService: UserService(),
                                                libraryService: LibraryService(),
                                                categoryService: CategoryService())
            let controller = AccountSetupViewController(accountService: accountService, validator: Validator(), interfaceType: .deleteAccount)
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func presentMailComposer() {
        feedbackManager?.presentMail()
    }
}
