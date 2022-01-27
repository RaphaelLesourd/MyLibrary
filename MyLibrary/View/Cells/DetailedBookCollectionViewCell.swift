//
//  CollectionViewCell.swift
//  MyBookLibrary
//
//  Created by Birkyboy on 22/10/2021.
//

import UIKit

class DetailedBookCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
        setBookCoverViewWidth()
        setTitleStackview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews
    private let bookCover = BookCover(frame: .zero)
    private let titleLabel = TextLabel(maxLines: 2,
                                       font: .mediumSemiBoldTitle)
    private let subtitleLabel = TextLabel(font: .smallBoldTitle)
    private let descriptionLabel = TextLabel(color: .secondaryLabel,
                                             maxLines: 4,
                                             font: .smallBody)
    private let stackView = StackView(axis: .vertical,
                                      alignment: .top,
                                      spacing: 10)
    
    // MARK: - Configure
    func configure(with book: BookCellUI) {
        titleLabel.text = book.title
        subtitleLabel.text = book.author
        descriptionLabel.text = book.description
        
        bookCover.getImage(for: book.image) { [weak self] image in
            self?.bookCover.image = image
        }
    }
    
    private func setupView() {
        titleLabel.adjustsFontSizeToFitWidth = false
        subtitleLabel.adjustsFontSizeToFitWidth = false
        descriptionLabel.adjustsFontSizeToFitWidth = false
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.setCustomSpacing(5, after: titleLabel)
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        subtitleLabel.text = nil
        descriptionLabel.text = nil
        bookCover.image = Images.emptyStateBookImage
    }
}
// MARK: - Constraints
extension DetailedBookCollectionViewCell {
    private func setBookCoverViewWidth() {
        contentView.addSubview(bookCover)
        bookCover.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bookCover.topAnchor.constraint(equalTo: contentView.topAnchor),
            bookCover.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bookCover.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bookCover.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7)
        ])
    }
    
    private func setTitleStackview() {
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            stackView.leadingAnchor.constraint(equalTo: bookCover.trailingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
