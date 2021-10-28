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
    weak var newBookDelegate: NewBookDelegate?
    
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
        view.backgroundColor = .viewControllerBackgroundColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.textView.becomeFirstResponder()
        setDatas()
    }
    
    // MARK: - Setup
    private func setDatas() {
    
    }
}
// MARK: - PanModal Extension
extension TextInputViewController: PanModalPresentable {
    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(100)
    }
   
    var cornerRadius: CGFloat {
        return 20
    }
    
    var panScrollable: UIScrollView? {
        return nil
    }
}
