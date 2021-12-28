//
//  TermOfUseViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 28/10/2021.
//

import UIKit
import IQKeyboardManagerSwift

class BookDescriptionViewController: UIViewController {
    
    // MARK: - Properties
    var textViewText: String?
    weak var newBookDelegate: NewBookDelegate?
    private let textView = UITextView()
  
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .viewControllerBackgroundColor
        title = Text.ControllerTitle.description
        configureTextView()
        setTextViewConsraints()
        displayData()
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        updateData()
    }
    // MARK: - Setup
    private func configureTextView() {
        textView.backgroundColor = .clear
        textView.autocorrectionType = .yes
        textView.isEditable = true
        textView.isSelectable = true
        textView.alwaysBounceVertical = true
        textView.showsVerticalScrollIndicator = true
        textView.isScrollEnabled = true
        textView.textAlignment = .justified
        textView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textView.textColor = .label
        textView.sizeToFit()
    }
    
    // MARK: - Data
    private func displayData() {
        guard let text = textViewText, !text.isEmpty else { return }
        textView.text = text
    }
    
    private func updateData() {
        if textView.text != textViewText {
            AlertManager.presentAlert(withTitle: Text.Alert.descriptionChangedTitle,
                                      message: Text.Alert.descriptionChangedMessage,
                                      withCancel: true,
                                      on: self,
                                      cancelHandler: nil) { [weak self] _ in
                self?.newBookDelegate?.bookDescription = self?.textView.text
            }
        }
    }
}
// MARK: - Constraints
extension BookDescriptionViewController {
    private func setTextViewConsraints() {
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -350),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
    }
}
