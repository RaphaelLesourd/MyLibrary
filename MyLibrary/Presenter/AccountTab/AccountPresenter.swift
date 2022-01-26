//
//  AccountPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 19/01/2022.
//

import FirebaseAuth
import Foundation

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
    /// fetch the user profile data from the Database.
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
    
    /// Saves uer name changes in the database.
    /// - Parameters: Username  optional string
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
    
    /// Save user profile image in the database.
    /// - Parameters: Optional Data type for the image.
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
    
    /// Sign out of the account.
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
