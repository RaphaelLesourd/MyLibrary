//
//  OnboardingPresenterView.swift
//  MyLibrary
//
//  Created by Birkyboy on 27/01/2022.
//

import Foundation

protocol OnboardingPresenterView: AnyObject {
    func setLastPageReached(when lastPage: Bool)
    func scrollCollectionView(to indexPath: IndexPath)
    func presentWelcomeVC()
}
