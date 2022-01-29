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
    var userID: String

    private var categoriesListener: ListenerRegistration?
    private lazy var usersCollectionRef = db.collection(CollectionDocumentKey.users.rawValue)
    private let db = Firestore.firestore()
    private var collectionRef: CollectionReference {
        return usersCollectionRef
            .document(userID)
            .collection(CollectionDocumentKey.category.rawValue)
    }
    
    // MARK: - Initializer
    init() {
        self.userID = Auth.auth().currentUser?.uid ?? ""
    }
    
    // MARK: - Private functions
    private func verifyDocumentExist(categoryName: String,
                                     completion: @escaping (String?) -> Void) {
        let docRef = collectionRef
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
    
    private func getCategory(for id: String,
                             bookOwnerID: String,
                             completion: @escaping (CategoryDTO?) -> Void) {
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
            if let document = try? querySnapshot.data(as: CategoryDTO.self) {
                completion(document)
            }
        }
    }
}
// MARK: - CategoryService Protocol
extension CategoryService: CategoryServiceProtocol {

    func addCategory(for categoryName: String,
                     color: String,
                     completion: @escaping (FirebaseError?) -> Void) {
        guard !categoryName.isEmpty else {
            completion(.noText)
            return
        }

        verifyDocumentExist(categoryName: categoryName) { [weak self] documentID in
            guard documentID == nil else {
                completion(.categoryExist)
                return
            }
            let id = UUID().uuidString
            let category = CategoryDTO(uid: id, name: categoryName.lowercased(), color: color)
            do {
                try self?.collectionRef.document(id).setData(from: category)
            } catch { completion(.firebaseError(error)) }
            completion(nil)
        }
    }

    func getUserCategories(completion: @escaping (Result<[CategoryDTO], FirebaseError>) -> Void) {

        categoriesListener =  collectionRef.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                completion(.failure(.firebaseError(error)))
                return
            }
            let data = querySnapshot?.documents.compactMap { documents -> CategoryDTO? in
                do {
                    return try documents.data(as: CategoryDTO.self)
                } catch {
                    completion(.failure(.firebaseError(error)))
                    return nil
                }
            }
            if let data = data {
                let sortedData = data.sorted(by: {
                    $0.name.lowercased() < $1.name.lowercased()
                })
                completion(.success(sortedData))
            }
        }
    }
    
    func getBookCategories(for categoryIds: [String],
                           bookOwnerID: String,
                           completion: @escaping ([CategoryDTO]) -> Void) {
        var categoryList: [CategoryDTO] = []
        
        categoryIds.forEach {
            getCategory(for: $0, bookOwnerID: bookOwnerID) { category in
                guard let category = category else { return }
                categoryList.append(category)
                completion(categoryList)
            }
        }
    }

    func updateCategoryName(for category: CategoryDTO,
                            with name: String?,
                            color: String,
                            completion: @escaping (FirebaseError?) -> Void) {
        guard let name = name, !name.isEmpty else {
            completion(.noText)
            return
        }

        collectionRef.document(category.uid).updateData([DocumentKey.name.rawValue : name,
                                                         DocumentKey.color.rawValue: color]) { error in
            if let error = error {
                completion(.firebaseError(error))
                return
            }
            completion(nil)
        }
    }

    func deleteCategory(for category: CategoryDTO,
                        completion: @escaping (FirebaseError?) -> Void) {
        guard !category.uid.isEmpty else {
            completion(.noCategory)
            return
        }

        collectionRef.document(category.uid).delete { error in
            if let error = error {
                completion(.firebaseError(error))
                return
            }
            completion(nil)
        }
    }
    
    func removeListener() {
        categoriesListener?.remove()
    }
}
