//
//  FolloedUserCollectionViewCell.swift
//  MyLibrary
//
//  Created by Birkyboy on 04/01/2022.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
  
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
        setStackViewConstraints()
        setCurrentUserIconConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Subviews
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.roundView(radius: 35, backgroundColor: .cellBackgroundColor)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        return imageView
    }()
    private let currentUserIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.ButtonIcon.categoryBadge
        imageView.tintColor = .appTintColor
        imageView.addShadow()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let userNameLabel = TextLabel(color: .label,
                                          maxLines: 1,
                                          alignment: .center,
                                          font: .extraSmallTitle)
    private let stackView = StackView(axis: .vertical,
                                      alignment: .center,
                                      spacing: 2)
    // MARK: - configure
    func configure(with user: UserCellUI) {
        userNameLabel.text = user.userName
        currentUserIcon.isHidden = !user.currentUser
        imageView.getImage(for: user.profileImage) { [weak self] image in
            self?.imageView.image = image
        }
    }
    
    private func setupView() {
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(userNameLabel)
    }
    
    override func prepareForReuse() {
        imageView.image = nil
        userNameLabel.text = nil
        currentUserIcon.isHidden = true
    }
}
// MARK: - Constraints
extension UserCollectionViewCell {
    private func setStackViewConstraints() {
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func setCurrentUserIconConstraints() {
        contentView.addSubview(currentUserIcon)
        NSLayoutConstraint.activate([
            currentUserIcon.topAnchor.constraint(equalTo: contentView.topAnchor),
            currentUserIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            currentUserIcon.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
