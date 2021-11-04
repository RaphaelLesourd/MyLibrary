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
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.widthAnchor.constraint(equalTo: button.heightAnchor).isActive = true
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
    
    private let textStackView = StackView(axis: .vertical, distribution: .fillProportionally, spacing: 0)
    private let mainStackView = StackView(axis: .horizontal, spacing: 10)
  
}
extension ProfileStaticCell {
    private func setStackViewConstraints() {
        contentView.addSubview(mainStackView)
        textStackView.addArrangedSubview(userNameTextField)
        textStackView.addArrangedSubview(emailLabel)
        
        mainStackView.addArrangedSubview(profileImageButton)
        mainStackView.addArrangedSubview(textStackView)
        
        NSLayoutConstraint.activate([
            userNameTextField.heightAnchor.constraint(equalToConstant: 40),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
}
