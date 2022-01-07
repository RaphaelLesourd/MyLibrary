//
//  CategoryServiceProtocol.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/12/2021.
//

protocol CategoryServiceProtocol {
    var categories: [CategoryModel] { get set }
    func addCategory(for categoryName: String,
                     color: String,
                     completion: @escaping (FirebaseError?) -> Void)
    func getCategories(completion: @escaping (FirebaseError?) -> Void)
    func getCategoryNameList(for categoryIds: [String],
                             bookOwnerID: String,
                             completion: @escaping ([String]) -> Void)
    func updateCategoryName(for category: CategoryModel,
                            with name: String?,
                            color: String,
                            completion: @escaping (FirebaseError?) -> Void)
    func deleteCategory(for category: CategoryModel,
                        completion: @escaping (FirebaseError?) -> Void)
    func removeListener()
}
