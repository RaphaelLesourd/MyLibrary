//
//  OnboardingPresenterTestCase.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 25/01/2022.
//

import XCTest
@testable import MyLibrary

class OnboardingPresenterTestCase: XCTestCase {

    private var sut: OnboardingPresenting!
    private var onboardingViewSpy: OnboardingPresenterViewSpy!
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        onboardingViewSpy = OnboardingPresenterViewSpy()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        onboardingViewSpy = nil
    }
    
    // MARK: - Success
    func test_collectionViewPageChange() {
        sut =  OnboardingPresenter()
        sut.view = onboardingViewSpy
        sut.collectionViewCurrentIndex = sut.onboardingData.count - 1
        XCTAssertTrue(onboardingViewSpy.setLastPageReachedWasCalled)
    }
    
    func test_nextButtonTapped_lastPageNumberReached() {
        sut =  OnboardingPresenter()
        sut.view = onboardingViewSpy
        sut.collectionViewCurrentIndex = sut.onboardingData.count - 1
        sut.nextButtonTapped()
        XCTAssertTrue(onboardingViewSpy.presentWelcomeControllerWasCalled)
    }
    
    func test_nextButtonTapped_lastPageNumberNotReached() {
        sut =  OnboardingPresenter()
        sut.view = onboardingViewSpy
        sut.collectionViewCurrentIndex = 1
        sut.nextButtonTapped()
        XCTAssertTrue(onboardingViewSpy.scrollCollectionViewWasCalled)
    }
}

class OnboardingPresenterViewSpy: OnboardingPresenterView {
    
    var setLastPageReachedWasCalled = false
    var scrollCollectionViewWasCalled = false
    var presentWelcomeControllerWasCalled = false
    
    func setLastPageReached(when lastPage: Bool) {
         setLastPageReachedWasCalled = true
    }
    
    func scrollCollectionView(to indexPath: IndexPath) {
         scrollCollectionViewWasCalled = true
    }
    
    func presentWelcomeVC() {
         presentWelcomeControllerWasCalled = true
    }
}
