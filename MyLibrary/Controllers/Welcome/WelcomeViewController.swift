//
//  WelcomeViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 25/10/2021.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    // MARK: - Properties
    private let mainView = WelcomeControllerMainView()
    private let factory: Factory
    
    // MARK: - Initializer
    init() {
        self.factory = ViewControllerFactory()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
        view.backgroundColor = .black
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let onboardingShown = UserDefaults.standard.bool(forKey: UserDefaultKey.onboardingSeen.rawValue)

        guard onboardingShown == false else { return }
        let onboardingViewController = factory.makeOnboardingVC()
        onboardingViewController.modalPresentationStyle = .fullScreen
        present(onboardingViewController, animated: false, completion: nil)
    }
}
// MARK: - WelcomeMainView Delegate
extension WelcomeViewController: WelcomeViewDelegate {
    func presentAccountViewController(for type: AccountInterfaceType) {
        let accountSetupController = factory.makeAccountSetupVC(for: type)
        if #available(iOS 15.0, *) {
            presentSheetController(accountSetupController, detents: [.large()])
        } else {
            present(accountSetupController, animated: true, completion: nil)
        }
    }
}
