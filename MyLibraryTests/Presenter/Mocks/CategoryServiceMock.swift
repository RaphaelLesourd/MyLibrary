//
//  CategoryServiceMock.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 20/01/2022.
//
import XCTest
@testable import MyLibrary

class CategoryServiceMock: CategoryServiceProtocol {
    let categories: [CategoryModel] = [CategoryModel(id: "",
                                                     uid: "",
                                                     name: "Test",
                                                     color: "TestColor")]
    func getCategories(completion: @escaping (Result<[CategoryModel], FirebaseError>) -> Void) {
        completion(.success(categories))
    }
   
    func addCategory(for categoryName: String, color: String, completion: @escaping (FirebaseError?) -> Void) {}
   
    
    func getBookCategories(for categoryIds: [String], bookOwnerID: String,
                           completion: @escaping ([CategoryModel]) -> Void) {}
    
    func updateCategoryName(for category: CategoryModel, with name: String?, color: String,
                            completion: @escaping (FirebaseError?) -> Void) {}
    
    func deleteCategory(for category: CategoryModel, completion: @escaping (FirebaseError?) -> Void) {}
    
    func removeListener() {}
}
