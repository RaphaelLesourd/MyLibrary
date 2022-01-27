//
//  AccountPresenterTestCase.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 20/01/2022.
//

import XCTest
@testable import MyLibrary

class AccountPresenterTestCase: XCTestCase {

    private var sut: AccountTabPresenting!
    private var accountPresenterViewSpy: AccountPresenterViewSpy!
    private let successTestPresenter = AccountTabPresenter(userService: UserServiceMock(successTest: true),
                                                           imageService: ImageServiceMock(successTest: true),
                                                           accountService: AccountServiceMock(successTest: true))
    private let failedTestPresenter = AccountTabPresenter(userService: UserServiceMock(successTest: false),
                                                          imageService: ImageServiceMock(successTest: false),
                                                          accountService: AccountServiceMock(successTest: false))
    
    override func setUp() {
        accountPresenterViewSpy = AccountPresenterViewSpy()
    }
    override func tearDown() {
        sut = nil
        accountPresenterViewSpy = nil
    }

    // MARK: - Success
    func test_whenGettingUserProfile_thenNoError() {
        sut = successTestPresenter
        sut.view = accountPresenterViewSpy
        sut.getProfileData()
        XCTAssertTrue(accountPresenterViewSpy.configureViewCalled)
        XCTAssertTrue(accountPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(accountPresenterViewSpy.stopActivityWasCalled)
    }
    
    func test_savingUserName_succesfull() {
        sut = successTestPresenter
        sut.view = accountPresenterViewSpy
        sut.saveUserName(with: "testName")
        XCTAssertTrue(accountPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(accountPresenterViewSpy.stopActivityWasCalled)
    }
    
    func test_savingProfileImage_succesfull() {
        sut = successTestPresenter
        sut.view = accountPresenterViewSpy
        sut.saveProfileImage(Data())
        XCTAssertTrue(accountPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(accountPresenterViewSpy.stopActivityWasCalled)
    }
    
    func test_signingOutOfAccount_successFull() {
        sut = successTestPresenter
        sut.view = accountPresenterViewSpy
        sut.signoutAccount()
        XCTAssertTrue(accountPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(accountPresenterViewSpy.stopActivityWasCalled)
        XCTAssertTrue(accountPresenterViewSpy.animatingSaveButtonIndicatorCalled)
    }
    
    // MARK: - Fail
    func test_whenGettingUserProfileWhenErrorOccur_thenNoUser() {
        sut = failedTestPresenter
        sut.view = accountPresenterViewSpy
        sut.getProfileData()
        XCTAssertFalse(accountPresenterViewSpy.configureViewCalled)
        XCTAssertTrue(accountPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(accountPresenterViewSpy.stopActivityWasCalled)
    }
    
    func test_savingUserName_failed() {
        sut = failedTestPresenter
        sut.view = accountPresenterViewSpy
        sut.saveUserName(with: "testName")
        XCTAssertTrue(accountPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(accountPresenterViewSpy.stopActivityWasCalled)
    }
    
    func test_savingProfileImage_failed() {
        sut = failedTestPresenter
        sut.view = accountPresenterViewSpy
        sut.saveProfileImage(Data())
        XCTAssertTrue(accountPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(accountPresenterViewSpy.stopActivityWasCalled)
    }
    
    func test_signingOutOfAccount_failed() {
        sut = failedTestPresenter
        sut.view = accountPresenterViewSpy
        sut.signoutAccount()
        XCTAssertTrue(accountPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(accountPresenterViewSpy.stopActivityWasCalled)
        XCTAssertTrue(accountPresenterViewSpy.animatingSaveButtonIndicatorCalled)
    }
}

class AccountPresenterViewSpy: AccountTabPresenterView {

    var configureViewCalled = false
    var animatingSaveButtonIndicatorCalled = false
    var showActivityWasCalled = false
    var stopActivityWasCalled = false
    
    func configureView(with user: UserModel) {
        configureViewCalled = true
    }
    
    func animateSavebuttonIndicator(_ animate: Bool) {
        animatingSaveButtonIndicatorCalled = true
    }

    func showActivityIndicator() {
        showActivityWasCalled = true
    }
    
    func stopActivityIndicator() {
        stopActivityWasCalled = true
    }
}
