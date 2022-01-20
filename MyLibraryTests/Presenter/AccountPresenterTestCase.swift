//
//  AccountPresenterTestCase.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 20/01/2022.
//

import XCTest
@testable import MyLibrary

class AccountPresenterTestCase: XCTestCase {

    private var sut: AccountTabPresenter!
    private var accountPresenterViewSpy: AccountPresenterViewSpy!
    
    override func setUp() {
        accountPresenterViewSpy = AccountPresenterViewSpy()
    }
    override func tearDown() {
        sut = nil
        accountPresenterViewSpy = nil
    }

    // MARK: - Success
    func test_whenGettingUserProfile_thenNoError() {
        sut = AccountTabPresenter(userService: UserServiceMock(successTest: true),
                                  imageService: ImageServiceMock(successTest: true),
                                  accountService: AccountServiceMock(successTest: true))
        sut.view = accountPresenterViewSpy
        sut.getProfileData()
        XCTAssertTrue(accountPresenterViewSpy.configureViewCalled)
        XCTAssertTrue(accountPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(accountPresenterViewSpy.stopActivityWasCalled)
    }
    
    func test_savingUserName_succesfull() {
        sut = AccountTabPresenter(userService: UserServiceMock(successTest: true),
                                  imageService: ImageServiceMock(successTest: true),
                                  accountService: AccountServiceMock(successTest: true))
        sut.view = accountPresenterViewSpy
        sut.saveUserName(with: "testName")
        XCTAssertTrue(accountPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(accountPresenterViewSpy.stopActivityWasCalled)
    }
    
    func test_savingProfileImage_succesfull() {
        sut = AccountTabPresenter(userService: UserServiceMock(successTest: true),
                                  imageService: ImageServiceMock(successTest: true),
                                  accountService: AccountServiceMock(successTest: true))
        sut.view = accountPresenterViewSpy
        sut.saveProfileImage(Data())
        XCTAssertTrue(accountPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(accountPresenterViewSpy.stopActivityWasCalled)
    }
    
    func test_signingOutOfAccount_successFull() {
        sut = AccountTabPresenter(userService: UserServiceMock(successTest: true),
                                  imageService: ImageServiceMock(successTest: true),
                                  accountService: AccountServiceMock(successTest: true))
        sut.view = accountPresenterViewSpy
        sut.signoutAccount()
        XCTAssertTrue(accountPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(accountPresenterViewSpy.stopActivityWasCalled)
        XCTAssertTrue(accountPresenterViewSpy.animatingSaveButtonIndicatorCalled)
    }
    
    // MARK: - Fail
    func test_whenGettingUserProfileWhenErrorOccur_thenNoUser() {
        sut = AccountTabPresenter(userService: UserServiceMock(successTest: false),
                                  imageService: ImageServiceMock(successTest: false),
                                  accountService: AccountServiceMock(successTest: false))
        sut.view = accountPresenterViewSpy
        sut.getProfileData()
        XCTAssertFalse(accountPresenterViewSpy.configureViewCalled)
        XCTAssertTrue(accountPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(accountPresenterViewSpy.stopActivityWasCalled)
    }
    
    func test_savingUserName_failed() {
        sut = AccountTabPresenter(userService: UserServiceMock(successTest: false),
                                  imageService: ImageServiceMock(successTest: false),
                                  accountService: AccountServiceMock(successTest: false))
        sut.view = accountPresenterViewSpy
        sut.saveUserName(with: "testName")
        XCTAssertTrue(accountPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(accountPresenterViewSpy.stopActivityWasCalled)
    }
    
    func test_savingProfileImage_failed() {
        sut = AccountTabPresenter(userService: UserServiceMock(successTest: false),
                                  imageService: ImageServiceMock(successTest: false),
                                  accountService: AccountServiceMock(successTest: false))
        sut.view = accountPresenterViewSpy
        sut.saveProfileImage(Data())
        XCTAssertTrue(accountPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(accountPresenterViewSpy.stopActivityWasCalled)
    }
    
    func test_signingOutOfAccount_failed() {
        sut = AccountTabPresenter(userService: UserServiceMock(successTest: false),
                                  imageService: ImageServiceMock(successTest: false),
                                  accountService: AccountServiceMock(successTest: false))
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
