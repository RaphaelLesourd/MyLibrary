//
//  CategoryService.swift
//  MyLibrary
//
//  Created by Birkyboy on 17/11/2021.
//

import Foundation
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore

class CategoryService {
    
    // MARK: - Properties
    
    static let shared = CategoryService()
    
    private let db = Firestore.firestore()
    private var categoriesListener: ListenerRegistration?
    
    let usersCollectionRef: CollectionReference
    var userID    : String
    var categories: [Category] = [] {
        didSet {
            categories = categories.sorted(by: { $0.name?.lowercased() ?? "" < $1.name?.lowercased() ?? "" })
        }
    }
    
    // MARK: - Initializer
    init() {
        usersCollectionRef = db.collection(CollectionDocumentKey.users.rawValue)
        self.userID        = Auth.auth().currentUser?.uid ?? ""
    }
    
    // MARK: Add
    func addCategory(for categoryName: String, completion: @escaping (FirebaseError?) -> Void) {
        guard Networkconnectivity.isConnectedToNetwork() == true else {
            completion(.noNetwork)
            return
        }
        guard !categoryName.isEmpty else {
            completion(.noCategory)
            return
        }
        let docRef = usersCollectionRef.document(userID).collection(CollectionDocumentKey.category.rawValue)
        
        checkIfDocumentExist(categoryName: categoryName) { [weak self] documentID in
            guard documentID == nil else {
                completion(.categoryExist)
                return
            }
            let id = UUID().uuidString
            let category = Category(uid: id, name: categoryName.lowercased())
            do {
                try docRef.document(id).setData(from: category)
                self?.categories.append(category)
            } catch { completion(.firebaseError(error)) }
            completion(nil)
        }
    }
    // MARK: Get
    func getCategories(completion: @escaping (FirebaseError?) -> Void) {
        let docRef = usersCollectionRef
            .document(userID)
            .collection(CollectionDocumentKey.category.rawValue)
        
        categoriesListener = docRef.addSnapshotListener { [weak self] (querySnapshot, error) in
            if let error = error {
                completion(.firebaseError(error))
                return
            }
            let data = querySnapshot?.documents.compactMap { documents -> Category? in
                do {
                    return try documents.data(as: Category.self)
                } catch {
                    completion(.firebaseError(error))
                    return nil
                }
            }
            if let data = data {
                self?.categories = data
            }
            completion(nil)
        }
    }
    
    func getCategoryNameList(for categoryIds: [String], completion: @escaping ([String]) -> Void) {
        var categoryList: [String] = []
        categoryIds.forEach {
            getCategoryName(for: $0) { categoryName in
                guard let categoryName = categoryName else { return }
                categoryList.append(categoryName)
                completion(categoryList)
            }
        }
    }
    
    // MARK: Update
    func updateCategoryName(for category: Category, with name: String?, completion: @escaping (FirebaseError?) -> Void) {
        guard Networkconnectivity.isConnectedToNetwork() == true else {
            completion(.noNetwork)
            return
        }
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
    func deleteCategory(for categoryName: String, completion: @escaping (FirebaseError?) -> Void) {
        guard Networkconnectivity.isConnectedToNetwork() == true else {
            completion(.noNetwork)
            return
        }
        guard !categoryName.isEmpty else {
            completion(.noCategory)
            return
        }
        
        checkIfDocumentExist(categoryName: categoryName) { [weak self] documentID in
            guard let self = self else { return }
            guard let documentID = documentID else {
                completion(.noCategory)
                return
            }
            let docRef = self.usersCollectionRef
                .document(self.userID)
                .collection(CollectionDocumentKey.category.rawValue)
                .document(documentID)
            docRef.delete { error in
                if let error = error {
                    completion(.firebaseError(error))
                    return
                }
                completion(nil)
            }
        }
    }
    
    // MARK: Verify
    func checkIfDocumentExist(categoryName: String, completion: @escaping (String?) -> Void) {
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
    private func getCategoryName(for id: String, completion: @escaping (String?) -> Void) {
        let docRef = usersCollectionRef
            .document(userID)
            .collection(CollectionDocumentKey.category.rawValue)
            .document(id)
        
        docRef.getDocument { querySnapshot, error in
            if error != nil {
                return
            }
            guard let querySnapshot = querySnapshot else {
                return
            }
            if let document = try? querySnapshot.data(as: Category.self) {
                completion(document.name)
            }
        }
    }
}
