//
//  TextFieldCell.swift
//  MyLibrary
//
//  Created by Birkyboy on 28/10/2021.
//

import Foundation
import UIKit

class TextFieldStaticCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        backgroundColor = .tertiarySystemBackground
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(placeholder: String, keyboardType: UIKeyboardType = .default) {
        self.init()
        titleLabel.text              = placeholder
        textField.autocorrectionType = .no
        textField.placeholder        = placeholder
        textField.keyboardType       = keyboardType
    }
    let titleLabel = TextLabel(color: .secondaryLabel, maxLines: 2, alignment: .left, fontSize: 12, weight: .regular)
    let textField  = TextField()
    private let stackView = StackView(axis: .horizontal, distribution: .fill, spacing: 0)
}
// MARK: - Constraints
extension TextFieldStaticCell {
    private func setConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(textField)
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalToConstant: 70),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
   
}