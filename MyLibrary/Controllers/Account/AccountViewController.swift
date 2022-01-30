//
//  SettingsViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit

class AccountViewController: UIViewController {

    private let feedbackManager: FeedbackManagerProtocol?
    private let mainView = AccountTabMainView()
    private var presenter: AccountTabPresenter
    private let factory: Factory
    private var imagePicker: ImagePicker?

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

    // MARK: Setup
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
}

// MARK: - ImagePicker Delegate
extension AccountViewController: ImagePickerDelegate {
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
    func presentSignOutAlert() {
        AlertManager.presentAlert(title: Text.Alert.signout,
                                  message: "",
                                  cancel: true) { _ in
            self.presenter.signoutAccount()
        }
    }
    
    func deleteAccount() {
        AlertManager.presentAlert(title: Text.Alert.deleteAccountTitle,
                                  message: Text.Alert.deleteAccountMessage,
                                  cancel: true) { _ in
            self.present(self.factory.makeAccountSetupVC(for: .deleteAccount), animated: true, completion: nil)
        }
    }
}
// MARK: - ContactView Delegate
extension AccountViewController: ContactViewDelegate {
    func presentMailComposer() {
        feedbackManager?.presentMail(on: self)
    }
}
// MARK: - AccountTab Presenter View
extension AccountViewController: AccountTabPresenterView {
    func configureMainView(with user: UserModelDTO) {
        mainView.configure(with: user)
    }
    
    func startActivityIndicator() {
        mainView.activityIndicator.startAnimating()
        mainView.profileView.increaseLoadingAnimationSpeed(true)
    }
    
    func stopActivityIndicator() {
        DispatchQueue.main.async {
            self.mainView.activityIndicator.stopAnimating()
            self.mainView.profileView.increaseLoadingAnimationSpeed(false)
        }
    }
    
    func animateSavebuttonIndicator(_ on: Bool) {
        mainView.profileView.accountView.signoutButton.toggleActivityIndicator(to: on)
    }
}
