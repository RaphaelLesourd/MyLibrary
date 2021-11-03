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
        contentView.addSubview(textField)
        textField.frame = CGRect(x: 20, y: 0, width: contentView.bounds.width, height:contentView.bounds.height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(placeholder: String, keyboardType: UIKeyboardType = .default) {
        self.init()
        textField.autocorrectionType = .no
        textField.placeholder = placeholder
        textField.keyboardType = keyboardType
    }
    
    let textField: UITextField = {
        let textField = UITextField()
        return textField
    }()
}
