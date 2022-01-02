//
//  AccountView.swift
//  MyLibrary
//
//  Created by Birkyboy on 31/12/2021.
//

import UIKit

class AccountView: UIView {
    // MARK: Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        roundView(radius: 15, backgroundColor: .cellBackgroundColor)
        
        stackView.addArrangedSubview(profileImageContainerView)
        stackView.addArrangedSubview(emailLabel)
        stackView.addArrangedSubview(userNameTextfield)
        stackView.addArrangedSubview(signoutButton)
        stackView.addArrangedSubview(deleteButton)
        
        stackView.setCustomSpacing(60, after: userNameTextfield)
        setProfileImageButtonContraints()
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
    let emailLabel = TextLabel(color: .secondaryLabel,
                                 maxLines: 1,
                                 alignment: .center,
                                 fontSize: 14,
                                 weight: .light)
    let userNameTextfield = TextField(placeholder: Text.Account.userName,
                                      keyBoardType: .alphabet,
                                      returnKey: .done,
                                      correction: .no,
                                      capitalization: .none)
    let signoutButton = Button(title: Text.ButtonTitle.signOut,
                               systemImage: Text.ButtonTitle.signOut,
                               imagePlacement: .leading,
                               tintColor: .systemPurple,
                               backgroundColor: .systemPurple)
    let deleteButton = Button(title: Text.ButtonTitle.deletaAccount,
                               systemImage: "",
                              imagePlacement: .leading,
                               tintColor: .systemRed,
                               backgroundColor: .clear)
    private let profileImageContainerView = UIView()
    private let stackView = StackView(axis: .vertical,
                                      spacing: 15)
}
// MARK: - Constraints
extension AccountView {
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
