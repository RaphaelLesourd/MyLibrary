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
    
    func getUserCategories(completion: @escaping (Result<[CategoryDTO], FirebaseError>) -> Void)
    
    func getBookCategories(for categoryIds: [String],
                           bookOwnerID: String,
                           completion: @escaping ([CategoryDTO]) -> Void)
    
    func updateCategoryName(for category: CategoryDTO,
                            with name: String?,
                            color: String,
                            completion: @escaping (FirebaseError?) -> Void)
    
    func deleteCategory(for category: CategoryDTO, completion: @escaping (FirebaseError?) -> Void)
    
    func removeListener()
}
