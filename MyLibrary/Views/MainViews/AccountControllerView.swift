//
//  SettingsControllerView.swift
//  MyLibrary
//
//  Created by Birkyboy on 11/12/2021.
//

import UIKit

protocol AccountViewDelegate: AnyObject {
    func presentImagePicker()
    func signoutRequest()
    func deleteAccount()
    func presentMailComposer()
}

class AccountControllerView {
    
    private let imageRetriever: ImageRetriverProtocol
    weak var delegate: AccountViewDelegate?
    
    init(imageRetriever: ImageRetriverProtocol) {
        self.imageRetriever = imageRetriever
        displayAppInfos()
        setTargets()
    }
    
    // MARK: - Subviews
    let activityIndicator = UIActivityIndicatorView()
    lazy var profileCell = ProfileStaticCell()
    lazy var displayNameCell = TextFieldStaticCell(placeholder: "Nom d'utilisateur")
    let signOutCell = ButtonStaticCell(title: Text.ButtonTitle.signOut,
                                       systemImage: "rectangle.portrait.and.arrow.right.fill",
                                       tintColor: .systemPurple,
                                       backgroundColor: .systemPurple)
    let deleteAccountCell = ButtonStaticCell(title: "Supprimer le compte",
                                             systemImage: "",
                                             tintColor: .systemRed,
                                             backgroundColor: .clear)
    
    private lazy var appVersionCell = TextFieldStaticCell(placeholder: "Version")
    private lazy var appBuildCell = TextFieldStaticCell(placeholder: "Build")
    private lazy var appCreationYearCell = TextFieldStaticCell(placeholder: "Année création")
    private let contactViewCell = ButtonStaticCell(title: "Contactez nous",
                                                   systemImage: "",
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
                [appVersionCell, appBuildCell, appCreationYearCell, contactViewCell]
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
