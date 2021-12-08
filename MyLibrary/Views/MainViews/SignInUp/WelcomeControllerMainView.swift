//
//  WelcomeControllerMainView.swift
//  MyLibrary
//
//  Created by Birkyboy on 25/10/2021.
//

import UIKit
import AuthenticationServices

class WelcomeControllerMainView: UIView {
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(loginStackView)
        mainStackView.addArrangedSubview(termOfUserButton)
        
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
    let loginButton = ActionButton(title: Text.Account.loginTitle,
                                   systemImage: "",
                                   imagePlacement: .leading,
                                   tintColor: .appTintColor)
    let signupButton = ActionButton(title: Text.Account.signupTitle,
                                    systemImage: "",
                                    imagePlacement: .leading,
                                    tintColor: .white,
                                    backgroundColor: .white)
    
    let termOfUserButton: UIButton = {
        let button = UIButton()
        button.setTitle(Text.Account.termOfUseMessage, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return button
    }()
    
    private let loginStackView = StackView(axis: .horizontal, distribution: .fillEqually, spacing: 20)
    private let mainStackView = StackView(axis: .vertical, spacing: 100)
    
    private func configureUI() {
        backgroundImage.image = Images.welcomeScreen
        titleLabel.text = Text.Account.welcomeMessage
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
        NSLayoutConstraint.activate([
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            mainStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainStackView.widthAnchor.constraint(equalTo: widthAnchor, constant: -32)
        ])
    }
}
