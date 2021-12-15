//
//  PurchaseView.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit

class PurchaseView: UIView {
   
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(purchasePriceLabel)
        setStackviewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    // MARK: - Subviews
    let titleLabel = TextLabel(color: .secondaryLabel, fontSize: 14, weight: .light)
    let purchasePriceLabel = TextLabel(color: .secondaryLabel,alignment: .right, fontSize: 20, weight: .semibold)
    private let stackView = StackView(axis: .horizontal, distribution: .fillProportionally, spacing: 20)
}
// MARK: - Constraints
extension PurchaseView {
    private func setStackviewConstraints() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
