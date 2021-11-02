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
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 2
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    func configure(with book: Item) {
        titleView.titleLabel.text = book.volumeInfo?.title
        titleView.subtitleLabel.text = book.volumeInfo?.authors?.first
        guard let imageUrl = book.volumeInfo?.imageLinks?.smallThumbnail, let url = URL(string: imageUrl) else { return }
        bookCover.af.setImage(withURL: url,
                              cacheKey: book.volumeInfo?.industryIdentifiers?.first?.identifier,
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
