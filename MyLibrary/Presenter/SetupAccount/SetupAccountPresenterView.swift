//
//  SetupAccountPresenterView.swift
//  MyLibrary
//
//  Created by Birkyboy on 27/01/2022.
//

protocol SetupAccountPresenterView: AcitivityIndicatorProtocol, AnyObject {
    func dismissViewController()
    func updateEmailTextField(valid: Bool)
    func updatePasswordTextField(valid: Bool)
    func updatePasswordConfirmationTextField(valid: Bool)
}
