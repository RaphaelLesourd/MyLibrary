//
//  ButtonCell.swift
//  MyLibrary
//
//  Created by Birkyboy on 28/10/2021.
//

import Foundation
import UIKit

class ButtonStaticCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setButtonConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String, systemImage: String = "", tintColor: UIColor) {
        self.init()
        self.actionButton.configureButton(with: title, systemImage: systemImage, tintColor: tintColor)
    }
    
    var actionButton = ActionButton()
}
extension ButtonStaticCell {
    private func setButtonConstraints() {
        contentView.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            actionButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            actionButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            actionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
