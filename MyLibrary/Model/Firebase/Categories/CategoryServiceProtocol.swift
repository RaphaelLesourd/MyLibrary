//
//  CategoryServiceProtocol.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/12/2021.
//

protocol CategoryServiceProtocol {
    func addCategory(for categoryName: String,
                     color: String,
                     completion: @escaping (FirebaseError?) -> Void)
    
    func getCategories(completion: @escaping (Result<[CategoryModel], FirebaseError>) -> Void)
    
    func getBookCategories(for categoryIds: [String],
                           bookOwnerID: String,
                           completion: @escaping ([CategoryModel]) -> Void)
    
    func updateCategoryName(for category: CategoryModel,
                            with name: String?,
                            color: String,
                            completion: @escaping (FirebaseError?) -> Void)
    
    func deleteCategory(for category: CategoryModel, completion: @escaping (FirebaseError?) -> Void)
    
    func removeListener()
}
