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
        stackView.addArrangedSubview(bookCover)
        setStackviewConstrainsts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    // MARK: - Subviews
    private let bookCover = BookCover(frame: .zero)
    private let stackView = StackView(axis: .vertical,
                                      spacing: 5)

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
