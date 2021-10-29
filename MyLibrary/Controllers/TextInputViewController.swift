//
//  TermOfUseViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 28/10/2021.
//

import UIKit
import PanModal

class TextInputViewController: UIViewController {
    
    // MARK: - Properties
    private let mainView = TextInputControllerMainView()
    var textInpuType: TextInputType?
    var textViewText: String?
    weak var newBookDelegate: NewBookDelegate?
    
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
        view.backgroundColor = .viewControllerBackgroundColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.textView.becomeFirstResponder()
        setTargets()
        displayData()
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
        dismiss(animated: true)
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
