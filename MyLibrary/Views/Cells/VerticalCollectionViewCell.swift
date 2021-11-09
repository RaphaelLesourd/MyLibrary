//
//  CollectionViewCell.swift
//  MyBookLibrary
//
//  Created by Birkyboy on 22/10/2021.
//

import UIKit
import AlamofireImage

class VerticalCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setStackviewConstrainsts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    // MARK: - Subviews
    private let bookCover = BookCover(frame: .zero)
    private let titleView = CellTitleView()
    private let stackView = StackView(axis: .vertical, spacing: 5)

    override func prepareForReuse() {
        titleView.titleLabel.text    = nil
        titleView.subtitleLabel.text = nil
        bookCover.image              = Images.emptyStateBookImage
    }
    
    func configure(with book: BookSnippet) {
        titleView.titleLabel.text    = book.title
        titleView.subtitleLabel.text = book.author
        
        guard let imageUrl = book.photoURL, let url = URL(string: imageUrl) else { return }
        bookCover.af.setImage(withURL: url,
                              cacheKey: book.id,
                              placeholderImage: Images.emptyStateBookImage,
                              completion: nil)
    }
}
// MARK: - Constraints
extension VerticalCollectionViewCell {
    
    private func setStackviewConstrainsts() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(bookCover)
        stackView.addArrangedSubview(titleView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
