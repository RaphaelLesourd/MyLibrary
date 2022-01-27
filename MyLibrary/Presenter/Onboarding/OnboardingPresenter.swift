//
//  OnboardingPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 25/01/2022.
//

import Foundation

protocol OnboardingPresenting {
    var view: OnboardingPresenterView? { get set }
    var onboardingData: [Onboarding] { get }
    var collectionViewCurrentIndex: Int { get set }
    func nextButtonTapped()
}

class OnboardingPresenter {
    
    // MARK: - Properties
    weak var view: OnboardingPresenterView?
    let onboardingData: [Onboarding] = [Onboarding(image: Images.Onboarding.referencing,
                                                   title: Text.Onboarding.referenceBookTitle,
                                                   subtitle: Text.Onboarding.referenceBookSubtitle),
                                        Onboarding(image: Images.Onboarding.searching,
                                                   title: Text.Onboarding.searchBookTitle,
                                                   subtitle: Text.Onboarding.searchBookSubtitle),
                                        Onboarding(image: Images.Onboarding.sharing,
                                                   title: Text.Onboarding.shareBookTitle,
                                                   subtitle: Text.Onboarding.shareBookSubtitle)]
    var collectionViewCurrentIndex = 0 {
        didSet {
            updatePageNumber(with: collectionViewCurrentIndex)
        }
    }
    
    /// Save in Userdefault if the onboarding has been seen or skipped
    private func saveOnboardingSeen() {
        collectionViewCurrentIndex = 0
        UserDefaults.standard.set(true, forKey: UserDefaultKey.onboardingSeen.rawValue)
    }
    
    /// Update the current onboarding page number
    /// - Parameters:
    /// - index: Int of the current collectionView position
    private func updatePageNumber(with index: Int) {
        let lastPage = index == onboardingData.count - 1
        view?.setLastPageReached(lastPage)
    }
}
extension OnboardingPresenter: OnboardingPresenting {
    
    /// Receive the next button tapped gesture and calculate if the current index is the last index of the data to display.
    /// Presents the the Welcome screen if last page reached or the next page
    func nextButtonTapped() {
        if collectionViewCurrentIndex < onboardingData.count - 1 {
            collectionViewCurrentIndex += 1
            let indexPath = IndexPath(item: collectionViewCurrentIndex, section: 0)
            view?.scrollCollectionView(to: indexPath)
        } else {
            saveOnboardingSeen()
            view?.presentWelcomeVC()
        }
    }
}
