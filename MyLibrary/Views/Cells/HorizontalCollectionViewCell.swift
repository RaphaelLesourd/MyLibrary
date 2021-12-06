//
//  CollectionViewCell.swift
//  MyBookLibrary
//
//  Created by Birkyboy on 22/10/2021.
//

import UIKit
import Kingfisher

class HorizontalCollectionViewCell: UICollectionViewCell {
    
    private let imageLoader: ImageRetriverProtocol
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        imageLoader = ImageRetriver()
        super.init(frame: .zero)
        textStackView.addArrangedSubview(titleView)
        textStackView.addArrangedSubview(descriptionLabel)
        
        setBookCoverViewWidth()
        setTitleStackview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
   // MARK: - Subviews
    private let bookCover = BookCover(frame: .zero)
    private let titleView = CellTitleView()
    private let descriptionLabel = TextLabel(maxLines: 4, fontSize: 13, weight: .regular)
    private let textStackView = StackView(axis: .vertical, alignment: .top, spacing: 10)
    
    override func prepareForReuse() {
        titleView.titleLabel.text = nil
        titleView.subtitleLabel.text = nil
        descriptionLabel.text = nil
        bookCover.image = Images.emptyStateBookImage
    }
    
    func configure(with book: Item) {
        titleView.titleLabel.text = book.volumeInfo?.title
        titleView.subtitleLabel.text = book.volumeInfo?.authors?.first
        descriptionLabel.text = book.volumeInfo?.volumeInfoDescription
        
        imageLoader.getImage(for: book.volumeInfo?.imageLinks?.thumbnail) { [weak self] image in
            self?.bookCover.image = image
        }
    }
}
// MARK: - Constraints
extension HorizontalCollectionViewCell {
    
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
        contentView.addSubview(textStackView)
        NSLayoutConstraint.activate([
            textStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            textStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 10),
            textStackView.leadingAnchor.constraint(equalTo: bookCover.trailingAnchor, constant: 10),
            textStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
