//
//  PanModalViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 25/10/2021.
//

import UIKit
import PanModal

class PanModalViewController: UIViewController {

    // MARK: - Properties
    let mainView = PanModalCommonView()
    var userEmail = String()
    var userPassword = String()
    var confirmPassword = String()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
        view.backgroundColor = .viewControllerBackgroundColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardDismissGesture()
        setDelegates()
    }
    // MARK: - Setup
    func setDelegates() {
        mainView.emailTextField.delegate = self
        mainView.passwordTextField.delegate = self
        mainView.confirmEmailTextField.delegate = self
    }
}
// MARK: - TextField Delegate
extension PanModalViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        var validity: Bool?
        switch textField {
        case mainView.emailTextField:
            validity = updatedString?.validateEmail()
        case mainView.passwordTextField:
            validity = updatedString?.validatePassword()
        case mainView.confirmEmailTextField:
            validity = updatedString?.validatePassword()
        default:
            return true
        }
        updateTextFieldBorderColor(with: validity, for: textField)
        return true
    }
    
    private func updateTextFieldBorderColor(with isValid: Bool?, for textfield: UITextField) {
        guard let isValid = isValid else { return }

        textfield.layer.borderColor = isValid ? UIColor.systemGreen.cgColor : UIColor.systemRed.cgColor
    }
}
extension PanModalViewController: PanModalPresentable {
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
