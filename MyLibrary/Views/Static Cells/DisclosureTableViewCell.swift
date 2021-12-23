//
//  DisclosureTableViewCell.swift
//  MyLibrary
//
//  Created by Birkyboy on 22/12/2021.
//

import UIKit

class DisclosureTableViewCell: UITableViewCell {

    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        backgroundColor = .tertiarySystemBackground
        textLabel?.textColor = .secondaryLabel
        selectionStyle = .none
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String) {
        self.init()
        textLabel?.text = title
    }
}
