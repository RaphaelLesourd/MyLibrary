//
//  ProfileStaticCell.swift
//  MyLibrary
//
//  Created by Birkyboy on 03/11/2021.
//

import Foundation
import UIKit

class ProfileStaticCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        backgroundColor = .tertiarySystemBackground
        setProfileButtonConstraints()
        setStackViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let profileImageButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFill
        button.rounded(radius: 30, backgroundColor: .tertiaryLabel)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let userNameTextField = TextField(placeholder: "Nom d'utilisateur",
                                      keyBoardType: .default,
                                      returnKey: .done,
                                      correction: .no,
                                      capitalization: .sentences)
    let emailLabel = TextLabel(color: .secondaryLabel,
                               maxLines: 1,
                               alignment: .left,
                               fontSize: 15,
                               weight: .regular)
    let activityIndicator     = UIActivityIndicatorView()
    private let textStackView = StackView(axis: .vertical, distribution: .fillProportionally, spacing: -10)
    private let mainStackView = StackView(axis: .horizontal, distribution: .fillProportionally, spacing: 10)
  
}
extension ProfileStaticCell {
    private func setProfileButtonConstraints() {
        contentView.addSubview(profileImageButton)
        NSLayoutConstraint.activate([
            profileImageButton.heightAnchor.constraint(equalToConstant: 60),
            profileImageButton.widthAnchor.constraint(equalToConstant: 60),
            profileImageButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            profileImageButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])
    }
    
    private func setStackViewConstraints() {
        contentView.addSubview(mainStackView)
        textStackView.addArrangedSubview(userNameTextField)
        textStackView.addArrangedSubview(emailLabel)
        
        mainStackView.addArrangedSubview(textStackView)
        mainStackView.addArrangedSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            mainStackView.leadingAnchor.constraint(equalTo: profileImageButton.trailingAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
}
