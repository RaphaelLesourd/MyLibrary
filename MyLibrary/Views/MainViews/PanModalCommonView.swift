//
//  PanModalCommonView.swift
//  MyLibrary
//
//  Created by Birkyboy on 25/10/2021.
//

import UIKit

enum InterfaceType {
    case login
    case signup
}

class PanModalCommonView: UIView {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setMainStackViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews
    private let titleLabel = TextLabel(fontSize: 27, weight: .bold)
    private let subtitleLabel = TextLabel(color: .secondaryLabel, maxLines: 4, fontSize: 16, weight: .regular)
    let emailTextField = TextField(placeholder: "Email",
                                   keyBoardType: .emailAddress,
                                   returnKey: .next,
                                   correction: .no,
                                   capitalization: .none)
    let confirmEmailTextField = TextField(placeholder: "Mot de passe",
                                          keyBoardType: .emailAddress,
                                          returnKey: .next,
                                          correction: .no,
                                          capitalization: .none)
    let passwordTextField = TextField(placeholder: "Confirmez votre mot de passe",
                                      keyBoardType: .default,
                                      returnKey: .done,
                                      correction: .no,
                                      capitalization: .none)
    let actionButton = ActionButton(title: "", tintColor: .appTintColor)
    
    let forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Mot de passe oublié", for: .normal)
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
    
    func configureUI(for type: InterfaceType) {
        titleLabel.text = type == .login ? "Connexion" : "Inscription"
        subtitleLabel.text = type == .login ? "Veuillez entrer votre email et votre mot de passe\npour vous connecter à votre compte." : "Veuillez entrer votre email et un mot de passe\npour créer un compte."
        let buttonTitle = type == .login ? "Se connecter" : "S'inscrire"
        actionButton.setTitle(buttonTitle, for: .normal)
        confirmEmailTextField.isHidden = type == .login
        forgotPasswordButton.isHidden = type == .signup
        let space: CGFloat = type == .login ? 5 : 50
        mainStackView.setCustomSpacing(space, after: passwordTextField)
    }
}
// MARK: - Constraints
extension PanModalCommonView {
    private func setMainStackViewConstraints() {
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(subtitleLabel)
        mainStackView.addArrangedSubview(emailTextField)
        mainStackView.addArrangedSubview(confirmEmailTextField)
        mainStackView.addArrangedSubview(passwordTextField)
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
