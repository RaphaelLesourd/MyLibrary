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
    private let presenter: SetupAccountPresenter
    private let interfaceType: AccountInterfaceType
    private var profileImage: UIImage?
    
    // MARK: - Initializer
    init(presenter: SetupAccountPresenter,
         interfaceType: AccountInterfaceType) {
        self.presenter = presenter
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
        mainView.configure(for: interfaceType)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        presenter.mainView = mainView
        mainView.emailTextField.delegate = self
        mainView.passwordTextField.delegate = self
        mainView.confirmPasswordTextField.delegate = self
        mainView.delegate = self
    }
    
    private func updateTextFieldState(for textField: UITextField, valid: Bool) {
        textField.layer.borderColor = valid ? UIColor.systemGreen.cgColor : UIColor.systemRed.cgColor
    }
}
// MARK: - TextField Delegate
extension AccountSetupViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return true }
        switch textField {
        case mainView.emailTextField:
            presenter.validateEmail(for: updatedString)
        case mainView.passwordTextField:
            presenter.validatePassword(for: updatedString)
        case mainView.confirmPasswordTextField:
            presenter.validatePasswordConfirmation(for: updatedString)
        default:
            return true
        }
        textField.layer.borderWidth = updatedString.isEmpty ? 0 : 1
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
        presenter.showInterface(for: interfaceType)
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
extension AccountSetupViewController: SetupAccountPresenterView {
    
    func updateEmailTextField(valid: Bool) {
        updateTextFieldState(for: mainView.emailTextField, valid: valid)
    }
    
    func updatePasswordTextField(valid: Bool) {
        updateTextFieldState(for: mainView.passwordTextField, valid: valid)
    }
    
    func updatePasswordConfirmationTextField(valid: Bool) {
        updateTextFieldState(for: mainView.confirmPasswordTextField, valid: valid)
    }
    func dismissViewController() {
        self.dismiss(animated: true)
    }
    
    func showActivityIndicator() {
        mainView.finishButton.displayActivityIndicator(true)
    }
    
    func stopActivityIndicator() {
        DispatchQueue.main.async {
            self.mainView.finishButton.displayActivityIndicator(false)
        }
    }
}