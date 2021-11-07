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
import CloudKit

protocol LibraryServiceProtocol {
    func createBook(with book: Item?, completion: @escaping (FirebaseError?) -> Void)
    func retrieveBook(for id: String, completion: @escaping (Result<Item, FirebaseError>) -> Void)
    func deleteBook(book: Item, completion: @escaping (FirebaseError?) -> Void)
    func getSnippets(limitNumber: Int, completion: @escaping (Result<[BookSnippet], FirebaseError>) -> Void)
}

class LibraryService {
    
    let db = Firestore.firestore()
    let usersCollectionRef: CollectionReference
    let user = Auth.auth().currentUser
    
    init() {
        usersCollectionRef = db.collection(CollectionDocumentKey.users.rawValue)
    }
    
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
            completion(nil)
        } catch {
            completion(.firebaseError(error))
        }
    }
    
    private func deleteDocument(with id: String,
                                collection: CollectionDocumentKey,
                                completion: @escaping (FirebaseError?) -> Void) {
        guard let user = user else { return }
        usersCollectionRef.document(user.uid).collection(collection.rawValue).document(id).delete { error in
            if let error = error {
                completion(.firebaseError(error))
                return
            }
            completion(nil)
        }
    }
}

extension LibraryService: LibraryServiceProtocol {
    
    func createBook(with book: Item?, completion: @escaping (FirebaseError?) -> Void) {
        guard let user = user, let book = book else { return }
        guard let etag = book.etag else { return }
        var uid = UUID().uuidString
        
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
               let document = foundDoc.first {
                uid = document.documentID
            }
            self?.saveDocument(for: book, with: uid, collection: .books) { error in
                if let error = error {
                    completion(.firebaseError(error))
                    return
                }
            }
            let snippet = book.createSnippet(with: uid)
            self?.saveDocument(for: snippet, with: uid, collection: .bookSnippets) { error in
                if let error = error {
                    completion(.firebaseError(error))
                    return
                }
            }
            completion(nil)
        }
    }
    
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
    
    func deleteBook(book: Item, completion: @escaping (FirebaseError?) -> Void) {
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
                self?.deleteDocument(with: id, collection: .favoriteSnippets, completion: { error in
                    if let error = error {
                        completion(.firebaseError(error))
                        return
                    }
                })
                completion(nil)
            }
        }
    }
    
    func getSnippets(limitNumber: Int = 0, completion: @escaping (Result<[BookSnippet], FirebaseError>) -> Void) {
        guard let user = user else { return }
        
        var docRef: Query = usersCollectionRef
            .document(user.uid)
            .collection(CollectionDocumentKey.bookSnippets.rawValue)
            .order(by: BookDocumentKey.date.rawValue, descending: true)
        if limitNumber > 0 {
            docRef = docRef.limit(to: limitNumber)
        }
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
}
