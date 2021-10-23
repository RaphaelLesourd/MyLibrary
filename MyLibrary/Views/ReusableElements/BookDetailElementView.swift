//
//  BookDetailElementView.swift
//  MyBookLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import Foundation
import UIKit

class BookDetailElementView: UIView {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(iconSytemName: String) {
        self.init(frame: .zero)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 40,
                                                      weight: .light,
                                                      scale: .medium)
        icon.image = UIImage(systemName: iconSytemName, withConfiguration: imageConfig)
    }
    
    private let icon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .secondaryLabel
        return imageView
    }()
    
    let infoLabel = TextLabel(color: .secondaryLabel, maxLines: 2, fontSize: 14, weight: .light)
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.spacing =  2
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
}
// MARK: - Extension
extension BookDetailElementView {
    private func setConstraints() {
        addSubview(stackView)
        stackView.addArrangedSubview(icon)
        stackView.addArrangedSubview(infoLabel)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
