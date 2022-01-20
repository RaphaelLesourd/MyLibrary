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
    
    func getCategories(completion: @escaping (Result<[CategoryModel], FirebaseError>) -> Void) {
        successTest ? completion(.success(PresenterFakeData.categories)) : completion(.failure(.firebaseError(PresenterError.fail)))
    }
   
    func addCategory(for categoryName: String, color: String, completion: @escaping (FirebaseError?) -> Void) {
        successTest ? completion(nil) : completion(.firebaseError(PresenterError.fail))
    }
   
    
    func getBookCategories(for categoryIds: [String], bookOwnerID: String,
                           completion: @escaping ([CategoryModel]) -> Void) {
        successTest ? completion([]) : completion(PresenterFakeData.categories)
    }
    
    func updateCategoryName(for category: CategoryModel, with name: String?, color: String,
                            completion: @escaping (FirebaseError?) -> Void) {
        successTest ? completion(nil) : completion(.firebaseError(PresenterError.fail))
    }
    
    func deleteCategory(for category: CategoryModel, completion: @escaping (FirebaseError?) -> Void) {
        successTest ? completion(nil) : completion(.firebaseError(PresenterError.fail))
    }
    
    func removeListener() {}
}
