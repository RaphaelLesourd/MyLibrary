//
//  FolloedUserCollectionViewCell.swift
//  MyLibrary
//
//  Created by Birkyboy on 04/01/2022.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
  
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
        setStackViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Subviews
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.roundView(radius: 35, backgroundColor: .cellBackgroundColor)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.appTintColor.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
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
        imageView.layer.borderWidth = user.currentUser ? 3 : 0
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
}
