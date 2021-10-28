//
//  ProfilecontrollerMainView.swift
//  MyLibrary
//
//  Created by Birkyboy on 27/10/2021.
//

import Foundation
import UIKit

class ProfileControllerMainView: UIView {
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setProfileImageButtonConstraints()
        setMainStackViewConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews
    private let titleLabel = TextLabel(fontSize: 27, weight: .bold)
    private let subtitleLabel = TextLabel(color: .secondaryLabel, maxLines: 4, fontSize: 16, weight: .regular)
    private let profileImageContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 120).isActive = true
        return view
    }()
    
    let profileImagebutton: ImageButton = {
        let button = ImageButton(radius: 60, backgrounColor: .tertiarySystemBackground)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let userNameTextField = TextField(placeholder: Text.Profile.userName,
                                   keyBoardType: .emailAddress,
                                   returnKey: .next,
                                   correction: .no,
                                   capitalization: .none)
    let actionButton = ActionButton(title: "Sauver", tintColor: .appTintColor)
    
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 50
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Configuration
    private func configureUI() {
        titleLabel.text = Text.ControllerTitle.profile
    }

}
// MARK: - Constraints
extension ProfileControllerMainView {
    
    private func setProfileImageButtonConstraints() {
        profileImageContainerView.addSubview(profileImagebutton)
        NSLayoutConstraint.activate([
            profileImagebutton.heightAnchor.constraint(equalTo: profileImageContainerView.heightAnchor),
            profileImagebutton.widthAnchor.constraint(equalTo: profileImageContainerView.heightAnchor),
            profileImagebutton.centerXAnchor.constraint(equalTo: profileImageContainerView.centerXAnchor),
            profileImagebutton.centerYAnchor.constraint(equalTo: profileImageContainerView.centerYAnchor)
        ])
    }
  
    private func setMainStackViewConstraints() {
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(subtitleLabel)
        mainStackView.addArrangedSubview(profileImageContainerView)
        mainStackView.addArrangedSubview(userNameTextField)
        mainStackView.addArrangedSubview(actionButton)
        
        mainStackView.setCustomSpacing(5, after: titleLabel)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
