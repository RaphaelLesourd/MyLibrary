//
//  ImageStaticCell.swift
//  MyLibrary
//
//  Created by Birkyboy on 28/10/2021.
//

import Foundation
import UIKit

class ImageStaticCell: UITableViewCell {
    
    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setButtonConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Subview
    let bookImage = BookCover(frame: .zero)
}
// MARK: - Constraints
extension ImageStaticCell {
    private func setButtonConstraints() {
        contentView.addSubview(bookImage)
        bookImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bookImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            bookImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bookImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            bookImage.heightAnchor.constraint(equalToConstant: 300),
            bookImage.widthAnchor.constraint(equalTo: bookImage.heightAnchor, multiplier: 0.8)
        ])
    }
}
