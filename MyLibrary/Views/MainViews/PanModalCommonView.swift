//
//  PanModalCommonView.swift
//  MyLibrary
//
//  Created by Birkyboy on 25/10/2021.
//

import UIKit

class PanModalCommonView: UIView {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setMainStackViewConstraints()
        activateActionButton(false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews
    private let titleLabel = TextLabel(fontSize: 27, weight: .bold)
    private let subtitleLabel = TextLabel(color: .secondaryLabel, maxLines: 4, fontSize: 16, weight: .regular)
    let emailTextField = TextField(placeholder: Text.Account.email,
                                   keyBoardType: .emailAddress,
                                   returnKey: .next,
                                   correction: .no,
                                   capitalization: .none)
    let passwordTextField = TextField(placeholder: Text.Account.password,
                                      keyBoardType: .default,
                                      returnKey: .done,
                                      correction: .no,
                                      capitalization: .none)
    let confirmPasswordTextField = TextField(placeholder: Text.Account.confirmPassword,
                                          keyBoardType: .emailAddress,
                                          returnKey: .next,
                                          correction: .no,
                                          capitalization: .none)
    let actionButton = ActionButton(title: "", tintColor: .appTintColor)
    
    let forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle(Text.Account.forgotPassword, for: .normal)
        button.setTitleColor(UIColor.appTintColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .light)
        return button
    }()
    
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    func configureUI(for type: AccountInterfaceType) {
        titleLabel.text = type == .login ? Text.Account.loginTitle : Text.Account.signupTitle
        subtitleLabel.text = type == .login ? Text.Account.loginSubtitle : Text.Account.signupSubtitle
        let buttonTitle = type == .login ? Text.Account.loginButtonTitle : Text.Account.signupButtonTitle
        actionButton.setTitle(buttonTitle, for: .normal)
        confirmPasswordTextField.isHidden = type == .login
        forgotPasswordButton.isHidden = type == .signup
        let space: CGFloat = type == .login ? 5 : 50
        mainStackView.setCustomSpacing(space, after: confirmPasswordTextField)
    }
    
    func activateActionButton(_ state: Bool) {
        actionButton.alpha = state ? 1 : 0.5
        actionButton.isUserInteractionEnabled = state
    }
}
// MARK: - Constraints
extension PanModalCommonView {
    private func setMainStackViewConstraints() {
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(subtitleLabel)
        mainStackView.addArrangedSubview(emailTextField)
        mainStackView.addArrangedSubview(passwordTextField)
        mainStackView.addArrangedSubview(confirmPasswordTextField)
        mainStackView.addArrangedSubview(forgotPasswordButton)
        mainStackView.addArrangedSubview(actionButton)
        
        mainStackView.setCustomSpacing(5, after: titleLabel)
        mainStackView.setCustomSpacing(50, after: subtitleLabel)
        mainStackView.setCustomSpacing(50, after: forgotPasswordButton)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
