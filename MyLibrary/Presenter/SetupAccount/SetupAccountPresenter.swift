//
//  WelcomeAccountPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 19/01/2022.
//

import FirebaseAuth

class SetupAccountPresenter {

    weak var view: SetupAccountPresenterView?
    var mainView: AccountMainView?
    private let accountService: AccountServiceProtocol
    private let validation: Validation
    private var userCredentials: AccountCredentials?

    init(accountService: AccountServiceProtocol,
         validation: Validation) {
        self.accountService = accountService
        self.validation = validation
    }

    // MARK: - Internal functions
    func handleAccountCredentials(for interfaceType: AccountInterfaceType) {
        switch interfaceType {
        case .login:
            loginToAccount()
        case .signup:
            createAccount()
        case .deleteAccount:
            deleteAccount()
        }
    }
    
    /// Reset password for user email
    /// - Parameters:
    /// - email : Optional String of the user email
    func resetPassword(with email: String?) {
        guard let email = email else {
            AlertManager.presentAlertBanner(as: .error, subtitle: Text.Banner.emptyEmail)
            return
        }
        view?.startActivityIndicator()

        accountService.sendPasswordReset(for: email) { [weak self] error in
            self?.view?.stopActivityIndicator()
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            AlertManager.presentAlertBanner(as: .customMessage(Text.Banner.resetPassordTitle),
                                            subtitle: Text.Banner.resetPasswordMessage)
            self?.view?.dismissViewController()
        }
    }
    
    /// Validate user email according to requirement.
    /// - Parameters:
    /// - text: String value of the user email
    func validateEmail(for text: String) {
        let validity = validation.validateEmail(text)
        view?.validateEmailTextField(with: validity)
    }
    
    /// Validate user password according to requirement.
    /// - Parameters:
    /// - text: String value of the user password
    func validatePassword(for text: String) {
        let validity = validation.validatePassword(text)
        view?.validatePasswordTextField(with: validity)
    }
    
    /// Validate user confirmation password according to requirement.
    /// - Parameters:
    /// - text: String value of the user confirmation password
    func validatePasswordConfirmation(for text: String) {
        let validity = validation.validatePassword(text)
        view?.validatePasswordConfirmationTextField(with: validity)
    }

    // MARK: - Private functions
    private func loginToAccount() {
        view?.startActivityIndicator()
        
        let userCredentials = makeAccountCredentials()
        accountService.login(with: userCredentials) { [weak self] error in
            self?.view?.stopActivityIndicator()
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            AlertManager.presentAlertBanner(as: .customMessage(Text.Banner.welcomeTitle),
                                            subtitle: (Auth.auth().currentUser?.displayName))
            self?.view?.dismissViewController()
        }
    }
    
    private func createAccount() {
        view?.startActivityIndicator()
        
        let userCredentials = makeAccountCredentials()
        accountService.createAccount(for: userCredentials) { [weak self] error in
            self?.view?.stopActivityIndicator()
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            AlertManager.presentAlertBanner(as: .customMessage(Text.Banner.accountOpen))
            self?.view?.dismissViewController()
        }
    }
    
    private func deleteAccount() {
        view?.startActivityIndicator()
        
        let userCredentials = makeAccountCredentials()
        self.accountService.deleteAccount(with: userCredentials) { [weak self] error in
            self?.view?.stopActivityIndicator()
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            AlertManager.presentAlertBanner(as: .success, subtitle: Text.Banner.accountDeleted)
            self?.view?.dismissViewController()
        }
    }
    
    private func makeAccountCredentials() -> AccountCredentials {
        return AccountCredentials(userName: mainView?.userNameTextField.text,
                                  email: mainView?.emailTextField.text ?? "",
                                  password: mainView?.passwordTextField.text ?? "",
                                  confirmPassword: mainView?.confirmPasswordTextField.text ?? "")
    }
}
