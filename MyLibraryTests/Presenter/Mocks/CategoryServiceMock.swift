//
//  CategoryServiceMock.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 20/01/2022.
//
import XCTest
@testable import MyLibrary

class CategoryServiceMock: CategoryServiceProtocol {
    
    private var successTest: Bool
    
    init(_ successTest: Bool) {
        self.successTest = successTest
    }
    
    func getUserCategories(completion: @escaping (Result<[CategoryDTO], FirebaseError>) -> Void) {
        successTest ? completion(.success(FakeData.categories)) : completion(.failure(.firebaseError(FakeData.PresenterError.fail)))
    }
   
    func addCategory(for categoryName: String, color: String, completion: @escaping (FirebaseError?) -> Void) {
        successTest ? completion(nil) : completion(.firebaseError(FakeData.PresenterError.fail))
    }
   
    
    func getBookCategories(for categoryIds: [String], bookOwnerID: String,
                           completion: @escaping ([CategoryDTO]) -> Void) {
        if successTest {
            completion(FakeData.categories)
        } else {
            completion([])
        }
    }
    
    func updateCategoryName(for category: CategoryDTO, with name: String?, color: String,
                            completion: @escaping (FirebaseError?) -> Void) {
        
        successTest ? completion(nil) : completion(.firebaseError(FakeData.PresenterError.fail))
    }
    
    func deleteCategory(for category: CategoryDTO, completion: @escaping (FirebaseError?) -> Void) {
        successTest ? completion(nil) : completion(.firebaseError(FakeData.PresenterError.fail))
    }
    
    func removeListener() {}
}
