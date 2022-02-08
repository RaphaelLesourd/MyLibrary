//
//  OnboardingPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 25/01/2022.
//

import Foundation

class OnboardingPresenter {

    weak var view: OnboardingPresenterView?
    var collectionViewCurrentIndex = 0 {
        didSet {
            updatePageNumber(with: collectionViewCurrentIndex)
        }
    }

    /// Receive the next button tapped gesture and calculate if the current index is the last index of the data to display.
    /// Presents the the Welcome screen if last page reached or the next page
    func nextButtonTapped() {
        if collectionViewCurrentIndex < Onboarding.pages.count - 1 {
            collectionViewCurrentIndex += 1
            let indexPath = IndexPath(item: collectionViewCurrentIndex, section: 0)
            view?.scrollCollectionView(to: indexPath)
        } else {
            saveOnboardingSeen()
        }
    }

    /// Save in Userdefault if the onboarding has been seen or skipped
    func saveOnboardingSeen() {
        collectionViewCurrentIndex = 0
        UserDefaults.standard.set(true, forKey: UserDefaultKey.onboardingSeen.rawValue)
        view?.presentWelcomeVC()
    }

    // MARK: - Private functions
    private func updatePageNumber(with index: Int) {
        let lastPage = index == Onboarding.pages.count - 1
        view?.setLastPageReached(when: lastPage)
    }
}
