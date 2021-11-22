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
    func setStatusTo(_ state: Bool, field: DocumentKey, for id: String?, completion: @escaping (FirebaseError?) -> Void)
    var bookListListener: ListenerRegistration? { get set }
}

class LibraryService {
    
    // MARK: - Properties
    typealias CompletionHandler = (FirebaseError?) -> Void
    
    private let recommandationService: RecommandationService
    private let imageService         : ImageStorageProtocol
    private let db          = Firestore.firestore()
   
    let usersCollectionRef  : CollectionReference
   
    var userID          : String
    var bookListListener: ListenerRegistration?
    var lastBookFetched : QueryDocumentSnapshot?

    // MARK: - Initializer
    init() {
        usersCollectionRef         = db.collection(CollectionDocumentKey.users.rawValue)
        self.recommandationService = RecommandationService()
        self.imageService          = ImageStorageService()
        self.userID                = Auth.auth().currentUser?.uid ?? ""
    }
    
    private func createBaseRef() -> DocumentReference? {
        return usersCollectionRef.document(userID)
    }
    
    // MARK: Save
    private func saveDocument<T: Codable>(for document: T, with id: String, collection: CollectionDocumentKey,
                                          completion: @escaping (FirebaseError?) -> Void) {
        guard let docRef = createBaseRef()?.collection(collection.rawValue).document(id) else { return }
        do {
            try docRef.setData(from: document)
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
        guard let docRef = createBaseRef()?.collection(collection.rawValue).document(id) else { return }
        docRef.delete { error in
            if let error = error {
                completion(.firebaseError(error))
                return
            }
            completion(nil)
        }
    }
    // MARK: Update
    private func updateStatus(with id: String, favoriteState: Bool,  collection: CollectionDocumentKey, field: DocumentKey,
                              completion: @escaping (FirebaseError?) -> Void) {
        guard let docRef = createBaseRef()?.collection(collection.rawValue).document(id) else { return }
        docRef.updateData([field.rawValue : favoriteState]) { error in
            if let error = error {
                completion(.firebaseError(error))
                return
            }
            completion(nil)
        }
    }
    // MARK: Verify
    private func checkDocumentExist(for book: Item?, completion: @escaping (String?) -> Void) {
        guard let book = book,
              let etag = book.etag else { return }

        let docRef = usersCollectionRef
            .document(userID)
            .collection(CollectionDocumentKey.books.rawValue)
            .whereField(DocumentKey.etag.rawValue, isEqualTo: etag)
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
        var docRef: Query = usersCollectionRef
            .document(userID)
            .collection(CollectionDocumentKey.books.rawValue)
     
        switch query.listType {
        case .categories:
            if let categoryName = query.fieldValue {
                docRef = docRef.whereField(DocumentKey.category.rawValue, arrayContains: categoryName)
            }
        case .newEntry, .none:
            docRef = docRef.order(by: query.orderedBy.rawValue, descending: query.descending)
        case .favorites:
            docRef = docRef
                .order(by: query.orderedBy.rawValue, descending: query.descending)
                .whereField(DocumentKey.favorite.rawValue, isEqualTo: true)
        case .recommanding:
            docRef = db.collection(CollectionDocumentKey.recommanded.rawValue)
                .order(by: query.orderedBy.rawValue, descending: query.descending)
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
        guard let bookTitle = book?.volumeInfo?.title, !bookTitle.isEmpty else {
            completion(.noBookTitle)
            return
        }
        var book = book
        checkDocumentExist(for: book) { [weak self] uid in
            let bookID = uid ?? UUID().uuidString
           
            self?.saveImage(imageData: imageData, bookID: bookID) { [weak self] storageLink in
                book?.volumeInfo?.imageLinks?.thumbnail = storageLink
                book?.ownerID = self?.userID
                book?.etag = bookID
                
                self?.saveDocument(for: book, with: bookID, collection: .books) { error in
                    if let error = error {
                        completion(.firebaseError(error))
                    }
                    if book?.recommanding == true {
                        self?.recommandationService.addToRecommandation(for: book) { _ in }
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
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(.firebaseError(error)))
                return
            }
            guard let documents = querySnapshot?.documents else {
                completion(.failure(.nothingFound))
                return
            }
            self.lastBookFetched = querySnapshot?.documents.last
            
            let data = documents.compactMap { documents -> Item? in
                do {
                    return try documents.data(as: Item.self)
                } catch {
                    completion(.failure(.firebaseError(error)))
                    return nil
                }
            }
            DispatchQueue.main.async {
                completion(.success(data))
            }
        }
    }
    
    func getBook(for bookID: String, completion: @escaping (Result<Item, FirebaseError>) -> Void) {
        
        let docRef = usersCollectionRef
            .document(userID)
            .collection(CollectionDocumentKey.books.rawValue)
            .whereField(DocumentKey.etag.rawValue, isEqualTo: bookID)
        
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
    func setStatusTo(_ state: Bool, field: DocumentKey, for id: String?, completion: @escaping (FirebaseError?) -> Void) {
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
