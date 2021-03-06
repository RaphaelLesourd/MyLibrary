//
//  AccountView.swift
//  MyLibrary
//
//  Created by Birkyboy on 31/12/2021.
//

import UIKit
import Lottie

class ProfileView: UIView {
  
    weak var delegate: ProfileViewDelegate?
    
    // MARK: Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
        addButtonsAction()
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
        button.setImage(Images.emptyStateBookImage, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.roundView(radius: 50, backgroundColor: .systemGray5)
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.appTintColor.cgColor
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
    
    let animationView: AnimationView = {
        let animationView = AnimationView()
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
        animationView.contentMode = .scaleAspectFit
        animationView.animation = Animation.named("wave")
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()
    
    let emailLabel = TextLabel(color: .label,
                               maxLines: 2,
                               alignment: .center,
                               font: .sectionTitle)
    let userNameTextfield = TextField(placeholder: Text.Account.userName,
                                      keyBoardType: .default,
                                      returnKey: .done,
                                      correction: .no,
                                      capitalization: .none)
    let legendLabel = TextLabel(color: .secondaryLabel,
                                maxLines: 2,
                                alignment: .center,
                                font: .footerLabel)
    let accountView = AccountView()
    private let profileImageContainerView = UIView()
    private let stackView = StackView(axis: .vertical,
                                      spacing: 15)
    
    private func setupView() {
        roundView(radius: 15, backgroundColor: .cellBackgroundColor)
        userNameTextfield.clearButtonMode = .always
        legendLabel.text = Text.SectionTitle.updateUserNameLegend
        
        stackView.addArrangedSubview(profileImageContainerView)
        stackView.addArrangedSubview(emailLabel)
        stackView.addArrangedSubview(userNameTextfield)
        stackView.addArrangedSubview(legendLabel)
        stackView.addArrangedSubview(accountView)
        stackView.setCustomSpacing(40, after: profileImageContainerView)
        stackView.setCustomSpacing(5, after: userNameTextfield)
        stackView.setCustomSpacing(60, after: legendLabel)
    }
    
    private func addButtonsAction() {
        profileImageButton.addAction(UIAction(handler: { [weak self] _ in
            self?.delegate?.presentImagePicker()
        }), for: .touchUpInside)
    }
  
    func increaseLoadingAnimationSpeed(_ loading: Bool) {
        guard loading else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.animationView.animationSpeed = 0.5
            }
            return
        }
        self.animationView.animationSpeed = 2
    }
}
// MARK: - Constraints
extension ProfileView {
    private func setProfileAnimationContraints() {
        addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: topAnchor, constant: -102),
            animationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            animationView.heightAnchor.constraint(equalToConstant: 350),
            animationView.widthAnchor.constraint(equalToConstant: 350)
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
            addProfileImage.heightAnchor.constraint(equalToConstant: 30),
            addProfileImage.widthAnchor.constraint(equalToConstant: 30)
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
