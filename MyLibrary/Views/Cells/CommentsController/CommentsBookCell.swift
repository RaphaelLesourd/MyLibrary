//
//  CommentsBookCell.swift
//  MyLibrary
//
//  Created by Birkyboy on 30/11/2021.
//

import UIKit

class CommentsBookCell: UITableViewCell {
    
    // MARK: - Propoerties
    static let reuseIdentifier = "bookcell"
    
    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        bookCover.contentMode = .scaleAspectFit
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.addArrangedSubview(bookOwnerNameLabel)
        
        stackView.setCustomSpacing(2, after: titleLabel)
        
        setBookCoverConstraints()
        setStackViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
   // MARK: - Subviews
    private let bookCover = BookCover(frame: .zero)
    private let titleLabel = TextLabel(color: .label,
                                       maxLines: 2,
                                       alignment: .left,
                                       fontSize: 21,
                                       weight: .bold)
    private let subtitleLabel = TextLabel(color: .secondaryLabel,
                                          maxLines: 1,
                                          alignment: .left,
                                          fontSize: 16,
                                          weight: .medium)
    private let bookOwnerNameLabel = TextLabel(color: .appTintColor,
                                               maxLines: 1,
                                               alignment: .left,
                                               fontSize: 14,
                                               weight: .regular)
    private let stackView = StackView(axis: .vertical,
                                      spacing: 10)
   
    func configure(with book: BookCellData) {
        titleLabel.text = book.title
        subtitleLabel.text = book.author
        bookCover.image = book.image
    }
    
    func configureOwnerDetails(with owner: UserModel?) {
        guard let owner = owner else {
            bookOwnerNameLabel.isHidden = true
            return
        }
        bookOwnerNameLabel.text = Text.Book.recommendedBy + owner.displayName.capitalized
    }
}
// MARK: - Constraints
extension CommentsBookCell {
    
    private func setBookCoverConstraints() {
        let bookCoverHeight = bookCover.heightAnchor.constraint(equalToConstant: 100)
        bookCoverHeight.priority = UILayoutPriority.defaultLow
        bookCover.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(bookCover)
        NSLayoutConstraint.activate([
           bookCover.topAnchor.constraint(equalTo: contentView.topAnchor),
           bookCover.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
           bookCover.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
           bookCover.widthAnchor.constraint(equalToConstant: 80),
           bookCoverHeight
        ])
    }
    
    private func setStackViewConstraints() {
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: bookCover.trailingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
}
