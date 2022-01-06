//
//  ColorCollectionViewCell.swift
//  MyLibrary
//
//  Created by Birkyboy on 06/01/2022.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    
    private let selectionColor = UIColor.label.withAlphaComponent(0.8).cgColor
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.roundView(radius: 15, backgroundColor: .clear)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    func configure(with hex: String) {
        contentView.backgroundColor = UIColor(hexString: hex)
    }
    
    override var isSelected: Bool {
        didSet {
            contentView.layer.borderColor = selectionColor
            contentView.layer.borderWidth = isSelected ? 2 : 0
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        contentView.layer.borderColor = selectionColor
    }
}
