//
//  CellTitleView.swift
//  MyBookLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import Foundation
import UIKit

class CellTitleView: UIView {
   
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setStackviewConstrainsts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    let titleLabel        = TextLabel(fontSize: 14, weight: .bold)
    let subtitleLabel     = TextLabel(fontSize: 13, weight: .regular)
    private let stackView = StackView(axis: .vertical, distribution: .fillProportionally, spacing: 5)
}
// MARK: - Extension
extension CellTitleView {
    private func setStackviewConstrainsts() {
        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
