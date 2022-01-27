//
//  SetupAccountPresenterTestCase.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 24/01/2022.
//

import XCTest
@testable import MyLibrary

class SetupAccountPresenterTestCase: XCTestCase {
    
    private var sut: SetupAccountPresenting!
    private var setupAccountPresenterViewSpy: SetupAccountPresenterViewSpy!
    private let successTestPresenter = SetupAccountPresenter(accountService: AccountServiceMock(successTest: true),
                                                             validation: Validator())
    private let failedTestPresenter = SetupAccountPresenter(accountService: AccountServiceMock(successTest: false),
                                                            validation: Validator())
    
    override func setUp() {
        setupAccountPresenterViewSpy = SetupAccountPresenterViewSpy()
    }
    
    override func tearDown() {
        sut = nil
        setupAccountPresenterViewSpy = nil
    }

    // MARK: - Success
    func test_showInterface_whenLoginToAccount() {
        sut = successTestPresenter
        sut.view = setupAccountPresenterViewSpy
        sut.handlesAccountCredentials(for: .login)
        XCTAssertTrue(setupAccountPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(setupAccountPresenterViewSpy.stopActivityWasCalled)
        XCTAssertTrue(setupAccountPresenterViewSpy.dismissControllerWasCalled)
    }
    
    func test_showInterface_whenCreatingAccount() {
        sut = successTestPresenter
        sut.view = setupAccountPresenterViewSpy
        sut.handlesAccountCredentials(for: .signup)
        XCTAssertTrue(setupAccountPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(setupAccountPresenterViewSpy.stopActivityWasCalled)
        XCTAssertTrue(setupAccountPresenterViewSpy.dismissControllerWasCalled)
    }
  
    func test_showInterface_whenDeletingAccount() {
        sut = successTestPresenter
        sut.view = setupAccountPresenterViewSpy
        sut.handlesAccountCredentials(for: .deleteAccount)
        XCTAssertTrue(setupAccountPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(setupAccountPresenterViewSpy.stopActivityWasCalled)
        XCTAssertTrue(setupAccountPresenterViewSpy.dismissControllerWasCalled)
    }
    
    func test_resetPassword() {
        sut = successTestPresenter
        sut.view = setupAccountPresenterViewSpy
        sut.resetPassword(with: "testEmail")
        XCTAssertTrue(setupAccountPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(setupAccountPresenterViewSpy.stopActivityWasCalled)
        XCTAssertTrue(setupAccountPresenterViewSpy.dismissControllerWasCalled)
    }
    
    func test_validateEmail() {
        sut = successTestPresenter
        sut.view = setupAccountPresenterViewSpy
        sut.validateEmail(for: "test@test.com")
        XCTAssertTrue(setupAccountPresenterViewSpy.updateEmailTextFieldWasCalled)
    }
    
    func test_validatePassword() {
        sut = successTestPresenter
        sut.view = setupAccountPresenterViewSpy
        sut.validatePassword(for: "")
        XCTAssertTrue(setupAccountPresenterViewSpy.updatePasswordTextFieldWasCalled)
    }
    
    func test_validatePasswordConfirmation() {
        sut = successTestPresenter
        sut.view = setupAccountPresenterViewSpy
        sut.validatePasswordConfirmation(for: "")
        XCTAssertTrue(setupAccountPresenterViewSpy.updatePasswordConfirmationTextFieldWasCalled)
    }
    
    // MARK: - Fail
    func test_showInterface_whenLoginToAccount_withError() {
        sut = failedTestPresenter
        sut.view = setupAccountPresenterViewSpy
        sut.handlesAccountCredentials(for: .login)
        XCTAssertTrue(setupAccountPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(setupAccountPresenterViewSpy.stopActivityWasCalled)
        XCTAssertFalse(setupAccountPresenterViewSpy.dismissControllerWasCalled)
    }
    
    func test_showInterface_whenCreatingAccount_withError() {
        sut = failedTestPresenter
        sut.view = setupAccountPresenterViewSpy
        sut.handlesAccountCredentials(for: .signup)
        XCTAssertTrue(setupAccountPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(setupAccountPresenterViewSpy.stopActivityWasCalled)
        XCTAssertFalse(setupAccountPresenterViewSpy.dismissControllerWasCalled)
    }
  
    func test_showInterface_whenDeletingAccount_withError() {
        sut = failedTestPresenter
        sut.view = setupAccountPresenterViewSpy
        sut.handlesAccountCredentials(for: .deleteAccount)
        XCTAssertTrue(setupAccountPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(setupAccountPresenterViewSpy.stopActivityWasCalled)
        XCTAssertFalse(setupAccountPresenterViewSpy.dismissControllerWasCalled)
    }
    
    func test_resetPassword_withError() {
        sut = failedTestPresenter
        sut.view = setupAccountPresenterViewSpy
        sut.resetPassword(with: "testEmail")
        XCTAssertTrue(setupAccountPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(setupAccountPresenterViewSpy.stopActivityWasCalled)
        XCTAssertFalse(setupAccountPresenterViewSpy.dismissControllerWasCalled)
    }
    
    func test_resetPassword_NoEmailProvided() {
        sut = successTestPresenter
        sut.view = setupAccountPresenterViewSpy
        sut.resetPassword(with: nil)
        XCTAssertFalse(setupAccountPresenterViewSpy.showActivityWasCalled)
        XCTAssertFalse(setupAccountPresenterViewSpy.stopActivityWasCalled)
        XCTAssertFalse(setupAccountPresenterViewSpy.dismissControllerWasCalled)
    }
}

class SetupAccountPresenterViewSpy: SetupAccountPresenterView {
    
    var showActivityWasCalled = false
    var stopActivityWasCalled = false
    var dismissControllerWasCalled = false
    var updateEmailTextFieldWasCalled = false
    var updatePasswordTextFieldWasCalled = false
    var updatePasswordConfirmationTextFieldWasCalled = false
    
    func dismissViewController() {
        dismissControllerWasCalled = true
    }
    
    func updateEmailTextField(valid: Bool) {
        updateEmailTextFieldWasCalled = true
    }
    
    func updatePasswordTextField(valid: Bool) {
        updatePasswordTextFieldWasCalled = true
    }
    
    func updatePasswordConfirmationTextField(valid: Bool) {
        updatePasswordConfirmationTextFieldWasCalled = true
    }
    
    func showActivityIndicator() {
        showActivityWasCalled = true
    }
    
    func stopActivityIndicator() {
        stopActivityWasCalled = true
    }
}
