//
//  PanModalCommonView.swift
//  MyLibrary
//
//  Created by Birkyboy on 25/10/2021.
//

import UIKit

class AccountMainView: UIView {
    
    weak var delegate: AccountCreationViewDelegate?
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
        addButtonsAction()
        setScrollViewConstraints()
        setMainStackViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews
    private let scrollView: UIScrollView = {
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
    
    private let titleLabel = TextLabel(font: .controllerTitle)
    private let subtitleLabel = TextLabel(color: .secondaryLabel,
                                          maxLines: 4,
                                          font: .subtitle)
    let userNameTextField = TextField(placeholder: Text.Account.userName,
                                      keyBoardType: .default,
                                      returnKey: .next,
                                      correction: .no,
                                      capitalization: .sentences)
    let emailTextField = TextField(placeholder: Text.Account.email,
                                   keyBoardType: .emailAddress,
                                   returnKey: .next,
                                   correction: .no,
                                   capitalization: .none)
    let passwordTextField = TextField(placeholder: Text.Account.password,
                                      keyBoardType: .asciiCapableNumberPad,
                                      returnKey: .done,
                                      correction: .no,
                                      capitalization: .none)
    let confirmPasswordTextField = TextField(placeholder: Text.Account.confirmPassword,
                                             keyBoardType: .default,
                                             returnKey: .next,
                                             correction: .no,
                                             capitalization: .none)
    let finishButton = Button(title: "",
                              icon: Images.ButtonIcon.done,
                              tintColor: .appTintColor)
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle(Text.Account.forgotPassword, for: .normal)
        button.setTitleColor(UIColor.appTintColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .light)
        return button
    }()
    
    private let mainStackView = StackView(axis: .vertical,
                                          spacing: 10)
    
    // MARK: - Configuration
    func configure(for type: AccountInterfaceType) {
        userNameTextField.isHidden = type != .signup
        confirmPasswordTextField.isHidden = type != .signup
        forgotPasswordButton.isHidden = type == .signup
        if type != .signup {
            mainStackView.setCustomSpacing(50, after: confirmPasswordTextField)
        }
        
        switch type {
        case .signup:
            updateUiTexts(title: Text.Account.signupTitle,
                          subtitle: Text.Account.signupSubtitle,
                          buttonTitle: Text.ButtonTitle.createProfileButtonTitle)
        case .login:
            updateUiTexts(title: Text.Account.loginTitle,
                          subtitle: Text.Account.loginSubtitle,
                          buttonTitle: Text.Account.loginButtonTitle)
        case .deleteAccount:
            updateUiTexts(title: Text.ButtonTitle.deletaAccount,
                          subtitle: Text.Account.reAuthentificationMessage,
                          buttonTitle: Text.ButtonTitle.delete)
        }
    }
    
    private func updateUiTexts(title: String, subtitle: String, buttonTitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        finishButton.setTitle(buttonTitle, for: .normal)
    }
    
    private func setupView() {
#if targetEnvironment(simulator)
        // Do Not enable '.password' or '.newPassword' or 'isSecureTextEntry' text content type on simulator as it ends up with annoying behaviour:
        // 'Strong Password' yellow glitch preventing from editing field.
#else
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocapitalizationType = .none
        passwordTextField.textContentType = .password
        
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.autocapitalizationType = .none
        confirmPasswordTextField.textContentType = .password
#endif
    }
    
    private func addButtonsAction() {
        finishButton.addAction(UIAction(handler: { [weak self] _ in
            self?.delegate?.finishedButtonTapped()
        }), for: .touchUpInside)
        
        forgotPasswordButton.addAction(UIAction(handler: { [weak self] _ in
            self?.delegate?.resetPassWordRequest()
        }), for: .touchUpInside)
    }
    
}
// MARK: - Constraints
extension AccountMainView {
    
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
                                           finishButton]
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
