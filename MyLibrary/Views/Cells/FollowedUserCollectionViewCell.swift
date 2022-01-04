//
//  FolloedUserCollectionViewCell.swift
//  MyLibrary
//
//  Created by Birkyboy on 04/01/2022.
//

import UIKit

class FollowedUserCollectionViewCell: UICollectionViewCell {
  
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(userNameLabel)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Subviews
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.roundView(radius: 35, backgroundColor: .cellBackgroundColor)
        imageView.contentMode = .scaleAspectFill
//        imageView.layer.borderColor = UIColor.appTintColor.cgColor
//        imageView.layer.borderWidth = 2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        return imageView
    }()
    private let userNameLabel = TextLabel(color: .label,
                                          maxLines: 1,
                                          alignment: .center,
                                          fontSize: 14,
                                          weight: .regular)
    private let stackView = StackView(axis: .vertical,
                                      alignment: .center,
                                      spacing: 2)
    // MARK: - configure
    func configure(with user: UserCellData) {
        imageView.image = user.image
        userNameLabel.text = user.userName
    }
}
// MARK: - Constraints
extension FollowedUserCollectionViewCell {
    private func setConstraints() {
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
