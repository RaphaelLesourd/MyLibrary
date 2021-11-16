//
//  CollectionViewCell.swift
//  MyBookLibrary
//
//  Created by Birkyboy on 22/10/2021.
//

import UIKit
import Kingfisher

class HorizontalCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
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
        titleView.titleLabel.text    = nil
        titleView.subtitleLabel.text = nil
        descriptionLabel.text        = nil
        bookCover.image              = Images.emptyStateBookImage
    }
    
    func configure(with book: Item) {
        titleView.titleLabel.text    = book.volumeInfo?.title
        titleView.subtitleLabel.text = book.volumeInfo?.authors?.first
        descriptionLabel.text        = book.volumeInfo?.volumeInfoDescription
        
        guard let imageURL = book.volumeInfo?.imageLinks?.thumbnail,
              let url = URL(string: imageURL) else { return }
        bookCover.kf.setImage(with: url,
                              placeholder: Images.emptyStateBookImage,
                              options: [.cacheOriginalImage, .progressiveJPEG(.default)],
                              completionHandler: nil)
    }
}
// MARK: - Constraints
extension HorizontalCollectionViewCell {
    
    private func setBookCoverViewWidth() {
        bookCover.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(bookCover)
        NSLayoutConstraint.activate([
            bookCover.topAnchor.constraint(equalTo: contentView.topAnchor),
            bookCover.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bookCover.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bookCover.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7)
        ])
    }
    
    private func setTitleStackview() {
        textStackView.addArrangedSubview(titleView)
        textStackView.addArrangedSubview(descriptionLabel)
        
        contentView.addSubview(textStackView)
        NSLayoutConstraint.activate([
            textStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            textStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 10),
            textStackView.leadingAnchor.constraint(equalTo: bookCover.trailingAnchor, constant: 10),
            textStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
