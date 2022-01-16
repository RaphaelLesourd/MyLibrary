//
//  AccountView.swift
//  MyLibrary
//
//  Created by Birkyboy on 31/12/2021.
//

import UIKit
import Lottie

class AccountView: UIView {
    // MARK: Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
        setProfileAnimationContraints()
        setProfileImageButtonContraints()
        setAddImageContraints()
        setStackViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews
    let profileImageButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFill
        button.roundView(radius: 50, backgroundColor: .clear)
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.white.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let addProfileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.TabBarIcon.newBookIcon
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .appTintColor
        imageView.addShadow()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let animationView: AnimationView = {
        let animationView = AnimationView()
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.animation = Animation.named("wave")
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.alpha = 0.8
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()
    
    let emailLabel = TextLabel(color: .label,
                               maxLines: 1,
                               alignment: .center,
                               font: .footerLabel)
    let userNameTextfield = TextField(placeholder: Text.Account.userName,
                                      keyBoardType: .alphabet,
                                      returnKey: .done,
                                      correction: .no,
                                      capitalization: .none)
    let signoutButton = Button(title: Text.ButtonTitle.signOut,
                               imagePlacement: .leading,
                               tintColor: .systemPurple,
                               backgroundColor: .systemPurple)
    let deleteButton = Button(title: Text.ButtonTitle.deletaAccount,
                              imagePlacement: .leading,
                              tintColor: .systemRed,
                              backgroundColor: .clear)
    private let profileImageContainerView = UIView()
    private let stackView = StackView(axis: .vertical,
                                      spacing: 15)
    
    private func setupView() {
        roundView(radius: 15, backgroundColor: .cellBackgroundColor)
        userNameTextfield.clearButtonMode = .always
        
        stackView.addArrangedSubview(profileImageContainerView)
        stackView.addArrangedSubview(emailLabel)
        stackView.addArrangedSubview(userNameTextfield)
        stackView.addArrangedSubview(signoutButton)
        stackView.addArrangedSubview(deleteButton)
        stackView.setCustomSpacing(40, after: profileImageContainerView)
        stackView.setCustomSpacing(60, after: userNameTextfield)
    }
    
    func play(speed: CGFloat = 0.5) {
        animationView.animationSpeed = speed
        animationView.play()
    }
    
    func stop() {
        animationView.stop()
    }
}
// MARK: - Constraints
extension AccountView {
    private func setProfileAnimationContraints() {
        addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: topAnchor, constant: -77),
            animationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            animationView.heightAnchor.constraint(equalToConstant: 300),
            animationView.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func setProfileImageButtonContraints() {
        profileImageContainerView.addSubview(profileImageButton)
        NSLayoutConstraint.activate([
            profileImageButton.topAnchor.constraint(equalTo: profileImageContainerView.topAnchor),
            profileImageButton.bottomAnchor.constraint(equalTo: profileImageContainerView.bottomAnchor),
            profileImageButton.centerXAnchor.constraint(equalTo: profileImageContainerView.centerXAnchor),
            profileImageButton.heightAnchor.constraint(equalToConstant: 100),
            profileImageButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setAddImageContraints() {
        profileImageContainerView.addSubview(addProfileImage)
        NSLayoutConstraint.activate([
            addProfileImage.bottomAnchor.constraint(equalTo: profileImageButton.bottomAnchor),
            addProfileImage.leadingAnchor.constraint(equalTo: profileImageButton.trailingAnchor, constant: -25),
            addProfileImage.heightAnchor.constraint(equalToConstant: 25),
            addProfileImage.widthAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func setStackViewConstraints() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 25),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
    }
}
