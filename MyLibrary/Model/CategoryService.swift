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
    
    static let shared = CategoryService()
   
    private let db = Firestore.firestore()
    
    let usersCollectionRef: CollectionReference
    var userID    = Auth.auth().currentUser?.uid
    var categories: [Category] = [] {
        didSet {
            categories = categories.sorted(by: { $0.name ?? "" < $1.name ?? "" })
        }
    }
    
    // MARK: - Initializer
    init() {
        usersCollectionRef = db.collection(CollectionDocumentKey.users.rawValue)
    }

    func checkIfDocumentExist(categoryName: String, completion: @escaping (String?) -> Void) {
        guard let userID = userID else { return }
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
    
    func addCategory(for categoryName: String, completion: @escaping (FirebaseError?) -> Void) {
        guard let userID = userID else { return }
        guard !categoryName.isEmpty else {
            completion(.noCategory)
            return
        }
        let id = UUID().uuidString
        let docRef = usersCollectionRef.document(userID).collection(CollectionDocumentKey.category.rawValue)
        let category = Category(id: id, name: categoryName.lowercased())
        
        checkIfDocumentExist(categoryName: categoryName) { [weak self] documentID in
            guard documentID == nil else {
                completion(.documentAlreadyExist(categoryName))
                return
            }
            do {
                try docRef.document(id).setData(from: category)
                self?.categories.append(category)
                completion(nil)
            } catch { completion(.firebaseError(error)) }
            
        }
    }
    
    func deleteCategory(for categoryName: String, completion: @escaping (FirebaseError?) -> Void) {
        guard let userID = userID else { return }
        guard !categoryName.isEmpty else {
            completion(.noCategory)
            return
        }
       
        checkIfDocumentExist(categoryName: categoryName) { [weak self] documentID in
            guard let documentID = documentID else {
                completion(.noCategory)
                return
            }
            let docRef = self?.usersCollectionRef
                .document(userID)
                .collection(CollectionDocumentKey.category.rawValue)
                .document(documentID)
            docRef?.delete { error in
                if let error = error {
                    completion(.firebaseError(error))
                    return
                }
                completion(nil)
            }
        }
    }
    
    func getCategories(completion: @escaping (FirebaseError?) -> Void) {
        guard let userID = userID else { return }
        
        let docRef = usersCollectionRef
            .document(userID)
            .collection(CollectionDocumentKey.category.rawValue)
        
        docRef.getDocuments { [weak self] (querySnapshot, error) in
            if let error = error {
                completion(.firebaseError(error))
                return
            }
            guard let documents = querySnapshot?.documents else {
                completion(.nothingFound)
                return
            }
            self?.categories = documents.compactMap { documents -> Category? in
                do {
                    return try documents.data(as: Category.self)
                } catch {
                    completion(.firebaseError(error))
                    return nil
                }
            }
            completion(nil)
        }
    }
}
