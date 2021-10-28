//
//  TermOfUseControllerMainView.swift
//  MyLibrary
//
//  Created by Birkyboy on 28/10/2021.
//

import UIKit

class TextInputControllerMainView: UIView {

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setStackViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews
    let textView: UITextView = {
        let textView = UITextView()
        textView.rounded(radius: 12, backgroundColor: .tertiarySystemBackground)
        textView.autocorrectionType = .yes
        textView.isEditable = true
        textView.isSelectable = true
        textView.alwaysBounceVertical = true
        textView.showsVerticalScrollIndicator = true
        textView.isScrollEnabled = true
        textView.textAlignment = .justified
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        textView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textView.sizeToFit()
        textView.textColor = .label
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        return textView
    }()
    let saveButton = ActionButton(title: "Sauvegarder", systemImage: "arrow.down.doc.fill")
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
}
// MARK: - Constraints
extension TextInputControllerMainView {
    private func setStackViewConstraints() {
        addSubview(stackView)
        stackView.addArrangedSubview(textView)
        stackView.addArrangedSubview(saveButton)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
