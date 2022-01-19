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
    private let presenter: WelcomeAccountPresenter
    private let validator: ValidatorProtocol
    private let interfaceType: AccountInterfaceType
    private var profileImage: UIImage?
    
    // MARK: - Initializer
    init(presenter: WelcomeAccountPresenter,
         validator: ValidatorProtocol,
         interfaceType: AccountInterfaceType) {
        self.presenter = presenter
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
        mainView.configure(for: interfaceType)
        setDelegates()
    }
    
    // MARK: - Setup
    private func setDelegates() {
        mainView.emailTextField.delegate = self
        mainView.passwordTextField.delegate = self
        mainView.confirmPasswordTextField.delegate = self
        mainView.delegate = self
    }
}
// MARK: - TextField Delegate
extension AccountSetupViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
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
// MARK: - AccountMainView Delegate
extension AccountSetupViewController: AccountCreationViewDelegate {
    
    func finishedButtonTapped() {
        presenter.setAccountCredentials(userName: mainView.userNameTextField.text,
                                        email: mainView.emailTextField.text,
                                        password: mainView.passwordTextField.text,
                                        passwordConfirmation: mainView.confirmPasswordTextField.text)
        presenter.executeAction(for: interfaceType)
    }
    
    func resetPassWordRequest() {
        AlertManager.presentAlert(title: Text.Alert.forgotPasswordTitle,
                                  message: Text.Alert.forgotPasswordMessage,
                                  cancel: true,
                                  on: self) { [weak self] _ in
            self?.presenter.resetPassword(with: self?.mainView.emailTextField.text)
        }
    }
}
// MARK: - AccountSetup Presenter
extension AccountSetupViewController: WelcomeAccountPresenterView {
    func showActivityIndicator() {
        DispatchQueue.main.async {
            self.mainView.finishButton.displayActivityIndicator(true)
        }
    }
    
    func stopActivityIndicator() {
        DispatchQueue.main.async {
            self.mainView.finishButton.displayActivityIndicator(false)
        }
    }
}
