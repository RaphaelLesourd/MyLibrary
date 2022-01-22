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
        setupView()
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
                                       font: .title)
    private let subtitleLabel = TextLabel(color: .secondaryLabel,
                                          maxLines: 2,
                                          alignment: .left,
                                          font: .subtitle)
    private let bookOwnerNameLabel = TextLabel(color: .appTintColor,
                                               maxLines: 1,
                                               alignment: .left,
                                               font: .mediumSemiBoldTitle)
    private let stackView = StackView(axis: .vertical,
                                      spacing: 10)
    
    // MARK: - configure
    func configure(with book: CommentBookCellRepresentable) {
        titleLabel.text = book.title
        subtitleLabel.text = book.authors
        bookCover.getImage(for: book.image) { [weak self] image in
            self?.bookCover.image = image
        }
   
        guard let owner = book.ownerName else {
            bookOwnerNameLabel.isHidden = true
            return
        }
        bookOwnerNameLabel.text = Text.Book.recommendedBy + owner.capitalized
    }
    
    private func setupView() {
        self.backgroundColor = .clear
        self.contentView.roundView(radius: 17, backgroundColor: .cellBackgroundColor)
        bookCover.contentMode = .scaleAspectFill
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.addArrangedSubview(bookOwnerNameLabel)
        stackView.setCustomSpacing(2, after: titleLabel)
    }
}
// MARK: - Constraints
extension CommentsBookCell {
    private func setBookCoverConstraints() {
        contentView.addSubview(bookCover)
        
        bookCover.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bookCover.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            bookCover.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            bookCover.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            bookCover.widthAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    private func setStackViewConstraints() {
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -15),
            stackView.leadingAnchor.constraint(equalTo: bookCover.trailingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
    
}
