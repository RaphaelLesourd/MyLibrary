//
//  PanModalViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 25/10/2021.
//

import UIKit
import PanModal

class SigningViewController: UIViewController {
    
    // MARK: - Properties
    private let mainView = PanModalCommonView()
    private var userManager: AccountServiceProtocol
    private var validator: ValidatorProtocol
    private var interfaceType: AccountInterfaceType
    
    // MARK: - Initializer
    init(userManager: AccountServiceProtocol, validator: ValidatorProtocol, interfaceType: AccountInterfaceType) {
        self.userManager = userManager
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
        mainView.actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        mainView.forgotPasswordButton.addTarget(self, action: #selector(resetPassWordRequest), for: .touchUpInside)
    }
    
    // MARK: - Targets
    @objc private func actionButtonTapped() {
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
        mainView.actionButton.displayActivityIndicator(true)
        userManager.login(with: user) { [weak self] error in
            guard let self = self else { return }
            
            self.mainView.actionButton.displayActivityIndicator(false)
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            AlertManager.presentAlertBanner(as: .success, subtitle: Text.Banner.welcomeTitle)
        }
    }
    
    private func createAccount() {
        let user = setUser()
        mainView.actionButton.displayActivityIndicator(true)
        userManager.createAccount(for: user) { [weak self] error in
            guard let self = self else { return }
            
            self.mainView.actionButton.displayActivityIndicator(false)
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            AlertManager.presentAlertBanner(as: .customMessage(Text.Banner.accountOpen))
        }
    }
    
    @objc private func resetPassWordRequest() {
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
        userManager.sendPasswordReset(for: email) { error in
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            AlertManager.presentAlertBanner(as: .customMessage(Text.Banner.resetPassordTitle), subtitle: Text.Banner.resetPasswordMessage)
        }
    }
    
    private func setUser() -> AccountCredentials {
        return AccountCredentials(userName: mainView.userNameTextField.text ?? "",
                                  email: mainView.emailTextField.text ?? "",
                                  password: mainView.passwordTextField.text ?? "",
                                  confirmPassword: mainView.confirmPasswordTextField.text ?? "")
    }
    
    private func deleteAccount() {
        let user = setUser()
        mainView.actionButton.displayActivityIndicator(true)
        self.userManager.deleteAccount(with: user) { [weak self] error in
            guard let self = self else { return }
            
            self.mainView.actionButton.displayActivityIndicator(false)
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            AlertManager.presentAlertBanner(as: .success, subtitle: Text.Banner.accountDeleted)
        }
    }
}
// MARK: - TextField Delegate
extension SigningViewController: UITextFieldDelegate {
    
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
// MARK: - Panmodal Presentable
extension SigningViewController: PanModalPresentable {
    var longFormHeight: PanModalHeight {
        let height: CGFloat = interfaceType == .login ? 140 : 100
        return .maxHeightWithTopInset(height)
    }
    
    var cornerRadius: CGFloat {
        return 20
    }
    
    var panScrollable: UIScrollView? {
        return nil
    }
}
