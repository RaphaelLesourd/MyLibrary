//
//  HomePresenterTestCase.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 20/01/2022.
//

import XCTest
@testable import MyLibrary

class HomePresenterTestCase: XCTestCase {

    var sut: HomePresenter!
    
    override func setUp() {
        sut = HomePresenter(libraryService: LibraryServiceMock(),
                            categoryService: CategoryServiceMock(categories: []),
                            recommendationService: RecommendationServiceMock())
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func test_RetreiveLatestBooks() {
        sut.getLatestBooks()
        XCTAssertEqual(sut.latestBooks.count, 0)
    }

}



class CategoryServiceMock: CategoryServiceProtocol {
    var categories: [CategoryModel]
    
    init(categories: [CategoryModel]) {
        self.categories = categories
    }
    
    func addCategory(for categoryName: String, color: String, completion: @escaping (FirebaseError?) -> Void) {
        
    }
    
    func getCategories(completion: @escaping (FirebaseError?) -> Void) {
        
    }
    
    func getBookCategories(for categoryIds: [String], bookOwnerID: String, completion: @escaping ([CategoryModel]) -> Void) {
        
    }
    
    func updateCategoryName(for category: CategoryModel, with name: String?, color: String, completion: @escaping (FirebaseError?) -> Void) {
        
    }
    
    func deleteCategory(for category: CategoryModel, completion: @escaping (FirebaseError?) -> Void) {
        
    }
    
    func removeListener() {}
    
    
}

class LibraryServiceMock: LibraryServiceProtocol {
    func createBook(with book: Item, and imageData: Data, completion: @escaping (FirebaseError?) -> Void) {}
    
    func getBook(for bookID: String, ownerID: String, completion: @escaping (Result<Item, FirebaseError>) -> Void) {
    }
    
    func getBookList(for query: BookQuery, limit: Int, forMore: Bool, completion: @escaping (Result<[Item], FirebaseError>) -> Void) {
        completion(.success([]))
    }
    
    func deleteBook(book: Item, completion: @escaping (FirebaseError?) -> Void) {}
    
    func setStatus(to state: Bool, field: DocumentKey, for id: String?, completion: @escaping (FirebaseError?) -> Void) {}
    
    func removeBookListener() {}
    
    
}

class RecommendationServiceMock: RecommendationServiceProtocol {
    
    func addToRecommandation(for book: Item, completion: @escaping (FirebaseError?) -> Void) {
        
    }
    
    func removeFromRecommandation(for book: Item, completion: @escaping (FirebaseError?) -> Void) {
        
    }
    
    func retrieveRecommendingUsers(completion: @escaping (Result<[UserModel], FirebaseError>) -> Void) {
        
    }
    
    
}
