//
//  AccountPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 19/01/2022.
//

import FirebaseAuth
import Foundation

protocol AccountTabPresenterView: AcitivityIndicatorProtocol, AnyObject {
    func configureView(with user: UserModel)
    func animateSavebuttonIndicator(_ animate: Bool)
}

class AccountTabPresenter {
    
    // MARK: - Properties
    weak var view: AccountTabPresenterView?
    private let userService: UserServiceProtocol
    private let imageService: ImageStorageProtocol
    private let accountService: AccountServiceProtocol
    
    // MARK: - Initializer
    init(userService: UserServiceProtocol,
         imageService: ImageStorageProtocol,
         accountService: AccountServiceProtocol) {
        self.userService = userService
        self.imageService = imageService
        self.accountService = accountService
    }
    
    // MARK: - API Call
    func getProfileData() {
        view?.showActivityIndicator()
        
        userService.retrieveUser { [weak self] result in
            self?.view?.stopActivityIndicator()
            
            switch result {
            case .success(let currentUser):
                guard let currentUser = currentUser else { return }
                self?.view?.configureView(with: currentUser)
            case .failure(let error):
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
    
    func saveUserName(with userName: String?) {
        view?.showActivityIndicator()
        
        userService.updateUserName(with: userName) { [weak self] error in
            self?.view?.stopActivityIndicator()
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            AlertManager.presentAlertBanner(as: .success, subtitle: Text.Banner.userNameUpdated)
        }
    }
    
    func saveProfileImage(_ profileImageData: Data?) {
        self.view?.showActivityIndicator()
        
        imageService.updateUserImage(for: profileImageData) { [weak self] error in
            self?.view?.stopActivityIndicator()
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            AlertManager.presentAlertBanner(as: .success, subtitle: Text.Banner.profilePhotoUpdated)
        }
    }
    
   func signoutAccount() {
        view?.showActivityIndicator()
        view?.animateSavebuttonIndicator(true)
 
        accountService.signOut { [weak self] error in
            self?.view?.stopActivityIndicator()
            self?.view?.animateSavebuttonIndicator(false)

            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            AlertManager.presentAlertBanner(as: .customMessage(Text.Banner.seeYouSoon),
                                            subtitle: Auth.auth().currentUser?.displayName)
        }
    }
}
