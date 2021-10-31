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
    private var interfaceType: AccountInterfaceType
    private var userManager: UserManagerProtocol
    
    // MARK: - Initializer
    init(userManager: UserManagerProtocol, interfaceType: AccountInterfaceType) {
        self.userManager = userManager
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
        interfaceType == .login ? loginToAccount() : createAccount()
    }
    
    // MARK: - Account
    private func loginToAccount() {
        userManager.login { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.presentAlertBanner(as: .error, subtitle: error.localizedDescription)
                return
            }
            self.presentAlertBanner(as: .success, subtitle: "Bienvenue")
        }
    }
    
    private func createAccount() {
        userManager.userName = mainView.userNameTextField.text ?? ""
        userManager.createAccount { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.presentAlertBanner(as: .error, subtitle: error.localizedDescription)
                return
            }
            self.presentAlertBanner(as: .success, subtitle: "Compte ouvert")
        }
    }
    
    @objc private func resetPassWordRequest() {
        presentAlert(withTitle: "Mot de passe oublié",
                     message: "Etes-vous sûr de vouloir mettre votre mot de passe à jour?",
                     withCancel: true) { [weak self] _ in
            self?.resetPassword()
        }
    }
    
    private func resetPassword() {
        userManager.sendPasswordReset { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.presentAlertBanner(as: .error, subtitle: error.localizedDescription)
                return
            }
            self.presentAlertBanner(as: .customMessage("Reset du mot de passe"), subtitle: "Veuillez vérifier vos emails.")
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
            valid = updatedString.validateEmail()
            userManager.userEmail = updatedString
        case mainView.passwordTextField:
            valid = updatedString.validatePassword()
            userManager.userPassword = updatedString
        case mainView.confirmPasswordTextField:
            userManager.confirmPassword = updatedString
            valid = updatedString.validatePassword() && (userManager.userPassword == userManager.confirmPassword)
        default:
            return true
        }
        textField.layer.borderWidth = updatedString.isEmpty ? 0 : 1
        textField.layer.borderColor = valid ? UIColor.systemGreen.cgColor : UIColor.systemRed.cgColor
        activateActionButton()
        return true
    }
    
    private func activateActionButton() {
        switch interfaceType {
        case .login:
            mainView.activateActionButton(userManager.canLogin())
        case .signup:
            print(userManager.canCreateAccount())
            mainView.activateActionButton(userManager.canCreateAccount())
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let lastTextField = interfaceType == .login ? mainView.passwordTextField : mainView.confirmPasswordTextField
        if textField == lastTextField {
            textField.resignFirstResponder()
        } else {
            mainView.passwordTextField.becomeFirstResponder()
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
