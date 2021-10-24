//
//  CollectionViewCell.swift
//  MyBookLibrary
//
//  Created by Birkyboy on 22/10/2021.
//

import UIKit

class HorizontalCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "horizontalCell"
    
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
    private let bookCover = BookCoverImageButton(frame: .zero)
    private let titleView = CellTitleView()
    private let descriptionLabel = TextLabel(maxLines: 4, fontSize: 13, weight: .regular)
   
    private let textStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .top
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    func configure() {
        titleView.titleLabel.text = "My great book title"
        titleView.subtitleLabel.text = "Best author"
        descriptionLabel.text = "This is such a great book about plants and how to make them grown the right way."
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
        contentView.addSubview(textStackView)
        textStackView.addArrangedSubview(titleView)
        textStackView.addArrangedSubview(descriptionLabel)
        textStackView.setCustomSpacing(10, after: titleView)
        NSLayoutConstraint.activate([
            textStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            textStackView.leadingAnchor.constraint(equalTo: bookCover.trailingAnchor, constant: 10),
            textStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
