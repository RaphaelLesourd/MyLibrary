//
//  SettingsControllerView.swift
//  MyLibrary
//
//  Created by Birkyboy on 11/12/2021.
//

import UIKit

class AccountControllerView {
    
    // MARK: - Properties
    weak var delegate: AccountViewDelegate?
    private let imageRetriever: ImageRetriever
    
    // MARK: - Intialiazer
    init(imageRetriever: ImageRetriever) {
        self.imageRetriever = imageRetriever
        displayAppInfos()
        setTargets()
    }
    
    // MARK: - Subviews
    let activityIndicator = UIActivityIndicatorView()
    let profileCell = ProfileStaticCell()
    let displayNameCell = TextFieldStaticCell(placeholder: Text.Account.userName)
    let signOutCell = ButtonStaticCell(title: Text.ButtonTitle.signOut,
                                       systemImage: "rectangle.portrait.and.arrow.right.fill",
                                       tintColor: .systemPurple,
                                       backgroundColor: .systemPurple)
   
    private let deleteAccountCell = ButtonStaticCell(title: Text.ButtonTitle.deletaAccount,
                                             systemImage: "",
                                             tintColor: .systemRed,
                                             backgroundColor: .clear)
    private let appVersionCell = TextFieldStaticCell(placeholder: Text.Misc.appVersion)
    private let appBuildCell = TextFieldStaticCell(placeholder: Text.Misc.appBuild)
    private let appCreationYearCell = TextFieldStaticCell(placeholder: Text.Misc.appCreationYear)
    private let contactViewCell = ButtonStaticCell(title: Text.ButtonTitle.contactUs,
                                                   systemImage: "envelope.badge.fill",
                                                   tintColor: .appTintColor,
                                                   backgroundColor: .appTintColor)
    
    // MARK: - Configuration
    private func setTargets() {
        profileCell.profileImageButton.addTarget(self, action: #selector(presentImagePicker), for: .touchUpInside)
        signOutCell.actionButton.addTarget(self, action: #selector(signoutRequest), for: .touchUpInside)
        deleteAccountCell.actionButton.addTarget(self, action: #selector(deleteAccount), for: .touchUpInside)
        contactViewCell.actionButton.addTarget(self, action: #selector(presentMail), for: .touchUpInside)
    }
    
    /// Compose tableView cells and serctions using a 2 dimensional array of cells in  sections.
    func composeTableView() -> [[UITableViewCell]] {
        return [[profileCell],
                [displayNameCell],
                [signOutCell, deleteAccountCell],
                [appVersionCell, appBuildCell, appCreationYearCell],
                [contactViewCell]
        ]
    }
    
    // MARK: - Display data
    func updateProfileInfos(for currentUser: UserModel) {
        profileCell.emailLabel.text = currentUser.email
        
        displayNameCell.textField.clearButtonMode = .always
        displayNameCell.textField.text = currentUser.displayName
      
        imageRetriever.getImage(for: currentUser.photoURL) { [weak self] image in
            self?.profileCell.profileImageButton.setImage(image, for: .normal)
        }
    }
    
    private func displayAppInfos() {
        appVersionCell.textField.isUserInteractionEnabled = false
        appVersionCell.textField.text = UIApplication.release
        
        appBuildCell.textField.isUserInteractionEnabled = false
        appBuildCell.textField.text = UIApplication.build
        
        appCreationYearCell.textField.isUserInteractionEnabled = false
        appCreationYearCell.textField.text = "2021"
    }
    
    // MARK: - Targets
    @objc private func presentImagePicker() {
        delegate?.presentImagePicker()
    }
    
    @objc private func signoutRequest() {
        delegate?.signoutRequest()
    }
    
    @objc private func deleteAccount() {
        delegate?.deleteAccount()
    }
    
    @objc private func presentMail() {
        delegate?.presentMailComposer()
    }
}
