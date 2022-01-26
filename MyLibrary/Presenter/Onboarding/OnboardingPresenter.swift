//
//  OnboardingPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 25/01/2022.
//

import Foundation

protocol OnboardingPresenterView: AnyObject {
    func setLastPageReached(_ lastPage: Bool)
    func scrollCollectionView(to indexPath: IndexPath)
    func presentWelcomeVC()
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
    
    // MARK: - Public functions
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
    
    // MARK: - Private functions
    private func saveOnboardingSeen() {
        collectionViewCurrentIndex = 0
        UserDefaults.standard.set(true, forKey: UserDefaultKey.onboardingSeen.rawValue)
    }
    
    private func updatePageNumber(with index: Int) {
        let lastPage = index == onboardingData.count - 1
        view?.setLastPageReached(lastPage)
    }
}
