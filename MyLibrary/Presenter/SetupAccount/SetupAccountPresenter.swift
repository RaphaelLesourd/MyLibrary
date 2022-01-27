//
//  WelcomeAccountPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 19/01/2022.
//

import FirebaseAuth

class SetupAccountPresenter {
    
    // MARK: - Properties
    weak var view: SetupAccountPresenterView?
    var mainView: AccountMainView?
    private let accountService: AccountServiceProtocol
    private let validation: Validator
    private var userCredentials: AccountCredentials?
    
    // MARK: - Initializer
    init(accountService: AccountServiceProtocol,
         validation: Validator) {
        self.accountService = accountService
        self.validation = validation
    }
    
    func handlesAccountCredentials(for interfaceType: AccountInterfaceType) {
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
            AlertManager.presentAlertBanner(as: .error,
                                            subtitle: Text.Banner.emptyEmail)
            return
        }
        view?.showActivityIndicator()
        accountService.sendPasswordReset(for: email) { [weak self] error in
            self?.view?.stopActivityIndicator()
            if let error = error {
                AlertManager.presentAlertBanner(as: .error,
                                                subtitle: error.description)
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
        view?.updateEmailTextField(valid: validity)
    }
    
    /// Validate user password according to requirement.
    /// - Parameters:
    /// - text: String value of the user password
    func validatePassword(for text: String) {
        let validity = validation.validatePassword(text)
        view?.updatePasswordTextField(valid: validity)
    }
    
    /// Validate user confirmation password according to requirement.
    /// - Parameters:
    /// - text: String value of the user confirmation password
    func validatePasswordConfirmation(for text: String) {
        let validity = validation.validatePassword(text)
        view?.updatePasswordConfirmationTextField(valid: validity)
    }
}

extension SetupAccountPresenter: SetupAccountPresenting {
    
    private func loginToAccount() {
        view?.showActivityIndicator()
        
        let userCredentials = setAccountCredentials()
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
        view?.showActivityIndicator()
        
        let userCredentials = setAccountCredentials()
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
        view?.showActivityIndicator()
        
        let userCredentials = setAccountCredentials()
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
    
    private func setAccountCredentials() -> AccountCredentials {
        return AccountCredentials(userName: mainView?.userNameTextField.text,
                                  email: mainView?.emailTextField.text ?? "",
                                  password: mainView?.passwordTextField.text ?? "")
    }
}
