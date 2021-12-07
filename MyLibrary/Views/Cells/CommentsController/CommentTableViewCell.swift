//
//  CommentCollectionViewCell.swift
//  MyLibrary
//
//  Created by Birkyboy on 28/11/2021.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "cell"
    
    private let imageLoader: ImageRetriverProtocol
    private let formatter  : FormatterProtocol
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        imageLoader = ImageRetriver()
        formatter = Formatter()
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .tertiarySystemBackground
        
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        commentLabel.lineBreakMode = .byWordWrapping
        stackView.addArrangedSubview(userNameLabel)
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(commentLabel)
        stackView.setCustomSpacing(2, after: userNameLabel)
        
        setProfileImageConstraints()
        setMainStackViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
   // MARK: - Subviews
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = Images.emptyStateBookImage
        imageView.rounded(radius: 25, backgroundColor: .systemBackground)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let userNameLabel = TextLabel(color: .appTintColor, maxLines: 1, alignment: .left, fontSize: 16, weight: .medium)
    private let commentLabel = TextLabel(color: .label, maxLines: 0, alignment: .natural, fontSize: 18, weight: .light)
    private let dateLabel = TextLabel(color: .secondaryLabel, maxLines: 1, alignment: .left, fontSize: 11, weight: .light)
    private let stackView = StackView(axis: .vertical, spacing: 15)
    
    func configure(with model: CommentModel) {
        commentLabel.text = model.comment
        if let timestamp = model.timestamp {
            self.dateLabel.text = self.formatter.formatTimeStampToDateString(for: timestamp)
        }
    }
    
    func configureUser(with user: UserModel?) {
        guard let user = user else { return }
        userNameLabel.text = user.displayName.capitalized
        imageLoader.getImage(for: user.photoURL) { [weak self] image in
            self?.profileImageView.image = image
        }
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
