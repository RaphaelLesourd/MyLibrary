//
//  WelcomeControllerMainView.swift
//  MyLibrary
//
//  Created by Birkyboy on 25/10/2021.
//

import UIKit
import AuthenticationServices

class WelcomeControllerMainView: UIView {
    
    private let device = UIDevice.current.userInterfaceIdiom
    private lazy var titleFontSize: CGFloat = device == .pad ? 60 : 40
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        loginStackView.addArrangedSubview(loginButton)
        loginStackView.addArrangedSubview(signupButton)
        
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(loginStackView)
        mainStackView.addArrangedSubview(appVerionLabel)
        
        setBackGroundImageConstraints()
        setMainStackViewConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews
    let loginButton = Button(title: Text.Account.loginTitle,
                                   imagePlacement: .leading,
                                   tintColor: .systemOrange)
    let signupButton = Button(title: Text.Account.signupTitle,
                                    imagePlacement: .leading,
                                    tintColor: .white,
                                    backgroundColor: .white)
    let appVerionLabel = TextLabel(color: .white,
                                   maxLines: 1,
                                   alignment: .center,
                                   fontSize: 12,
                                   weight: .regular)
    
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.alpha = 0.3
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var titleLabel = TextLabel(color: .white,
                                       maxLines: 3,
                                       alignment: .left,
                                       fontSize: titleFontSize,
                                       weight: .bold)
    private let loginStackView = StackView(axis: .horizontal,
                                           distribution: .fillEqually,
                                           spacing: 20)
    private let mainStackView = StackView(axis: .vertical,
                                          spacing: 100)
    
    private func configureUI() {
        backgroundImage.image = Images.welcomeScreen
        titleLabel.text = Text.Account.welcomeMessage
        appVerionLabel.text = UIApplication.appName + " - Version " + UIApplication.release + " build " + UIApplication.build
    }
    
    override func layoutSubviews() {
        let spacing: CGFloat = device == .pad ? 250 : 100
        mainStackView.setCustomSpacing(spacing, after: titleLabel)
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
        
        let offSet: CGFloat = device == .pad ? 0.5 : 0.9
        addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            mainStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: offSet)
        ])
    }
}
