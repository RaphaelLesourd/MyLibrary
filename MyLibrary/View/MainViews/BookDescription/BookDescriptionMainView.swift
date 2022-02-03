//
//  BookDescriptionMainView.swift
//  MyLibrary
//
//  Created by Birkyboy on 08/01/2022.
//

import UIKit

class DescriptionMainView: UIView {
    
    // MARK: Properties
    weak var delegate: DescriptionViewDelegate?
    var bottomConstraint = NSLayoutConstraint()
    
    // MARK: - Intializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addButtonAction()
        setStackViewConsraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - SubView
    let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.autocorrectionType = .yes
        textView.isEditable = true
        textView.isSelectable = true
        textView.alwaysBounceVertical = true
        textView.showsVerticalScrollIndicator = false
        textView.isScrollEnabled = true
        textView.textAlignment = .justified
        textView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textView.textColor = .label
        textView.sizeToFit()
        return textView
    }()
    private let doneButton = Button(title: Text.ButtonTitle.done,
                                    icon: Images.ButtonIcon.done)
    private let stackView = StackView(axis: .vertical,
                                      spacing: 20)
    
    // MARK: - Configure
    private func addButtonAction() {
        doneButton.addAction(UIAction(handler: { [weak self] _ in
            self?.delegate?.saveDescription()
        }), for: .touchUpInside)
    }
}
// MARK: - Constraints
extension DescriptionMainView {
    private func setStackViewConsraints() {
        addSubview(stackView)
        stackView.addArrangedSubview(textView)
        stackView.addArrangedSubview(doneButton)
        
        bottomConstraint = stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            bottomConstraint
        ])
    }
}
