//
//  TextField.swift
//  MyLibrary
//
//  Created by Birkyboy on 25/10/2021.
//

import UIKit

class TextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(placeholder: String,
                     keyBoardType: UIKeyboardType = .default,
                     returnKey: UIReturnKeyType = .done,
                     correction: UITextAutocorrectionType = .no,
                     capitalization: UITextAutocapitalizationType) {
        self.init(frame: .zero)
        configure(placeholder: placeholder,
                  keyboardType: keyBoardType,
                  returnKey: returnKey,
                  correction: correction,
                  capitalization: capitalization)
    }
    
    private func setup() {
        self.rounded(radius: 12, backgroundColor: .tertiarySystemBackground)
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 2))
        self.leftView = leftView
        self.leftViewMode = .always
        self.clearButtonMode = .whileEditing
        self.adjustsFontSizeToFitWidth = true
        self.textColor = .label
        self.font = .systemFont(ofSize: 18, weight: .regular)
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.clear.cgColor
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    private func configure(placeholder: String = "",
                           keyboardType: UIKeyboardType = .default,
                           returnKey: UIReturnKeyType = .done,
                           correction: UITextAutocorrectionType = .default,
                           capitalization:  UITextAutocapitalizationType = .sentences) {
        self.keyboardType = keyboardType
        self.returnKeyType = returnKey
        self.autocorrectionType = correction
        self.autocapitalizationType = capitalization
        self.placeholder = placeholder
    }
}
