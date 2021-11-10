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
        textView.backgroundColor              = .clear
        textView.autocorrectionType           = .yes
        textView.isEditable                   = true
        textView.isSelectable                 = true
        textView.alwaysBounceVertical         = true
        textView.showsVerticalScrollIndicator = true
        textView.isScrollEnabled              = true
        textView.textAlignment                = .justified
        textView.font                         = UIFont.systemFont(ofSize: 16, weight: .regular)
        textView.textColor                    = .label
        textView.sizeToFit()
        return textView
    }()
    
    let saveButton        = ActionButton(title: "Sauvegarder", systemImage: "arrow.down.doc.fill")
    private let stackView = StackView(axis: .vertical, spacing: 20)

}
// MARK: - Constraints
extension TextInputControllerMainView {
    private func setStackViewConstraints() {
        addSubview(stackView)
        stackView.addArrangedSubview(textView)
        stackView.addArrangedSubview(saveButton)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -313)
        ])
    }
}
