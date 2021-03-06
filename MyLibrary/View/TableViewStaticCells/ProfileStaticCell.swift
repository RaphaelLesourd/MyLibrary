//
//  ProfileStaticCell.swift
//  MyLibrary
//
//  Created by Birkyboy on 03/11/2021.
//

import UIKit

class ProfileStaticCell: UITableViewCell {
    
    // MARK: - Intializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupView()
        setConstraints()
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
        button.heightAnchor.constraint(equalToConstant: 100).isActive = true
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        return button
    }()
    let emailLabel = TextLabel(color: .secondaryLabel,
                               maxLines: 1,
                               alignment: .center,
                               font: .subtitle)
    private let stackView = StackView(axis: .vertical,
                                      distribution: .fill,
                                      alignment: .center,
                                      spacing: 15)
    
    // MARK: - Configuration
    private func setupView() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        stackView.addArrangedSubview(profileImageButton)
        stackView.addArrangedSubview(emailLabel)
    }
}
// MARK: - Constraints
extension ProfileStaticCell {
    private func setConstraints() {
        contentView.addSubview(stackView)
        
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailLabel.heightAnchor.constraint(equalToConstant: 18),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
