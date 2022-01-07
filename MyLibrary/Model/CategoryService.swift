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
    var categories: [CategoryModel] = [] {
        didSet {
            categories = categories.sorted(by: {
                $0.name?.lowercased() ?? "" < $1.name?.lowercased() ?? ""
            })
        }
    }
    private var categoriesListener: ListenerRegistration?
    private lazy var usersCollectionRef = db.collection(CollectionDocumentKey.users.rawValue)
    private let db = Firestore.firestore()
    
    // MARK: - Initializer
    init() {
        self.userID = Auth.auth().currentUser?.uid ?? ""
    }
    
    // MARK: - Private functions
    private func checkIfDocumentExist(categoryName: String,
                                      completion: @escaping (String?) -> Void) {
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
    
    private func getCategory(for id: String,
                             bookOwnerID: String,
                             completion: @escaping (CategoryModel?) -> Void) {
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
                completion(document)
            }
        }
    }
}
// MARK: - Extension CategoryServicePootocol
extension CategoryService: CategoryServiceProtocol {
    
    // MARK: Add
    func addCategory(for categoryName: String,
                     color: String,
                     completion: @escaping (FirebaseError?) -> Void) {
        guard !categoryName.isEmpty else {
            completion(.noCategory)
            return
        }
       
        let docRef = usersCollectionRef
            .document(userID)
            .collection(CollectionDocumentKey.category.rawValue)
        
        checkIfDocumentExist(categoryName: categoryName) { [weak self] documentID in
            guard documentID == nil else {
                completion(.categoryExist)
                return
            }
            let id = UUID().uuidString
            let category = CategoryModel(uid: id, name: categoryName.lowercased(), color: color)
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
            let data = querySnapshot?.documents.compactMap { documents -> CategoryModel? in
                do {
                    return try documents.data(as: CategoryModel.self)
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
    
    func getCategoryList(for categoryIds: [String],
                         bookOwnerID: String,
                         completion: @escaping ([CategoryModel]) -> Void) {
        var categoryList: [CategoryModel] = []
        categoryIds.forEach {
            getCategory(for: $0, bookOwnerID: bookOwnerID) { category in
                guard let category = category else { return }
                categoryList.append(category)
                completion(categoryList)
            }
        }
    }
    
    // MARK: Update
    func updateCategoryName(for category: CategoryModel,
                            with name: String?,
                            color: String,
                            completion: @escaping (FirebaseError?) -> Void) {
        guard let name = name, !name.isEmpty else {
            completion(.noCategory)
            return
        }
        let docRef = usersCollectionRef
            .document(userID)
            .collection(CollectionDocumentKey.category.rawValue)
            .document(category.uid ?? "")
        
        docRef.updateData([DocumentKey.name.rawValue : name,
                           DocumentKey.color.rawValue: color]) { error in
            if let error = error {
                completion(.firebaseError(error))
                return
            }
            completion(nil)
        }
    }
    
    // MARK: Delete
    func deleteCategory(for category: CategoryModel,
                        completion: @escaping (FirebaseError?) -> Void) {
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
    
    func removeListener() {
        categoriesListener?.remove()
    }
}
