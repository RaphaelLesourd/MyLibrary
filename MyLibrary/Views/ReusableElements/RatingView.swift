//
//  RatingView.swift
//  MyLibrary
//
//  Created by Birkyboy on 13/11/2021.
//

import Foundation
import UIKit

class RatingView: UIView {
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setStackViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subview
    private let starImage: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor    = .systemOrange
        imageView.contentMode  = .scaleAspectFit
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 15, weight: .regular, scale: .small)
        imageView.image        = UIImage(systemName: "star.fill")
        return imageView
    }()
    
    private let stackView = StackView(axis: .horizontal, distribution: .fillEqually, alignment: .fill, spacing: 5)
   
    func setRating(for rating: Int) {
        for _ in 0...rating {
            print("star")
            stackView.addArrangedSubview(starImage)
            
        }
    }
}
// MARK: - Constraints
extension RatingView {
    private func setStackViewConstraints() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.heightAnchor.constraint(equalToConstant: 15),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
