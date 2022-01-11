//
//  ColorCollectionViewCell.swift
//  MyLibrary
//
//  Created by Birkyboy on 06/01/2022.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subview
    private let colorBadge: UIImageView = {
        let view = UIImageView()
        view.image = Images.ButtonIcon.categoryBadge
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Configure
    
    func configurePickerCell(with colorHex: String) {
        colorBadge.image = UIImage(systemName: "paintpalette.fill")
        configure(with: colorHex)
    }
   
    func configure(with colorHex: String) {
        colorBadge.tintColor = UIColor(hexString: colorHex)
    }
    
    override var isSelected: Bool {
        didSet {
            colorBadge.image = isSelected ? Images.ButtonIcon.selectedCategoryBadge : Images.ButtonIcon.categoryBadge
        }
    }
}
// MARK: - Constrains
extension ColorCollectionViewCell {
    private func setConstraints() {
        contentView.addSubview(colorBadge)
        NSLayoutConstraint.activate([
            colorBadge.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorBadge.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            colorBadge.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorBadge.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
