//
//  AccountTabPresenterView.swift
//  MyLibrary
//
//  Created by Birkyboy on 26/01/2022.
//

protocol AccountTabPresenterView: AcitivityIndicatorProtocol, AnyObject {
    func configureView(with user: UserModel)
    func animateSavebuttonIndicator(_ animate: Bool)
}
