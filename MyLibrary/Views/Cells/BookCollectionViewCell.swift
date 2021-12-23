//
//  CollectionViewCell.swift
//  MyBookLibrary
//
//  Created by Birkyboy on 22/10/2021.
//

import UIKit
import Kingfisher

class BookCollectionViewCell: UICollectionViewCell {
    
    private let imageLoader: ImageRetriever
   
    // MARK: - Initializer
    override init(frame: CGRect) {
        imageLoader = KingFisherImageRetriever()
        super.init(frame: .zero)
        stackView.addArrangedSubview(bookCover)
        stackView.addArrangedSubview(titleView)
        setStackviewConstrainsts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    // MARK: - Subviews
    private let bookCover = BookCover(frame: .zero)
    private let titleView = CellTitleView()
    private let stackView = StackView(axis: .vertical, spacing: 5)

    // MARK: - Configure
    func configure(with book: Item) {
        titleView.titleLabel.text = book.volumeInfo?.title
        titleView.subtitleLabel.text = book.volumeInfo?.authors?.first
        
        imageLoader.getImage(for: book.volumeInfo?.imageLinks?.thumbnail) { [weak self] image in
            self?.bookCover.image = image
        }
    }
    
    override func prepareForReuse() {
        titleView.titleLabel.text = nil
        titleView.subtitleLabel.text = nil
        bookCover.image = Images.emptyStateBookImage
    }
}
// MARK: - Constraints
extension BookCollectionViewCell {
    private func setStackviewConstrainsts() {
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}