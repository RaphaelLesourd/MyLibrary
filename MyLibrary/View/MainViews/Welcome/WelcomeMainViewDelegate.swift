//
//  WelcomeMainViewDelegate.swift
//  MyLibrary
//
//  Created by Birkyboy on 13/01/2022.
//

protocol WelcomeViewDelegate: AnyObject {
    func presentAccountViewController(for type: AccountInterfaceType)
}
