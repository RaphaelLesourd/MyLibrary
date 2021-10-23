//
//  PurchaseView.swift
//  MyBookLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import Foundation
import UIKit

class PurchaseView: UIView {
   
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setStackviewConstrainsts()
        purchaseDateLabel.text = "Purchased in July 1999"
        purchasePriceLabel.text = "€45"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    let purchaseDateLabel = TextLabel(color: .secondaryLabel, fontSize: 14, weight: .light)
    let purchasePriceLabel = TextLabel(color: .secondaryLabel,alignment: .right, fontSize: 20, weight: .semibold)
   
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
}
// MARK: - Extension
extension PurchaseView {
    private func setStackviewConstrainsts() {
        addSubview(stackView)
        stackView.addArrangedSubview(purchaseDateLabel)
        stackView.addArrangedSubview(purchasePriceLabel)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
