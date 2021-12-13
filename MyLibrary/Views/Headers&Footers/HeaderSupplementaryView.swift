//
//  HeaderSupplementaryView.swift
//  MyBookLibrary
//
//  Created by Birkyboy on 22/10/2021.
//

import UIKit

class HeaderSupplementaryView: UICollectionReusableView {

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setStackViewConstrainsts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    // MARK: - Subviews
    let titleView = TitleView()
   
    func configure(with title: String, buttonTitle: String) {
        titleView.titleLabel.text = title
        titleView.actionButton.setTitle(buttonTitle, for: .normal)
    }
}
// MARK: - Constraints
extension HeaderSupplementaryView {
    private func setStackViewConstrainsts() {
        addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: topAnchor),
            titleView.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleView.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
