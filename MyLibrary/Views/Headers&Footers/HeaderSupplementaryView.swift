//
//  HeaderSupplementaryView.swift
//  MyBookLibrary
//
//  Created by Birkyboy on 22/10/2021.
//

import Foundation
import UIKit

class HeaderSupplementaryView: UICollectionReusableView {

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
    
    private let stackView = StackView(axis: .horizontal, spacing: 20)
   
    func configure(with title: String, buttonTitle: String) {
        titleLabel.text = title
        actionButton.setTitle(buttonTitle, for: .normal)
    }
}
// MARK: - Constraints
extension HeaderSupplementaryView {
  
    private func setStackviewConstrainsts() {
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(actionButton)
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
