//
//  SwitchCell.swift
//  MyLibrary
//
//  Created by Birkyboy on 02/01/2022.
//

import UIKit

class SwitchCell: UITableViewCell {
    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        backgroundColor = .tertiarySystemBackground
        selectionStyle = .none
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(valueSwitch)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(placeholder: String) {
        self.init()
        titleLabel.text = placeholder
    }
    // MARK: - Subviews
    let valueSwitch: UISwitch = {
        let valueSwitch = UISwitch()
        valueSwitch.onTintColor = .appTintColor
        return valueSwitch
    }()
    private let titleLabel = TextLabel(color: .secondaryLabel,
                               maxLines: 1,
                               alignment: .left,
                               fontSize: 18,
                               weight: .regular)
    private let stackView = StackView(axis: .horizontal,
                                      distribution: .fill,
                                      spacing: 0)
}
// MARK: - Constraints
extension SwitchCell {
    private func setConstraints() {
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
}
