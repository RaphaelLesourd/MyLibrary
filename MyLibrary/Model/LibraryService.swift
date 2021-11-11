//
//  LibraryService.swift
//  MyLibrary
//
//  Created by Birkyboy on 05/11/2021.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore
import Firebase

protocol LibraryServiceProtocol {
    func createBook(with book: Item?, completion: @escaping (FirebaseError?) -> Void)
    func retrieveBook(for id: String, completion: @escaping (Result<Item, FirebaseError>) -> Void)
    func deleteBook(book: Item?, completion: @escaping (FirebaseError?) -> Void)
    func getSnippets(for query: SnippetQuery, forMore: Bool, completion: @escaping (Result<[BookSnippet], FirebaseError>) -> Void)
    func addToFavorite(_ status: Bool, for id: String?, completion: @escaping (FirebaseError?) -> Void)
}

class LibraryService {
    
    // MARK: - Properties
    typealias CompletionHandler = (FirebaseError?) -> Void
    var userID            = Auth.auth().currentUser?.uid
    private let db        = Firestore.firestore()
    var bookListener      : ListenerRegistration?
    var snippetListener   : ListenerRegistration?
    let usersCollectionRef: CollectionReference
    var lastSnippetFetched: QueryDocumentSnapshot?
    
    // MARK: - Initializer
    init() {
        usersCollectionRef = db.collection(CollectionDocumentKey.users.rawValue)
    }
    
    // MARK: - Private functions
    private func saveDocument<T: Codable>(for document: T,
                                          with id: String,
                                          collection: CollectionDocumentKey,
                                          completion: @escaping (FirebaseError?) -> Void) {
        guard let userID = userID else { return }
        let ref = usersCollectionRef
            .document(userID)
            .collection(collection.rawValue)
            .document(id)
        do {
            try ref.setData(from: document)
            ref.setData([BookDocumentKey.etag.rawValue: id], merge: true)
            completion(nil)
        } catch { completion(.firebaseError(error)) }
    }
    
    private func updateDocumentImage(with imageLink: String?, for collection: CollectionDocumentKey, id: String) {
        guard let userID = userID, let imageLink = imageLink else { return }
        let ref = usersCollectionRef.document(userID).collection(collection.rawValue).document(id)
        ref.updateData(["photoURL": imageLink])
    }
    
    private func deleteDocument(with id: String,
                                collection: CollectionDocumentKey,
                                completion: @escaping CompletionHandler) {
        guard let userID = userID else { return }
        usersCollectionRef.document(userID).collection(collection.rawValue).document(id).delete { error in
            if let error = error {
                completion(.firebaseError(error))
                return
            }
            completion(nil)
        }
    }
    
    private func checkDocumentExist(for book: Item?, completion: @escaping (Result<String?, FirebaseError>) -> Void) {
        guard let userID = userID,
              let book = book,
              let etag = book.etag else { return }

        let docRef = usersCollectionRef
            .document(userID)
            .collection(CollectionDocumentKey.books.rawValue)
            .whereField(BookDocumentKey.etag.rawValue, isEqualTo: etag)
            .limit(to: 1)
        
        docRef.getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(.firebaseError(error)))
                return
            }
            if let foundDoc = snapshot?.documents,
               !foundDoc.isEmpty,
               let document = foundDoc.first {
                completion(.success(document.documentID))
            } else {
                completion(.success(nil))
            }
        }
    }
    
    private func setFavoriteStatus(with id: String,
                                   favoriteState: Bool,
                                   collection: CollectionDocumentKey,
                                   completion: @escaping (FirebaseError?) -> Void) {
        guard let userID = userID else { return }
        let documentRef = usersCollectionRef
            .document(userID)
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
    
    private func createQuery(query: SnippetQuery, next: Bool) -> Query? {
        guard let userID = userID else { return nil }
        var docRef = usersCollectionRef
            .document(userID)
            .collection(CollectionDocumentKey.bookSnippets.rawValue)
            .order(by: query.orderedBy.rawValue, descending: query.descending)
        
        switch query.listType {
        case .categories:
            return nil
        case .newEntry:
            break
        case .favorites:
            docRef = docRef.whereField(BookDocumentKey.favorite.rawValue, isEqualTo: true)
        case .recommanding:
            docRef = docRef.whereField(BookDocumentKey.recommanding.rawValue, isEqualTo: true)
        }
        if let lastSnippet = lastSnippetFetched, next == true {
            docRef = docRef.start(afterDocument: lastSnippet)
        }
        return docRef.limit(to: query.limit)
    }
}

// MARK: - LibraryServiceProtocol Extension
extension LibraryService: LibraryServiceProtocol {
    
    // MARK: Create/Update
    func createBook(with book: Item?, completion: @escaping CompletionHandler) {
        
        checkDocumentExist(for: book) { [weak self] result in
            switch result {
            case .success(let id):
                let uid = id ?? UUID().uuidString
                self?.saveDocument(for: book, with: uid, collection: .books) { error in
                    if let error = error {
                        completion(.firebaseError(error))
                        return
                    }
                }
                let snippet = book?.createSnippet(with: uid)
                self?.saveDocument(for: snippet, with: uid, collection: .bookSnippets) { error in
                    if let error = error {
                        completion(.firebaseError(error))
                        return
                    }
                }
                completion(nil)
            case .failure(let error):
                completion(.firebaseError(error))
            }
            self?.bookListener?.remove()
        }
    }
    
    // MARK: Retrieve
    func retrieveBook(for id: String, completion: @escaping (Result<Item, FirebaseError>) -> Void) {
        guard let userID = userID else { return }

        let docRef = usersCollectionRef
            .document(userID)
            .collection(CollectionDocumentKey.books.rawValue)
            .document(id)
        
        bookListener = docRef.addSnapshotListener { querySnapshot, error in
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
            } catch { completion(.failure(.firebaseError(error))) }
        }
    }
    
    // MARK: Delete
    func deleteBook(book: Item?, completion: @escaping CompletionHandler) {
        checkDocumentExist(for: book) { [weak self] result in
            switch result {
            case .success(let id):
                guard let id = id else {
                    completion(.nothingFound)
                    return
                }
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
            case .failure(let error):
                completion(.firebaseError(error))
            }
        }
    }
    
    // MARK: Retrive Snippets
    func getSnippets(for query: SnippetQuery, forMore: Bool, completion: @escaping (Result<[BookSnippet], FirebaseError>) -> Void) {
        guard let docRef = createQuery(query: query, next: forMore) else {
            completion(.failure(.nothingFound))
            return
        }
        snippetListener = docRef.addSnapshotListener { [weak self] (querySnapshot, error) in
            if let error = error {
                completion(.failure(.firebaseError(error)))
                return
            }
            guard let documents = querySnapshot?.documents else {
                completion(.failure(.nothingFound))
                return
            }
            self?.lastSnippetFetched = querySnapshot?.documents.last
            
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
    func addToFavorite(_ state: Bool, for id: String?, completion: @escaping (FirebaseError?) -> Void) {
        guard let id = id else {
            completion(.nothingFound)
            return
        }
        setFavoriteStatus(with: id, favoriteState: state, collection: .books) { error in
            if let error = error {
                completion(.firebaseError(error))
                return
            }
        }
        setFavoriteStatus(with: id, favoriteState: state, collection: .bookSnippets) { error in
            if let error = error {
                completion(.firebaseError(error))
                return
            }
        }
        completion(nil)
    }
}
