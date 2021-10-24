//
//  HeaderSupplementaryView.swift
//  MyBookLibrary
//
//  Created by Birkyboy on 22/10/2021.
//

import Foundation
import UIKit

class HeaderSupplementaryView: UICollectionReusableView {
    
    static let reuseIdentifier = "header"
    static let kind = "header"
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setStackviewConstrainsts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    // MARK: - Subviews
    private let titleLabel = TextLabel(fontSize: 20, weight: .bold)
    let actionButton: UIButton = {
        let button = UIButton()
        button.setTitle("Tout voir", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return button
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    func configureTitle(with title: String) {
        titleLabel.text = title
    }
}
// MARK: - Constraints
extension HeaderSupplementaryView {
  
    private func setStackviewConstrainsts() {
        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(actionButton)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
