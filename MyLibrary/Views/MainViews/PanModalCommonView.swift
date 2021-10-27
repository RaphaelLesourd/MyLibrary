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
        setScrollViewConstraints()
        setMainStackViewConstraints()
        activateActionButton(false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    /// Create the contentView in the scrollView that will contain all the UI elements.
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel = TextLabel(fontSize: 27, weight: .bold)
    private let subtitleLabel = TextLabel(color: .secondaryLabel, maxLines: 4, fontSize: 16, weight: .regular)
    let userNameTextField = TextField(placeholder: Text.Profile.userName,
                                   keyBoardType: .emailAddress,
                                   returnKey: .next,
                                   correction: .no,
                                   capitalization: .none)
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
        
        let buttonTitle = type == .login ? Text.Account.loginButtonTitle : Text.Profile.createProfileButtonTitle
        actionButton.setTitle(buttonTitle, for: .normal)
        userNameTextField.isHidden = type == .login
#if targetEnvironment(simulator)
        // Do Not enable '.password' or '.newPassword' or 'isSecureTextEntry' text content type on simulator as it ends up with annoying behaviour:
        // 'Strong Password' yellow glitch preventing from editing field.
        print("Simulator! not setting password-like text content type")
#else
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocapitalizationType = .none
        passwordTextField.textContentType = .password
        
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.autocapitalizationType = .none
        confirmPasswordTextField.textContentType = .password
#endif
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
    
    private func setScrollViewConstraints() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: widthAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    private func setMainStackViewConstraints() {
        contentView.addSubview(mainStackView)
        let mainStackSubViews: [UIView] = [titleLabel,
                                           subtitleLabel,
                                           userNameTextField,
                                           emailTextField,
                                           passwordTextField,
                                           confirmPasswordTextField,
                                           forgotPasswordButton,
                                           actionButton]
        mainStackSubViews.forEach { mainStackView.addArrangedSubview($0) }
        
        mainStackView.setCustomSpacing(5, after: titleLabel)
        mainStackView.setCustomSpacing(50, after: subtitleLabel)
        mainStackView.setCustomSpacing(50, after: forgotPasswordButton)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
           mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
