//
//  CommentCollectionViewCell.swift
//  MyLibrary
//
//  Created by Birkyboy on 28/11/2021.
//

import UIKit

class CommentCollectionViewCell: UICollectionViewCell {
    
    private let imageLoader: ImageLoaderProtocol
    private let formatter  : Formatter
    // MARK: - Initializer
    override init(frame: CGRect) {
        imageLoader = ImageLoader()
        formatter   = Formatter()
        super.init(frame: .zero)
        mainStackView.addArrangedSubview(userStackView)
        mainStackView.addArrangedSubview(commentLabel)
        mainStackView.addArrangedSubview(dateLabel)
        
        userStackView.addArrangedSubview(profileImageView)
        userStackView.addArrangedSubview(userInfoStackView)
        
        userInfoStackView.addArrangedSubview(userNameLabel)
        userInfoStackView.addArrangedSubview(emailLabel)
        
        setMainStackViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
   // MARK: - Subviews
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.rounded(radius: 20, backgroundColor: .systemBackground)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        return imageView
    }()
    
    private let userNameLabel = TextLabel(color: .appTintColor, maxLines: 1, alignment: .left, fontSize: 16, weight: .medium)
    private let emailLabel    = TextLabel(color: .secondaryLabel, maxLines: 1, alignment: .left, fontSize: 14, weight: .light)
    private let commentLabel  = TextLabel(color: .label, maxLines: 0, alignment: .natural, fontSize: 18, weight: .regular)
    private let dateLabel     = TextLabel(color: .secondaryLabel, maxLines: 1, alignment: .right, fontSize: 14, weight: .light)
    
    private let userInfoStackView = StackView(axis: .vertical, spacing: UIStackView.spacingUseSystem)
    private let userStackView     = StackView(axis: .horizontal, spacing: UIStackView.spacingUseSystem)
    private let mainStackView     = StackView(axis: .vertical, spacing: 20)
    
    func configure(with model: CommentModel) {
        commentLabel.text  = model.comment
        if let timestamp = model.timestamp {
            self.dateLabel.text = self.formatter.formatTimeStampToDateString(for: timestamp)
        }
    }
    
    func configureUser(with user: CurrentUser?) {
        guard let user = user else { return }
        DispatchQueue.main.async {
            self.userNameLabel.text = user.displayName.capitalized
            self.emailLabel.text    = user.email
        }
        imageLoader.getImage(for: user.photoURL) { [weak self] image in
            DispatchQueue.main.async {
                self?.profileImageView.image = image
            }
        }
    }
    
    override func prepareForReuse() {
        profileImageView.image = nil
        userNameLabel.text     = nil
        emailLabel.text        = nil
        commentLabel.text      = nil
        dateLabel.text         = nil
    }
}
// MARK: - Constraints
extension CommentCollectionViewCell {
    private func setMainStackViewConstraints() {
        addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
