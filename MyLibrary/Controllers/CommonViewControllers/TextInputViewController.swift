//
//  TermOfUseViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 28/10/2021.
//

import UIKit
import PanModal
import InputBarAccessoryView
import IQKeyboardManagerSwift

class TextInputViewController: UIViewController {
    
    // MARK: - Properties
    private let mainView = TextInputControllerMainView()
    var textInpuType: TextInputType?
    var textViewText: String?
    weak var newBookDelegate : NewBookDelegate?
    var messageInputBar = InputBarAccessoryView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
        view.backgroundColor = .viewControllerBackgroundColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTargets()
        displayData()
        
        messageInputBar.backgroundColor = .tertiarySystemBackground
        let inputTextView = messageInputBar.inputTextView
        inputTextView.layer.cornerRadius = 14.0
        inputTextView.layer.borderWidth = 0.0
        inputTextView.backgroundColor = .systemBackground
        inputTextView.font = UIFont.systemFont(ofSize: 16.0)
        inputTextView.placeholderLabel.text = "Comment"
        inputTextView.textContainerInset = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 6, left: 15, bottom: 6, right: 15)
        
        let sendButton = messageInputBar.sendButton
        sendButton.title = "Done"
        sendButton.setSize(CGSize(width: 30, height: 30), animated: false)
        mainView.textView.inputAccessoryView = messageInputBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainView.textView.becomeFirstResponder()
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.largeTitleDisplayMode = .always
    }
    
    // MARK: - Setup
    private func setTargets() {
        mainView.saveButton.addTarget(self, action: #selector(sendBackText), for: .touchUpInside)
    }
    
    // MARK: - Data
    private func displayData() {
        guard let text = textViewText, !text.isEmpty else { return }
        mainView.textView.text = text
    }
    
    @objc private func sendBackText() {
        guard let text = mainView.textView.text, !text.isEmpty else {
            presentAlertBanner(as: .error, subtitle: "Il n'y rien à sauver.")
            return
        }
        if textInpuType == .description {
            newBookDelegate?.bookDescription = text
        } else {
            newBookDelegate?.bookComment = text
        }
        navigationController?.popViewController(animated: true)
    }
}
// MARK: - PanModal Extension
extension TextInputViewController: PanModalPresentable {
    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(50)
    }
   
    var cornerRadius: CGFloat {
        return 20
    }
    
    var panScrollable: UIScrollView? {
        return nil
    }
}
