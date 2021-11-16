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
    let pictureView = BookCover(frame: .zero)
}
// MARK: - Constraints
extension ImageStaticCell {
    private func setButtonConstraints() {
        pictureView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(pictureView)

        NSLayoutConstraint.activate([
            pictureView.topAnchor.constraint(equalTo: contentView.topAnchor),
            pictureView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            pictureView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            pictureView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            pictureView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8)
        ])
    }
}