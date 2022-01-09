//
//  PanModalViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 25/10/2021.
//

import UIKit
import FirebaseAuth

class AccountSetupViewController: UIViewController {
    
    // MARK: - Properties
    private let mainView = AccountMainView()
    private let accountService: AccountServiceProtocol
    private let validator: ValidatorProtocol
    private let interfaceType: AccountInterfaceType
    
    // MARK: - Initializer
    init(accountService: AccountServiceProtocol,
         validator: ValidatorProtocol,
         interfaceType: AccountInterfaceType) {
        self.accountService = accountService
        self.validator = validator
        self.interfaceType = interfaceType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
        view.backgroundColor = .viewControllerBackgroundColor
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if interfaceType == .login {
            mainView.emailTextField.becomeFirstResponder()
        } else {
            mainView.userNameTextField.becomeFirstResponder()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.configureUI(for: interfaceType)
        setDelegates()
        setButtonTargets()
    }
    
    // MARK: - Setup
    private func setDelegates() {
        mainView.emailTextField.delegate = self
        mainView.passwordTextField.delegate = self
        mainView.confirmPasswordTextField.delegate = self
    }

    private func setButtonTargets() {
        mainView.finishButton.addAction(UIAction(handler: { [weak self] _ in
            self?.finishedButtonTapped()
        }), for: .touchUpInside)
        mainView.forgotPasswordButton.addAction(UIAction(handler: { [weak self] _ in
            self?.resetPassWordRequest()
        }), for: .touchUpInside)
    }
    
    // MARK: - Targets
    private func finishedButtonTapped() {
        switch interfaceType {
        case .login:
            loginToAccount()
        case .signup:
            createAccount()
        case .deleteAccount:
            deleteAccount()
        }
    }
    
    // MARK: - Account
    private func loginToAccount() {
        let user = setUser()
        mainView.finishButton.displayActivityIndicator(true)
        accountService.login(with: user) { [weak self] error in
            guard let self = self else { return }
            
            self.mainView.finishButton.displayActivityIndicator(false)
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            AlertManager.presentAlertBanner(as: .customMessage(Text.Banner.welcomeTitle),
                                            subtitle: (Auth.auth().currentUser?.displayName ?? ""))
        }
    }
    
    private func createAccount() {
        let user = setUser()
        mainView.finishButton.displayActivityIndicator(true)
        accountService.createAccount(for: user) { [weak self] error in
            guard let self = self else { return }

            self.mainView.finishButton.displayActivityIndicator(false)
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            AlertManager.presentAlertBanner(as: .customMessage(Text.Banner.accountOpen))
        }
    }
    
    private func resetPassWordRequest() {
        AlertManager.presentAlert(withTitle: Text.Alert.forgotPasswordTitle,
                                  message: Text.Alert.forgotPasswordMessage,
                                  withCancel: true,
                                  on: self) { [weak self] _ in
            self?.resetPassword()
        }
    }
    
    private func resetPassword() {
        guard let email = mainView.emailTextField.text else {
            AlertManager.presentAlertBanner(as: .error, subtitle: Text.Banner.emptyEmail)
            return
        }
        accountService.sendPasswordReset(for: email) { error in
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            AlertManager.presentAlertBanner(as: .customMessage(Text.Banner.resetPassordTitle), subtitle: Text.Banner.resetPasswordMessage)
        }
    }
    
    func setUser() -> AccountCredentials {
        return AccountCredentials(userName: mainView.userNameTextField.text ?? "",
                                  email: mainView.emailTextField.text ?? "",
                                  password: mainView.passwordTextField.text ?? "",
                                  confirmPassword: mainView.confirmPasswordTextField.text ?? "")
    }
    
    private func deleteAccount() {
        let user = setUser()
        mainView.finishButton.displayActivityIndicator(true)
        self.accountService.deleteAccount(with: user) { [weak self] error in
            guard let self = self else { return }
            
            self.mainView.finishButton.displayActivityIndicator(false)
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            AlertManager.presentAlertBanner(as: .success, subtitle: Text.Banner.accountDeleted)
        }
    }
}
// MARK: - TextField Delegate
extension AccountSetupViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return true }
        var valid = false
        switch textField {
        case mainView.emailTextField:
            valid = validator.validateEmail(updatedString)
        case mainView.passwordTextField:
            valid = validator.validatePassword(updatedString)
        case mainView.confirmPasswordTextField:
            valid = validator.validatePassword(updatedString)
        default:
            return true
        }
        textField.layer.borderWidth = updatedString.isEmpty ? 0 : 1
        textField.layer.borderColor = valid ? UIColor.systemGreen.cgColor : UIColor.systemRed.cgColor
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let lastTextField = interfaceType == .login ? mainView.passwordTextField : mainView.confirmPasswordTextField
        if textField == lastTextField {
            textField.resignFirstResponder()
        } else {
            textField.next?.becomeFirstResponder()
        }
        return true
    }
}
