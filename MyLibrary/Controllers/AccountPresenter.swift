//
//  AccountPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 19/01/2022.
//

import FirebaseAuth
import Foundation

protocol AccountTabPresenterView: AnyObject {
    func configureView(with user: UserModel)
    func showActivityIndicator()
    func stopActivityIndicator()
    func animateSavebuttonIndicator(_ animate: Bool)
}

class AccountTabPresenter {
    
    weak var view: AccountTabPresenterView?
    private let userService: UserServiceProtocol
    private let imageService: ImageStorageProtocol
    private let accountService: AccountServiceProtocol
    
    init(userService: UserServiceProtocol,
         imageService: ImageStorageProtocol,
         accountService: AccountServiceProtocol) {
        self.userService = userService
        self.imageService = imageService
        self.accountService = accountService
    }
    
    func getProfileData() {
        view?.showActivityIndicator()
        
        userService.retrieveUser { [weak self] result in
            guard let self = self else { return }
            self.view?.stopActivityIndicator()
            
            switch result {
            case .success(let currentUser):
                guard let currentUser = currentUser else { return }
                DispatchQueue.main.async {
                    self.view?.configureView(with: currentUser)
                }
            case .failure(let error):
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
    
    func saveUserName(with userName: String?) {
        view?.showActivityIndicator()
        
        userService.updateUserName(with: userName) { [weak self] error in
            guard let self = self else { return }
            self.view?.stopActivityIndicator()

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
        let userDisplayName = Auth.auth().currentUser?.displayName ?? ""
        view?.showActivityIndicator()
        view?.animateSavebuttonIndicator(true)
 
        accountService.signOut { [weak self] error in
            guard let self = self else { return }
            self.view?.stopActivityIndicator()
            self.view?.animateSavebuttonIndicator(false)

            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            AlertManager.presentAlertBanner(as: .customMessage(Text.Banner.seeYouSoon), subtitle: userDisplayName)
        }
    }
}
