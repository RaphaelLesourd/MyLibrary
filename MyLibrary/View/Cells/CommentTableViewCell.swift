//
//  CommentCollectionViewCell.swift
//  MyLibrary
//
//  Created by Birkyboy on 28/11/2021.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "cell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupView()
        setProfileImageConstraints()
        setMainStackViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = Images.emptyStateBookImage
        imageView.roundView(radius: 25, backgroundColor: .systemBackground)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let userNameLabel = TextLabel(color: .appTintColor,
                                          maxLines: 1,
                                          alignment: .left,
                                          font: .mediumSemiBoldTitle)
    private let commentLabel = TextLabel(color: .label,
                                         maxLines: 0,
                                         alignment: .natural,
                                         font: .body)
    private let dateLabel = TextLabel(color: .secondaryLabel,
                                      maxLines: 1,
                                      alignment: .left,
                                      font: .lightFootnote)
    private let stackView = StackView(axis: .vertical,
                                      spacing: 15)
    
    // MARK: - Configuration
    func configure(with model: CommentUI) {
        profileImageView.getImage(for: model.profileImage) { [weak self] image in
            self?.profileImageView.image = image
        }
        userNameLabel.text = model.userName
        dateLabel.text = model.date
        commentLabel.text = model.message
        profileImageView.layer.borderWidth = model.currentUser ? 3 : 0
        profileImageView.layer.borderColor = UIColor.appTintColor.cgColor
    }
    
    private func setupView() {
        self.contentView.backgroundColor = .tertiarySystemBackground
        commentLabel.lineBreakMode = .byWordWrapping
        stackView.addArrangedSubview(userNameLabel)
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(commentLabel)
        stackView.setCustomSpacing(2, after: userNameLabel)
    }
    
    override func prepareForReuse() {
        profileImageView.image = Images.emptyStateBookImage
    }
}
// MARK: - Constraints
extension CommentTableViewCell {
    
    private func setProfileImageConstraints() {
        contentView.addSubview(profileImageView)
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            profileImageView.heightAnchor.constraint(equalToConstant: 50),
            profileImageView.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setMainStackViewConstraints() {
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            stackView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
}
