//
//  WelcomeAccountPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 19/01/2022.
//

import FirebaseAuth

protocol WelcomeAccountPresenterView: AcitivityIndicatorProtocol, AnyObject {}

class WelcomeAccountPresenter {
    
    // MARK: - Properties
    weak var view: WelcomeAccountPresenterView?
    private let accountService: AccountServiceProtocol
    private var userCredentials: AccountCredentials?
    
    // MARK: - Initializer
    init(accountService: AccountServiceProtocol) {
        self.accountService = accountService
    }
    
    func setAccountCredentials(userName: String?,
                               email: String?,
                               password: String?,
                               passwordConfirmation: String?) {
        userCredentials = AccountCredentials(userName: userName ?? "",
                                             email: email ?? "",
                                             password: password ?? "",
                                             confirmPassword: passwordConfirmation ?? "")
    }
    
    func executeAction(for interfaceType: AccountInterfaceType) {
        switch interfaceType {
        case .login:
            loginToAccount()
        case .signup:
            createAccount()
        case .deleteAccount:
            deleteAccount()
        }
    }
    
    func resetPassword(with email: String?) {
        guard let email = email else {
            AlertManager.presentAlertBanner(as: .error,
                                            subtitle: Text.Banner.emptyEmail)
            return
        }
        accountService.sendPasswordReset(for: email) { error in
            if let error = error {
                AlertManager.presentAlertBanner(as: .error,
                                                subtitle: error.description)
                return
            }
            AlertManager.presentAlertBanner(as: .customMessage(Text.Banner.resetPassordTitle),
                                            subtitle: Text.Banner.resetPasswordMessage)
        }
    }
    
    // MARK: - Private functions
    private func loginToAccount() {
        view?.showActivityIndicator()
        
        accountService.login(with: userCredentials) { [weak self] error in
            guard let self = self else { return }
            
            self.view?.stopActivityIndicator()
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            AlertManager.presentAlertBanner(as: .customMessage(Text.Banner.welcomeTitle),
                                            subtitle: (Auth.auth().currentUser?.displayName ?? ""))
        }
    }
    
    private func createAccount() {
        view?.showActivityIndicator()
        
        accountService.createAccount(for: userCredentials) { [weak self] error in
            self?.view?.stopActivityIndicator()
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            AlertManager.presentAlertBanner(as: .customMessage(Text.Banner.accountOpen))
        }
    }
    
    private func deleteAccount() {
        view?.showActivityIndicator()
        self.accountService.deleteAccount(with: userCredentials) { [weak self] error in
            self?.view?.stopActivityIndicator()
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            AlertManager.presentAlertBanner(as: .success, subtitle: Text.Banner.accountDeleted)
        }
    }
}
