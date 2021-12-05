//
//  CommentsBookCell.swift
//  MyLibrary
//
//  Created by Birkyboy on 30/11/2021.
//

import Foundation
import UIKit

class CommentsBookCell: UITableViewCell {
    
    // MARK: - Propoerties
    static let reuseIdentifier = "bookcell"
    
    private let imageLoader: ImageLoaderProtocol
    private let formatter  : FormatterProtocol
   
    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        imageLoader = ImageLoader()
        formatter   = Formatter()
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
       
        contentView.backgroundColor = .clear
        bookCover.rounded(radius: 12, backgroundColor: .clear)
       
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        setContentViewConstraints()
        setBookCoverConstraints()
        setStackViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
   // MARK: - Subviews
    private let bookCover     = BookCover(frame: .zero)
    private let titleLabel    = TextLabel(color: .label, maxLines: 2, alignment: .left, fontSize: 21, weight: .bold)
    private let subtitleLabel = TextLabel(color: .secondaryLabel, maxLines: 2, alignment: .left, fontSize: 16, weight: .medium)
    private let stackView     = StackView(axis: .vertical, spacing: 5)
   
    func configure(with book: Item) {
        titleLabel.text    = book.volumeInfo?.title
        subtitleLabel.text = formatter.joinArrayToString(book.volumeInfo?.authors)
        imageLoader.getImage(for: book.volumeInfo?.imageLinks?.thumbnail) { [weak self] image in
            self?.bookCover.image = image
        }
    }
}
// MARK: - Constraints
extension CommentsBookCell {
    private func setContentViewConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 100),
            contentView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }
    
    private func setBookCoverConstraints() {
        contentView.addSubview(bookCover)
        bookCover.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
           bookCover.topAnchor.constraint(equalTo: contentView.topAnchor),
           bookCover.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
           bookCover.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
           bookCover.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func setStackViewConstraints() {
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: bookCover.trailingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
}
