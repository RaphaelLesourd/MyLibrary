//
//  SetupAccountPresenterView.swift
//  MyLibrary
//
//  Created by Birkyboy on 27/01/2022.
//

protocol SetupAccountPresenterView: AcitivityIndicatorProtocol, AnyObject {
    func dismissViewController()
    func validateEmailTextField(with validated: Bool)
    func validatePasswordTextField(with validation: Bool)
    func validatePasswordConfirmationTextField(with validation: Bool)
}
