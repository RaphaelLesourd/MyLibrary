//
//  CommentsBookCell.swift
//  MyLibrary
//
//  Created by Birkyboy on 30/11/2021.
//

import Foundation
import UIKit

class CommentsBookCell: UITableViewCell {
    
    static let reuseIdentifier = "bookcell"
    
    private let imageLoader: ImageLoaderProtocol
    private let formatter  : FormatterProtocol
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        imageLoader = ImageLoader()
        formatter   = Formatter()
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
       
        contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 150).isActive = true
        contentView.backgroundColor = .tertiarySystemBackground
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.addShadow(opacity: 1, verticalOffset: 3, radius: 5)
        setBackgroundImageConstraints()
        setStackViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
   // MARK: - Subviews
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let titleLabel    = TextLabel(color: .white, maxLines: 2, alignment: .left, fontSize: 21, weight: .bold)
    private let subtitleLabel = TextLabel(color: .white, maxLines: 2, alignment: .left, fontSize: 16, weight: .medium)
    private let stackView     = StackView(axis: .vertical, spacing: 5)
    
    private func animateImage() {
        let transformation = CGAffineTransform.identity.scaledBy(x: 1.05, y: 1.05).translatedBy(x: 0, y: -7)
        UIView.animate(withDuration: 2, delay: 0, options: [.curveEaseIn]) {
            self.backgroundImage.transform = transformation
        }
    }
    
    func configure(with book: Item) {
        titleLabel.text    = book.volumeInfo?.title
        subtitleLabel.text = formatter.joinArrayToString(book.volumeInfo?.authors)
        imageLoader.getImage(for: book.volumeInfo?.imageLinks?.thumbnail) { [weak self] image in
            self?.backgroundImage.image = image
            self?.animateImage()
        }
    }
}
// MARK: - Constraints
extension CommentsBookCell {
    
    private func setBackgroundImageConstraints() {
        contentView.addSubview(backgroundImage)
        NSLayoutConstraint.activate([
            backgroundImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func setStackViewConstraints() {
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
}
