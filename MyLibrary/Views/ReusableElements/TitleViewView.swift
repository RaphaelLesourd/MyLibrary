//
//  TitleViewMoreButtonView.swift
//  MyLibrary
//
//  Created by Birkyboy on 27/11/2021.
//

import Foundation
import UIKit

class TitleViewView: UIView {

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(actionButton)
        setStackViewConstrainsts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    // MARK: - Subviews
    let titleLabel = TextLabel(fontSize: 20, weight: .bold)
    let actionButton: UIButton = {
        let button = UIButton()
        button.setTitle("Tout voir", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return button
    }()
    
    private let stackView = StackView(axis: .horizontal, spacing: 0)
}
// MARK: - Constraints
extension TitleViewView {
    private func setStackViewConstrainsts() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
