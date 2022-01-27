//
//  SetupAccountPresenting.swift
//  MyLibrary
//
//  Created by Birkyboy on 27/01/2022.
//

protocol SetupAccountPresenting {
    var view: SetupAccountPresenterView? { get set }
    var mainView: AccountMainView? { get set }
    func handlesAccountCredentials(for interfaceType: AccountInterfaceType)
    func resetPassword(with email: String?)
    func validateEmail(for text: String)
    func validatePassword(for text: String)
    func validatePasswordConfirmation(for text: String)
}
