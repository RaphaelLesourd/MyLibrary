//
//  LibraryService.swift
//  MyLibrary
//
//  Created by Birkyboy on 05/11/2021.
//

import Foundation
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore

protocol LibraryServiceProtocol {
    func createBook(with book: Item?, and imageData: Data, completion: @escaping (FirebaseError?) -> Void)
    func getBook(for bookID: String, completion: @escaping (Result<Item, FirebaseError>) -> Void)
    func getBookList(for query: BookQuery, limit: Int, forMore: Bool, completion: @escaping (Result<[Item], FirebaseError>) -> Void)
    func deleteBook(book: Item?, completion: @escaping (FirebaseError?) -> Void)
    func setStatusTo(_ state: Bool, field: BookDocumentKey, for id: String?, completion: @escaping (FirebaseError?) -> Void)
}

class LibraryService {
    
    // MARK: - Properties
    typealias CompletionHandler = (FirebaseError?) -> Void
    
    private let imageService      : ImageStorageProtocol
    private let db                = Firestore.firestore()
    let usersCollectionRef: CollectionReference
   
    var userID            = Auth.auth().currentUser?.uid
    var bookListListener  : ListenerRegistration?
    var lastBookFetched   : QueryDocumentSnapshot?
    
    // MARK: - Initializer
    init() {
        usersCollectionRef = db.collection(CollectionDocumentKey.users.rawValue)
        self.imageService = ImageStorageService()
    }
    
    // MARK: Save
    private func saveDocument<T: Codable>(for document: T,  with id: String, collection: CollectionDocumentKey,
                                          completion: @escaping (FirebaseError?) -> Void) {
        guard let userID = userID else { return }
        
        let ref = usersCollectionRef
            .document(userID)
            .collection(collection.rawValue)
            .document(id)
        
        do {
            try ref.setData(from: document)
            completion(nil)
        } catch { completion(.firebaseError(error)) }
    }
    
    private func saveImage(imageData: Data, bookID: String, completion: @escaping (String?) -> Void) {
        imageService.storeBookCoverImage(for: imageData, nameID: bookID) { result in
            switch result {
            case .success(let imageLink):
                completion(imageLink)
            case .failure(_):
                completion(nil)
            }
        }
    }
    // MARK: Delete
    private func deleteDocument(with id: String, collection: CollectionDocumentKey, completion: @escaping CompletionHandler) {
        guard let userID = userID else { return }
        
        let docRef = usersCollectionRef
            .document(userID)
            .collection(collection.rawValue)
            .document(id)
        
        docRef.delete { error in
            if let error = error {
                completion(.firebaseError(error))
                return
            }
            completion(nil)
        }
    }
    // MARK: Update
    private func updateStatus(with id: String, favoriteState: Bool,  collection: CollectionDocumentKey, field: BookDocumentKey,
                              completion: @escaping (FirebaseError?) -> Void) {
        guard let userID = userID else { return }
        
        let documentRef = usersCollectionRef
            .document(userID)
            .collection(collection.rawValue)
            .document(id)
        
        documentRef.updateData([field.rawValue : favoriteState]) { error in
            if let error = error {
                completion(.firebaseError(error))
                return
            }
            completion(nil)
        }
    }
    // MARK: Verify
    private func checkDocumentExist(for book: Item?, completion: @escaping (String?) -> Void) {
        guard let userID = userID,
              let book = book,
              let etag = book.etag else { return }

        let docRef = usersCollectionRef
            .document(userID)
            .collection(CollectionDocumentKey.books.rawValue)
            .whereField(BookDocumentKey.etag.rawValue, isEqualTo: etag)
            .limit(to: 1)
        
        docRef.getDocuments { (snapshot, error) in
            if error != nil {
                completion(nil)
                return
            }
            if let foundDoc = snapshot?.documents,
               !foundDoc.isEmpty,
               let document = foundDoc.first {
                completion(document.documentID)
            } else {
                completion(nil)
            }
        }
    }
    // MARK: Query
    private func createQuery(query: BookQuery, next: Bool) -> Query? {
        guard let userID = userID else { return nil }
        
        var docRef = usersCollectionRef
            .document(userID)
            .collection(CollectionDocumentKey.books.rawValue)
            .order(by: query.orderedBy.rawValue, descending: query.descending)
        
        switch query.listType {
        case .categories:
            return nil
        case .newEntry, .none:
            break
        case .favorites:
            docRef = docRef.whereField(BookDocumentKey.favorite.rawValue, isEqualTo: true)
        case .recommanding:
            docRef = db.collection("recommanded").order(by: query.orderedBy.rawValue, descending: query.descending)
        }
        if let lastBook = lastBookFetched, next == true {
            docRef = docRef.start(afterDocument: lastBook)
        }
        return docRef
    }
}

// MARK: - LibraryServiceProtocol Extension
extension LibraryService: LibraryServiceProtocol {
    
    // MARK: Create/Update
    func createBook(with book: Item?, and imageData: Data, completion: @escaping (FirebaseError?) -> Void) {
        guard let userID = userID else { return }
        guard let bookTitle = book?.volumeInfo?.title, !bookTitle.isEmpty else {
            completion(.noBookTitle)
            return
        }
        var book = book
        
        checkDocumentExist(for: book) { [weak self] uid in
            let bookID = uid ?? UUID().uuidString
           
            self?.saveImage(imageData: imageData, bookID: bookID) { [weak self] storageLink in
                book?.volumeInfo?.imageLinks?.thumbnail = storageLink
                book?.ownerID = userID
                book?.etag = bookID
               
                self?.saveDocument(for: book, with: bookID, collection: .books) { error in
                    if let error = error {
                        completion(.firebaseError(error))
                    }
                    completion(nil)
                }
            }
        }
    }
    
   // MARK: Retrieve
    func getBookList(for query: BookQuery, limit: Int, forMore: Bool, completion: @escaping (Result<[Item], FirebaseError>) -> Void) {
        guard let docRef = createQuery(query: query, next: forMore) else {
            completion(.failure(.nothingFound))
            return
        }
        bookListListener = docRef.limit(to: limit).addSnapshotListener { [weak self] (querySnapshot, error) in
            if let error = error {
                completion(.failure(.firebaseError(error)))
                return
            }
            guard let documents = querySnapshot?.documents else {
                completion(.failure(.nothingFound))
                return
            }
            self?.lastBookFetched = querySnapshot?.documents.last
            
            let data = documents.compactMap { documents -> Item? in
                do {
                    return try documents.data(as: Item.self)
                } catch {
                    completion(.failure(.firebaseError(error)))
                    return nil
                }
            }
            completion(.success(data))
        }
    }
    
    func getBook(for bookID: String, completion: @escaping (Result<Item, FirebaseError>) -> Void) {
        guard let userID = userID else { return }
        
        let docRef = usersCollectionRef
            .document(userID)
            .collection(CollectionDocumentKey.books.rawValue)
            .whereField(BookDocumentKey.etag.rawValue, isEqualTo: bookID)
        
        docRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(.firebaseError(error)))
                return
            }
            guard let querySnapshot = querySnapshot?.documents.first else {
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
    func deleteBook(book: Item?, completion: @escaping CompletionHandler) {
        guard let bookID = book?.etag else {
            completion(.nothingFound)
            return
        }
        deleteDocument(with: bookID, collection: .books, completion: { [weak self] error in
            if let error = error {
                completion(.firebaseError(error))
                return
            }
            self?.imageService.deleteImageFromStorage(for: bookID) { error in
                if let error = error {
                    completion(.firebaseError(error))
                    return
                }
                completion(nil)
            }
        })
    }
    
    // MARK: - Field update
    func setStatusTo(_ state: Bool, field: BookDocumentKey, for id: String?, completion: @escaping (FirebaseError?) -> Void) {
        guard let id = id else {
            completion(.nothingFound)
            return
        }
        updateStatus(with: id, favoriteState: state, collection: .books, field: field) { error in
            if let error = error {
                completion(.firebaseError(error))
                return
            }
            completion(nil)
        }
    }
}
