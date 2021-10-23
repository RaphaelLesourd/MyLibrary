//
//  CollectionViewCell.swift
//  MyBookLibrary
//
//  Created by Birkyboy on 22/10/2021.
//

import UIKit

class HorizontalCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "horizontalCell"
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setBookCoverViewWidth()
        setTitleStackview()
        setStackviewConstrainsts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let bookCover = BookCoverImageView(frame: .zero)
    let titleView = CellTitleView()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "This is such a great book about plants and how to make them grown the right way."
        label.numberOfLines = 2
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private let textStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .top
        stack.distribution = .fillProportionally
        return stack
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
}
extension HorizontalCollectionViewCell {
    
    private func setBookCoverViewWidth() {
        bookCover.widthAnchor.constraint(equalToConstant: 90).isActive = true
    }
    
    private func setTitleStackview() {
        textStackView.addArrangedSubview(titleView)
        textStackView.addArrangedSubview(descriptionLabel)
    }
    
    private func setStackviewConstrainsts() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(bookCover)
        stackView.addArrangedSubview(textStackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
