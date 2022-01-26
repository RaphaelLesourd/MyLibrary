//
//  ViewControllerFactoryTestCase.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 24/01/2022.
//

import XCTest
@testable import MyLibrary

class ViewControllerFactoryTestCase: XCTestCase {

    private var sut: Factory!
    
    override func setUp() {
        sut = ViewControllerFactory()
    }

    override func tearDown() {
        sut = nil
    }
    
    // MARK: - Tests
    func test_makeHomeTabVC() {
        let controller = sut.makeHomeTabVC()
        XCTAssertTrue(controller is HomeViewController)
    }
    
    func test_makeAccountTabVC() {
        let controller = sut.makeAccountTabVC()
        XCTAssertTrue(controller is AccountViewController)
    }
    
    func test_makeCategoryVC() {
        let controller = sut.makeCategoryVC(settingCategory: true, bookCategories: [], newBookDelegate: nil)
        XCTAssertTrue(controller is CategoriesViewController)
    }
    
    func test_makeNewCategoryVC() {
        let controller = sut.makeNewCategoryVC(editing: true, category: nil)
        XCTAssertTrue(controller is NewCategoryViewController)
    }
    
    func test_makeBookListVC() {
        let query = BookQuery(listType: .favorites, orderedBy: .category, fieldValue: nil, descending: true)
        let controller = sut.makeBookListVC(with: query)
        XCTAssertTrue(controller is BookLibraryViewController)
    }
    
    func test_makeAccountSetupVC() {
        let controller = sut.makeAccountSetupVC(for: .signup)
        XCTAssertTrue(controller is AccountSetupViewController)
    }
    
    func test_makeNewBookVC() {
        let controller = sut.makeNewBookVC(with: nil, isEditing: true, bookCardDelegate: nil)
        XCTAssertTrue(controller is NewBookViewController)
    }
    
    func test_makeBookCardVC() {
        let controller = sut.makeBookCardVC(book: PresenterFakeData.book, type: .keywordSearch, factory: ViewControllerFactory())
        XCTAssertTrue(controller is BookCardViewController)
    }
    
    func test_makeBookDescriptionVC() {
        let controller = sut.makeBookDescriptionVC(description: nil, newBookDelegate: nil)
        XCTAssertTrue(controller is BookDescriptionViewController)
    }
    
    func test_makeCommentVC() {
        let controller = sut.makeCommentVC(with: nil)
        XCTAssertTrue(controller is CommentsViewController)
    }
    
    func test_makeBookCoverDisplayVC() {
        let controller = sut.makeBookCoverDisplayVC(with: UIImage())
        XCTAssertTrue(controller is BookCoverViewController)
    }
    
    func test_makeListViewcontrollerVC() {
        let controller = sut.makeListVC(for: .currency, selectedData: nil, newBookDelegate: nil)
        XCTAssertTrue(controller is ListTableViewController)
    }
    
    func test_makeBarcodeScanVc() {
        let controller = sut.makeBarcodeScannerVC(delegate: nil)
        XCTAssertTrue(controller is BarcodeScanViewController)
    }
    
    func test_makeOnboardingVC() {
        let controller = sut.makeOnboardingVC()
        XCTAssertTrue(controller is OnboardingViewController)
    }
}
