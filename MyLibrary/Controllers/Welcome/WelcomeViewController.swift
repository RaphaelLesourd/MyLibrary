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
        let onboardingViewController = OnboardingViewController(layoutComposer: OnboardingLayout())
        onboardingViewController.modalPresentationStyle = .fullScreen
        present(onboardingViewController, animated: false, completion: nil)
    }
}
// MARK: - WelcomeMainView Delegate
extension WelcomeViewController: WelcomeViewDelegate {
    func presentAccountViewController(for type: AccountInterfaceType) {
        let accountService = AccountService(userService: UserService(),
                                            libraryService: LibraryService(),
                                            categoryService: CategoryService())
        let welcomeAccountPresenter = SetupAccountPresenter(accountService: accountService,
                                                              validation: Validator())
        let accountSetupController = AccountSetupViewController(presenter: welcomeAccountPresenter,
                                                                interfaceType: type)
        if #available(iOS 15.0, *) {
            presentSheetController(accountSetupController, detents: [.large()])
        } else {
            present(accountSetupController, animated: true, completion: nil)
        }
    }
}
