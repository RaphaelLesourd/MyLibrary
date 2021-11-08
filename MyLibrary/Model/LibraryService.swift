//
//  LibraryService.swift
//  MyLibrary
//
//  Created by Birkyboy on 05/11/2021.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol LibraryServiceProtocol {
    func createBook(with book: Item?, completion: @escaping (FirebaseError?) -> Void)
    func retrieveBook(for id: String, completion: @escaping (Result<Item, FirebaseError>) -> Void)
    func deleteBook(book: Item, completion: @escaping (FirebaseError?) -> Void)
    func getSnippets(limitNumber: Int, favoriteBooks: Bool, completion: @escaping (Result<[BookSnippet], FirebaseError>) -> Void)
    func addToFavorite(_ status: Bool, for id: String, completion: @escaping (FirebaseError?) -> Void)
}

class LibraryService {
    
    // MARK: - Properties
    typealias CompletionHandler = (FirebaseError?) -> Void
    let db = Firestore.firestore()
    let usersCollectionRef: CollectionReference
    let user = Auth.auth().currentUser
    
    // MARK: - Initializer
    init() {
        usersCollectionRef = db.collection(CollectionDocumentKey.users.rawValue)
    }
    
    // MARK: - Private functions
    private func saveDocument<T: Codable>(for document: T,
                                          with id: String,
                                          collection: CollectionDocumentKey,
                                          completion: @escaping (FirebaseError?) -> Void) {
        guard let user = user else { return }
        let bookRef = usersCollectionRef
            .document(user.uid)
            .collection(collection.rawValue)
            .document(id)
        do {
            try bookRef.setData(from: document)
            bookRef.setData([BookDocumentKey.etag.rawValue: id], merge: true)
            completion(nil)
        } catch {
            completion(.firebaseError(error))
        }
    }
    
    private func deleteDocument(with id: String,
                                collection: CollectionDocumentKey,
                                completion: @escaping CompletionHandler) {
        guard let user = user else { return }
        usersCollectionRef.document(user.uid).collection(collection.rawValue).document(id).delete { error in
            if let error = error {
                completion(.firebaseError(error))
                return
            }
            completion(nil)
        }
    }
    
    private func createQuery(with limitNumber: Int, order: BookDocumentKey, descending: Bool, favoriteBook: Bool) -> Query? {
        guard let user = user else { return nil }
        var docRef = usersCollectionRef
            .document(user.uid)
            .collection(CollectionDocumentKey.bookSnippets.rawValue)
            .order(by: order.rawValue, descending: descending)
        
        if limitNumber > 0 {
            docRef = docRef.limit(to: limitNumber)
        }
        
        if favoriteBook == true {
            docRef = docRef.whereField(BookDocumentKey.favorite.rawValue, isEqualTo: true)
        }
        return docRef
    }
}
// MARK: - LibraryServiceProtocol Extension
extension LibraryService: LibraryServiceProtocol {
    
    // MARK: Create/Update
    func createBook(with book: Item?, completion: @escaping CompletionHandler) {
        guard let user = user, let book = book else { return }
        guard let etag = book.etag else { return }
        // Create a new uid for new documents and snippets
        var uid = String()
        // Look for document with etag as ID
        let docRef = usersCollectionRef
            .document(user.uid)
            .collection(CollectionDocumentKey.books.rawValue)
            .whereField(BookDocumentKey.etag.rawValue, isEqualTo: etag)
            .limit(to: 1)
        docRef.getDocuments { [weak self] (snapshot, error) in
            if let error = error {
                completion(.firebaseError(error))
                return
            }
            // Check if document etag already exists
            if let foundDoc = snapshot?.documents,
               !foundDoc.isEmpty,
               let document = foundDoc.first {
                // If document exist its, id is used to update its content
                uid = document.documentID
            } else {
                uid = UUID().uuidString
            }
            // If the document does not exits the default uid string is used to create a new document
            // document if save in the book category with all the fields
            self?.saveDocument(for: book, with: uid, collection: .books) { error in
                if let error = error {
                    completion(.firebaseError(error))
                    return
                }
            }
            // The document is saved in the snippet category with limited field, enough the display minimal infos.
            let snippet = book.createSnippet(with: uid)
            self?.saveDocument(for: snippet, with: uid, collection: .bookSnippets) { error in
                if let error = error {
                    completion(.firebaseError(error))
                    return
                }
            }
            // If no error the transaction is finished
            completion(nil)
        }
    }
    
    // MARK: Retrieve
    func retrieveBook(for id: String, completion: @escaping (Result<Item, FirebaseError>) -> Void) {
        guard let user = user else { return }
        
        let docRef = usersCollectionRef
            .document(user.uid)
            .collection(CollectionDocumentKey.books.rawValue)
            .document(id)
        docRef.getDocument { querySnapshot, error in
            if let error = error {
                completion(.failure(.firebaseError(error)))
                return
            }
            guard let querySnapshot = querySnapshot else {
                completion(.failure(.nothingFound))
                return
            }
            do {
                if let document = try querySnapshot.data(as: Item.self) {
                    completion(.success(document))
                }
            } catch {
                completion(.failure(.firebaseError(error)))
            }
        }
    }
    
    // MARK: Delete
    func deleteBook(book: Item, completion: @escaping CompletionHandler) {
        guard let user = user, let etag = book.etag else { return }
        let docRef = usersCollectionRef
            .document(user.uid)
            .collection(CollectionDocumentKey.books.rawValue)
            .whereField(BookDocumentKey.etag.rawValue, isEqualTo: etag)
            .limit(to: 1)
        docRef.getDocuments { [weak self] (snapshot, error) in
            if let error = error {
                completion(.firebaseError(error))
                return
            }
            if let foundDoc = snapshot?.documents,
               !foundDoc.isEmpty,
               let id = foundDoc.first?.documentID {
                self?.deleteDocument(with: id, collection: .books, completion: { error in
                    if let error = error {
                        completion(.firebaseError(error))
                        return
                    }
                })
                self?.deleteDocument(with: id, collection: .bookSnippets, completion: { error in
                    if let error = error {
                        completion(.firebaseError(error))
                        return
                    }
                })
                completion(nil)
            }
        }
    }
    
    // MARK: Retrive Snippets
    func getSnippets(limitNumber: Int = 0,
                     favoriteBooks: Bool = false,
                     completion: @escaping (Result<[BookSnippet], FirebaseError>) -> Void) {
        guard let docRef = createQuery(with: limitNumber,
                                       order: .timestamp,
                                       descending: true,
                                       favoriteBook: favoriteBooks) else { return }
        docRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(.firebaseError(error)))
                return
            }
            guard let documents = querySnapshot?.documents else {
                completion(.failure(.nothingFound))
                return
            }
            let data = documents.compactMap { documents -> BookSnippet? in
                do {
                    return try documents.data(as: BookSnippet.self)
                } catch {
                    completion(.failure(.firebaseError(error)))
                    return nil
                }
            }
            completion(.success(data))
        }
    }
   
    // MARK: - Favorite
    func addToFavorite(_ status: Bool, for id: String, completion: @escaping (FirebaseError?) -> Void) {
        
        setFavoriteStatus(with: id, favoriteState: status, collection: .books) { error in
            if let error = error {
                completion(.firebaseError(error))
                return
            }
        }
        setFavoriteStatus(with: id, favoriteState: status, collection: .bookSnippets) { error in
            if let error = error {
                completion(.firebaseError(error))
                return
            }
        }
        completion(nil)
    }
    
    private func setFavoriteStatus(with id: String,
                                   favoriteState: Bool,
                                   collection: CollectionDocumentKey,
                                   completion: @escaping (FirebaseError?) -> Void) {
        guard let user = user else { return }
        let documentRef = usersCollectionRef
            .document(user.uid)
            .collection(collection.rawValue)
            .document(id)
        documentRef.updateData([BookDocumentKey.favorite.rawValue : favoriteState]) { error in
            if let error = error {
                completion(.firebaseError(error))
                return
            }
            completion(nil)
        }
    }
}
