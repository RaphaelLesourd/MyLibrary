//
//  CollectionViewCell.swift
//  MyBookLibrary
//
//  Created by Birkyboy on 22/10/2021.
//

import UIKit

class VerticalCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "cell"
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setStackviewConstrainsts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    // MARK: - Subviews
    let bookCover = BookCoverImageButton(frame: .zero)
    let titleView = CellTitleView()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 2
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    func configure() {
        titleView.titleLabel.text = "My great book title"
        titleView.subtitleLabel.text = "Best author"
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
