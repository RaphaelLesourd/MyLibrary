//
//  CollectionViewCell.swift
//  MyBookLibrary
//
//  Created by Birkyboy on 22/10/2021.
//

import UIKit
import Kingfisher

class DetailedBookCollectionViewCell: UICollectionViewCell {
    
    private let imageLoader: ImageRetriever
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        imageLoader = KingFisherImageRetriever()
        super.init(frame: .zero)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.setCustomSpacing(5, after: titleLabel)
        
        setBookCoverViewWidth()
        setTitleStackview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews
    private let bookCover = BookCover(frame: .zero)
    private let titleLabel = TextLabel(fontSize: 13,
                                       weight: .bold)
    private let subtitleLabel = TextLabel(fontSize: 12,
                                          weight: .regular)
    private let descriptionLabel = TextLabel(maxLines: 4,
                                             fontSize: 13,
                                             weight: .regular)
    private let stackView = StackView(axis: .vertical,
                                      alignment: .top,
                                      spacing: 10)
    
    // MARK: - Configure
    func configure(with book: Item) {
        titleLabel.text = book.volumeInfo?.title
        subtitleLabel.text = book.volumeInfo?.authors?.first
        descriptionLabel.text = book.volumeInfo?.volumeInfoDescription
        
        imageLoader.getImage(for: book.volumeInfo?.imageLinks?.thumbnail) { [weak self] image in
            self?.bookCover.image = image
        }
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
