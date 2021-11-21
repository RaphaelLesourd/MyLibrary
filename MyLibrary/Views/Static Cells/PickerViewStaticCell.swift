//
//  LanguageChoiceStaticCell.swift
//  MyLibrary
//
//  Created by Birkyboy on 14/11/2021.
//

import Foundation
import UIKit

class PickerViewStaticCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        backgroundColor = .tertiarySystemBackground
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(placeholder: String) {
        self.init()
        titleLabel.text = placeholder
    }
    let titleLabel = TextLabel(color: .secondaryLabel, maxLines: 2, alignment: .left, fontSize: 12, weight: .regular)
    let pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return picker
    }()
    private let stackView = StackView(axis: .horizontal, distribution: .fill, spacing: 0)
}
// MARK: - Constraints
extension PickerViewStaticCell {
    private func setConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(pickerView)
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalToConstant: 70),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
}
