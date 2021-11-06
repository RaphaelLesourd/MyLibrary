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
    func retrieveBook(_ snippet: Item, completion: @escaping (Result<Item, FirebaseError>) -> Void)
    func deleteBook(book: Item, completion: @escaping (FirebaseError?) -> Void)
    func getSnippets(limitNumber: Int, completion: @escaping (Result<[Item], FirebaseError>) -> Void)
}

class LibraryService {
    
    let db = Firestore.firestore()
    let usersCollectionRef: CollectionReference
    let user = Auth.auth().currentUser
    
    init() {
        usersCollectionRef = db.collection(CollectionDocumentKey.users.rawValue)
    }
    
    private func saveDocument(for book: Item, completion: @escaping (FirebaseError?) -> Void) {
        guard let user = user else { return }
        let uid = UUID().uuidString
        usersCollectionRef
            .document(user.uid)
            .collection(CollectionDocumentKey.books.rawValue)
            .document(uid)
            .setData(book.toDocument(id: uid)) { error in
                if let error = error {
                    completion(.firebaseError(error))
                    return
                }
            }
        usersCollectionRef
            .document(user.uid)
            .collection(CollectionDocumentKey.snippets.rawValue)
            .document(uid)
            .setData(book.toSnippet(id: uid)) { error in
                if let error = error {
                    completion(.firebaseError(error))
                    return
                }
                completion(nil)
            }
    }

    private func updateBook(book: Item, withID id: String, completion: @escaping (FirebaseError?) -> Void) {
        guard let user = user else { return }
        usersCollectionRef
            .document(user.uid)
            .collection(CollectionDocumentKey.books.rawValue)
            .document(id)
            .updateData(book.toDocument(id: id)) { error in
                if let error = error {
                    completion(.firebaseError(error))
                    return
                }
            }
        usersCollectionRef
            .document(user.uid)
            .collection(CollectionDocumentKey.snippets.rawValue)
            .document(id)
            .updateData(book.toSnippet(id: id)) { error in
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
        guard let isbn = book.volumeInfo?.industryIdentifiers?.first?.identifier else { return }
        let docRef = usersCollectionRef
            .document(user.uid)
            .collection(CollectionDocumentKey.books.rawValue)
            .whereField(BookDocumentKey.isbn.rawValue, isEqualTo: isbn).limit(to: 1)
       
        docRef.getDocuments { (snapshot, error) in
            if let error = error {
                completion(.firebaseError(error))
                return
            }
            if let foundDoc = snapshot?.documents, !foundDoc.isEmpty {
                self.updateBook(book: book, withID: foundDoc.first?.documentID ?? "") { error in
                    if let error = error {
                        completion(.firebaseError(error))
                        return
                    }
                }
                completion(nil)
                return
            }
            self.saveDocument(for: book) { error in
                if let error = error {
                    completion(.firebaseError(error))
                    return
                }
            }
            completion(nil)
        }
    }
    
    func retrieveBook(_ snippet: Item, completion: @escaping (Result<Item, FirebaseError>) -> Void) {
        guard let user = user, let id = snippet.id else { return }
    
        let docRef = usersCollectionRef
            .document(user.uid)
            .collection(CollectionDocumentKey.books.rawValue)
            .whereField(BookDocumentKey.id.rawValue, isEqualTo: id).limit(to: 1)
       
        docRef.getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(.firebaseError(error)))
                return
            }
            guard let snapshot = snapshot,
                  let data = snapshot.documents.first?.data(),
                    let book = Item(book: data) else {
                        completion(.failure(.errorRetrievingBook))
                        return
                    }
            completion(.success(book))
        }
    }
    
    func deleteBook(book: Item, completion: @escaping (FirebaseError?) -> Void) {
        guard let user = user, let id = book.id else { return }
        usersCollectionRef
            .document(user.uid)
            .collection(CollectionDocumentKey.books.rawValue)
            .document(id).delete { error in
                if let error = error {
                    completion(.firebaseError(error))
                    return
                }
            }
        usersCollectionRef
            .document(user.uid)
            .collection(CollectionDocumentKey.snippets.rawValue)
            .document(id).delete { error in
                if let error = error {
                    completion(.firebaseError(error))
                    return
                }
                completion(nil)
            }
    }
    
    func getSnippets(limitNumber: Int = 0, completion: @escaping (Result<[Item], FirebaseError>) -> Void) {
        guard let user = user else { return }
        var docRef: Query = usersCollectionRef
            .document(user.uid)
            .collection(CollectionDocumentKey.snippets.rawValue)
            .order(by: BookDocumentKey.date.rawValue, descending: true)
        if limitNumber > 0 {
            docRef = docRef.limit(to: limitNumber)
        }
        docRef.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(.firebaseError(error)))
                return
            }
            guard let snapshot = snapshot else { return }

            var snippets: [Item] = []
            snapshot.documents.forEach {
                if let data = Item(book: $0.data()) {
                    snippets.append(data)
                }
            }
            completion(.success(snippets))
        }
    }
}
