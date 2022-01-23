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
    weak var newBookDelegate: NewBookViewControllerDelegate?
    private var textViewText: String?
    private let mainView = DescriptionMainView()
    
    // MARK: - Initializer
    init(bookDescription: String?,
         newBookDelegate: NewBookViewControllerDelegate) {
        self.textViewText = bookDescription
        self.newBookDelegate = newBookDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
        view.backgroundColor = .viewControllerBackgroundColor
        title = Text.ControllerTitle.description
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainView.textView.becomeFirstResponder()
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardObserver()
        displayData()
        mainView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = true
        updateData()
    }
    // MARK: - Setup
    private func keyboardObserver() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(adjustForKeyboard),
                                       name: UIResponder.keyboardWillHideNotification,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(adjustForKeyboard),
                                       name: UIResponder.keyboardWillChangeFrameNotification,
                                       object: nil)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            animateConstraintChange(with: 0)
        } else {
            let height = keyboardViewEndFrame.height - view.safeAreaInsets.bottom
            animateConstraintChange(with: height)
        }
    }
    
    private func animateConstraintChange(with height: CGFloat) {
        mainView.bottomConstraint.constant = -(height + 10)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Data
    private func displayData() {
        guard let text = textViewText, !text.isEmpty else { return }
        mainView.textView.text = text
    }
    
    private func updateData() {
        newBookDelegate?.setDescription(with: mainView.textView.text)
    }
}
// MARK: - DescriptionViewDelegate
extension BookDescriptionViewController: DescriptionViewDelegate {
    func saveDescription() {
        updateData()
        dismissController()
    }
}
