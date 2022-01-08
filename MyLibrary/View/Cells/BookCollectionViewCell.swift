//
//  CollectionViewCell.swift
//  MyBookLibrary
//
//  Created by Birkyboy on 22/10/2021.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    // MARK: - Subviews
    private let bookCover = BookCover(frame: .zero)
    
    // MARK: - Configure
    func configure(with book: BookCellData) {
        bookCover.image = book.image
    }
    
    override func prepareForReuse() {
        bookCover.image = Images.emptyStateBookImage
    }
}
// MARK: - Constraints
extension BookCollectionViewCell {
    private func setConstraints() {
        bookCover.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bookCover)
        NSLayoutConstraint.activate([
            bookCover.topAnchor.constraint(equalTo: contentView.topAnchor),
            bookCover.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bookCover.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bookCover.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}