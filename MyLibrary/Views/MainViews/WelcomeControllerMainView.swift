//
//  WelcomeControllerMainView.swift
//  MyLibrary
//
//  Created by Birkyboy on 25/10/2021.
//

import Foundation
import UIKit
import AuthenticationServices

class WelcomeControllerMainView: UIView {
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setBackGroundImageConstraints()
        setMainStackViewConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.alpha = 0.3
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel = TextLabel(color: .white, maxLines: 3, alignment: .left, fontSize: 40, weight: .bold)
    private let socialMedialoginLabel = TextLabel(color: .white, maxLines: 1, alignment: .center, fontSize: 18, weight: .regular)
    private let termsOfUseLabel = TextLabel(color: .white, maxLines: 1, alignment: .center, fontSize: 14, weight: .regular)
    let loginButton = ActionButton(title: Text.Account.loginTitle, systemImage: "", imagePlacement: .leading, tintColor: .appTintColor)
    let signupButton = ActionButton(title: Text.Account.signupTitle, systemImage: "", imagePlacement: .leading, tintColor: .white)
   
    let appleSignInButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton()
        button.cornerRadius = 10
        button.constraints.forEach {
            if $0.firstAttribute == .width {
                    $0.isActive = false
            }
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 55).isActive = true
        return button
    }()
    
    private let loginStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.spacing = 20
        return stack
    }()
    
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 100
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private func configureUI() {
        backgroundImage.image = Images.welcomeScreen
        titleLabel.text = Text.Account.welcomeMessage
        termsOfUseLabel.text = Text.Account.termOfUseMessage
        socialMedialoginLabel.text = Text.Account.otherConnectionTypeMessage
        loginStackView.addArrangedSubview(loginButton)
        loginStackView.addArrangedSubview(signupButton)
    }
}
// MARK: - Constraints
extension WelcomeControllerMainView {
    private func setBackGroundImageConstraints() {
        addSubview(backgroundImage)
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func setMainStackViewConstraints() {
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(loginStackView)
        mainStackView.addArrangedSubview(socialMedialoginLabel)
        mainStackView.addArrangedSubview(appleSignInButton)
        mainStackView.addArrangedSubview(termsOfUseLabel)
        mainStackView.setCustomSpacing(50, after: loginStackView)
        mainStackView.setCustomSpacing(20, after: socialMedialoginLabel)
        NSLayoutConstraint.activate([
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            mainStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainStackView.widthAnchor.constraint(equalTo: widthAnchor, constant: -32)
        ])
    }
}
