//
//  CategoryService.swift
//  MyLibrary
//
//  Created by Birkyboy on 17/11/2021.
//

import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore

class CategoryService {
    
    // MARK: - Properties
    static let shared = CategoryService()
    
    private let db = Firestore.firestore()
    private var categoriesListener: ListenerRegistration?
    lazy var usersCollectionRef = db.collection(CollectionDocumentKey.users.rawValue)
    var categories: [CategoryModel] = []
    
    // MARK: Add
    func addCategory(for categoryName: String, completion: @escaping (FirebaseError?) -> Void) {
        guard !categoryName.isEmpty else {
            completion(.noCategory)
            return
        }
        let userID = Auth.auth().currentUser?.uid ?? ""
        let docRef = usersCollectionRef
            .document(userID)
            .collection(CollectionDocumentKey.category.rawValue)
        
        checkIfDocumentExist(categoryName: categoryName) { [weak self] documentID in
            guard documentID == nil else {
                completion(.categoryExist)
                return
            }
            let id = UUID().uuidString
            let category = CategoryModel(uid: id, name: categoryName.lowercased())
            do {
                try docRef.document(id).setData(from: category)
                self?.categories.append(category)
            } catch { completion(.firebaseError(error)) }
            completion(nil)
        }
    }
    // MARK: Get
    func getCategories(completion: @escaping (FirebaseError?) -> Void) {
        let userID = Auth.auth().currentUser?.uid ?? ""
        let docRef = usersCollectionRef
            .document(userID)
            .collection(CollectionDocumentKey.category.rawValue)
        
        categoriesListener = docRef.addSnapshotListener { [weak self] (querySnapshot, error) in
            if let error = error {
                completion(.firebaseError(error))
                return
            }
            let data = querySnapshot?.documents.compactMap { documents -> CategoryModel? in
                do {
                    return try documents.data(as: CategoryModel.self)
                } catch {
                    completion(.firebaseError(error))
                    return nil
                }
            }
            if let data = data {
                self?.categories = data.sorted(by: {
                    $0.name?.lowercased() ?? "" < $1.name?.lowercased() ?? ""
                })
            }
            completion(nil)
        }
    }
    
    func getCategoryNameList(for categoryIds: [String], bookOwnerID: String, completion: @escaping ([String]) -> Void) {
        var categoryList: [String] = []
        categoryIds.forEach {
            getCategoryName(for: $0, bookOwnerID: bookOwnerID) { categoryName in
                guard let categoryName = categoryName else { return }
                categoryList.append(categoryName)
                completion(categoryList)
            }
        }
    }
    
    // MARK: Update
    func updateCategoryName(for category: CategoryModel, with name: String?, completion: @escaping (FirebaseError?) -> Void) {
        let userID = Auth.auth().currentUser?.uid ?? ""
        guard let name = name, !name.isEmpty else {
            completion(.noCategory)
            return
        }
        let docRef = usersCollectionRef
            .document(userID)
            .collection(CollectionDocumentKey.category.rawValue)
            .document(category.uid ?? "")
        
        docRef.updateData([DocumentKey.name.rawValue : name]) { error in
            if let error = error {
                completion(.firebaseError(error))
                return
            }
            completion(nil)
        }
    }
    
    // MARK: Delete
    func deleteCategory(for category: CategoryModel, completion: @escaping (FirebaseError?) -> Void) {
        let userID = Auth.auth().currentUser?.uid ?? ""
        guard let categoryID = category.uid else {
            completion(.noCategory)
            return
        }
        let docRef = self.usersCollectionRef
            .document(userID)
            .collection(CollectionDocumentKey.category.rawValue)
            .document(categoryID)
        
        docRef.delete { error in
            if let error = error {
                completion(.firebaseError(error))
                return
            }
            completion(nil)
        }
    }
    
    // MARK: Verify
    func checkIfDocumentExist(categoryName: String, completion: @escaping (String?) -> Void) {
        let userID = Auth.auth().currentUser?.uid ?? ""
        let docRef = usersCollectionRef
            .document(userID)
            .collection(CollectionDocumentKey.category.rawValue)
            .whereField(DocumentKey.name.rawValue, isEqualTo: categoryName.lowercased())
            .limit(to: 1)
        
        docRef.getDocuments { (snapshot, error) in
            if error != nil {
                completion(nil)
                return
            }
            if let foundDoc = snapshot?.documents.first {
                completion(foundDoc.documentID)
                return
            }
            completion(nil)
        }
    }
    // MARK: - Private functions
    private func getCategoryName(for id: String, bookOwnerID: String, completion: @escaping (String?) -> Void) {
        let docRef = usersCollectionRef
            .document(bookOwnerID)
            .collection(CollectionDocumentKey.category.rawValue)
            .document(id)
        
        docRef.getDocument { querySnapshot, error in
            if error != nil {
                return
            }
            guard let querySnapshot = querySnapshot else {
                return
            }
            if let document = try? querySnapshot.data(as: CategoryModel.self) {
                completion(document.name)
            }
        }
    }
}
