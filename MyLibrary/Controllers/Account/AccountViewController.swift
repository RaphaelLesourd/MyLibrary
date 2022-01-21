//
//  SettingsViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit
import FirebaseAuth

/// Class inherits from a base class seting a common static tableView
class AccountViewController: UIViewController {
    
    // MARK: - Properties
    private let feedbackManager: FeedbackManagerProtocol?
    private let mainView = AccountTabMainView()
  
    private let presenter: AccountTabPresenter
    private var imagePicker: ImagePicker?
    private let factory: Factory
    
    // MARK: - Initializer
    init(presenter: AccountTabPresenter,
         feedbackManager: FeedbackManagerProtocol) {
        self.presenter = presenter
        self.feedbackManager = feedbackManager
        self.factory = ViewControllerFactory()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
        view.backgroundColor = .viewControllerBackgroundColor
        title = Text.ControllerTitle.account
        presenter.getProfileData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        mainView.profileView.animationView.play()
        imagePicker = ImagePicker(presentationController: self,
                                  delegate: self,
                                  permissions: PermissionManager())
        addNavigationBarButtons()
        setDelegates()
    }

    // MARK: - Setup
    private func addNavigationBarButtons() {
        let activityIndicactor = UIBarButtonItem(customView: mainView.activityIndicator)
        navigationItem.rightBarButtonItems = [activityIndicactor]
    }
    
    private func setDelegates() {
        mainView.profileView.userNameTextfield.delegate = self
        mainView.profileView.delegate = self
        mainView.profileView.accountView.delegate = self
        mainView.contactView.delegate = self
    }
    
    private func animateLoader() {
        mainView.activityIndicator.startAnimating()
        mainView.profileView.loadingSpeed(true)
    }
    
    private func stopAnimatingLoaders() {
        DispatchQueue.main.async {
            self.mainView.activityIndicator.stopAnimating()
            self.mainView.profileView.loadingSpeed(false)
        }
    }
}
// MARK: - ImagePicker Delegate
extension AccountViewController: ImagePickerDelegate {
    /// User the image return from the ImagePicker to set the profile image.
    func didSelect(image: UIImage?) {
        guard let image = image else { return }
        mainView.profileView.profileImageButton.setImage(image, for: .normal)
        let imageData = image.jpegData(.medium)
        presenter.saveProfileImage(imageData)
    }
}
// MARK: - TextField Delegate
extension AccountViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == mainView.profileView.userNameTextfield {
            presenter.saveUserName(with: textField.text)
        }
        textField.resignFirstResponder()
        return true
    }
}
// MARK: - ProfileView Delegate
extension AccountViewController: ProfileViewDelegate {
    func presentImagePicker() {
        self.imagePicker?.present(from: mainView.profileView.profileImageButton)
    }
}
// MARK: - AccountView Delegate
extension AccountViewController: AccountViewDelegate {
    func signoutRequest() {
        AlertManager.presentAlert(title: Text.Alert.signout, message: "", cancel: true, on: self) { _ in
            self.presenter.signoutAccount()
        }
    }
    
    func deleteAccount() {
        AlertManager.presentAlert(title: Text.Alert.deleteAccountTitle,
                                  message: Text.Alert.deleteAccountMessage,
                                  cancel: true,
                                  on: self) { [weak self] _ in
            guard let self = self else { return }
            self.present(self.factory.makeAccountSetupController(for: .deleteAccount),
                          animated: true, completion: nil)
        }
    }
}
// MARK: - ContactView Delegate
extension AccountViewController: ContactViewDelegate {
    func presentMailComposer() {
        feedbackManager?.presentMail(on: self)
    }
}

extension AccountViewController: AccountTabPresenterView {
    func configureView(with user: UserModel) {
        DispatchQueue.main.async {
            self.mainView.profileView.emailLabel.text = user.email
            self.mainView.profileView.userNameTextfield.text = user.displayName
            
            let imageView = self.mainView.profileView.profileImageButton.imageView
            imageView?.getImage(for: user.photoURL, completion: { [weak self] image in
                self?.mainView.profileView.profileImageButton.setImage(image, for: .normal)
            })
        }
    }
    
    func showActivityIndicator() {
        mainView.activityIndicator.startAnimating()
        animateLoader()
    }
    
    func stopActivityIndicator() {
        mainView.activityIndicator.stopAnimating()
        stopAnimatingLoaders()
    }
    
    func animateSavebuttonIndicator(_ animate: Bool) {
        mainView.profileView.accountView.signoutButton.displayActivityIndicator(animate)
    }
}
