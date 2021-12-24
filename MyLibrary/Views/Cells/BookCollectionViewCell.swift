//
//  CollectionViewCell.swift
//  MyBookLibrary
//
//  Created by Birkyboy on 22/10/2021.
//

import UIKit
import Kingfisher

class BookCollectionViewCell: UICollectionViewCell {
    
    private let imageRetriever: ImageRetriever
   
    // MARK: - Initializer
    override init(frame: CGRect) {
        imageRetriever = KingFisherImageRetriever()
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
    func configure(with book: Item) {
        imageRetriever.getImage(for: book.volumeInfo?.imageLinks?.thumbnail) { [weak self] image in
            self?.bookCover.image = image
        }
    }
    
    override func prepareForReuse() {
        bookCover.image = Images.emptyStateBookImage
    }
    
    override var isHighlighted: Bool {
        didSet {
            let scale = isHighlighted ? 1.05 : 1
            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           options: .curveEaseOut,
                           animations: {
                self.transform = CGAffineTransform(scaleX: scale, y: scale)
            })
        }
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
