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
        addKeyboardDismissGesture()
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
    }
    // MARK: - Targets
    @objc private func actionButtonTapped() {
        interfaceType == .login ? loginToAccount() : createAccount()
    }
    // MARK: - Account
    private func loginToAccount() {
        userManager.login { result in
            switch result {
            case .success(_):
                print("Logged in successfully")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func createAccount() {
        userManager.createAccount { result in
            switch result {
            case .success(_):
                print("Account created successFully")
            case .failure(let error):
                print(error.localizedDescription)
            }
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
            mainView.activateActionButton(userManager.canCreateAccount())
        }
    }
}
extension SigningViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(150)
    }
   
    var cornerRadius: CGFloat {
        return 20
    }
}
