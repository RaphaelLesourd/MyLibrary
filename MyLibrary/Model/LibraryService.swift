//
//  LibraryService.swift
//  MyLibrary
//
//  Created by Birkyboy on 05/11/2021.
//

import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore

protocol LibraryServiceProtocol {
    func createBook(with book: Item, and imageData: Data, completion: @escaping (FirebaseError?) -> Void)
    func getBook(for bookID: String, ownerID: String, completion: @escaping (Result<Item, FirebaseError>) -> Void)
    func getBookList(for query: BookQuery, limit: Int, forMore: Bool, completion: @escaping (Result<[Item], FirebaseError>) -> Void)
    func deleteBook(book: Item, completion: @escaping (FirebaseError?) -> Void)
    func setStatusTo(to state: Bool, field: DocumentKey, for id: String?, completion: @escaping (FirebaseError?) -> Void)
    func removeBookListener()
}

class LibraryService {
    
    // MARK: - Properties
    typealias CompletionHandler = (FirebaseError?) -> Void
    
    private let recommandationService: RecommendationServiceProtocol
    private let imageService : ImageStorageProtocol
    private let db = Firestore.firestore()
    private var bookListListener: ListenerRegistration?
    
    let usersCollectionRef: CollectionReference
    
    var userID: String
    var lastBookFetched: QueryDocumentSnapshot?
    
    // MARK: - Initializer
    init() {
        usersCollectionRef = db.collection(CollectionDocumentKey.users.rawValue)
        self.recommandationService = RecommandationService()
        self.imageService = ImageStorageService()
        self.userID = Auth.auth().currentUser?.uid ?? ""
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
        let baseRef = createBaseRef()
        guard let docRef = baseRef?.collection(collection.rawValue).document(id) else { return }
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
        let baseRef = createBaseRef()
        guard let docRef = baseRef?.collection(collection.rawValue).document(id) else { return }
        docRef.updateData([field.rawValue : favoriteState]) { error in
            if let error = error {
                completion(.firebaseError(error))
                return
            }
            completion(nil)
        }
    }
    // MARK: Query
    private func createQuery(query: BookQuery, next: Bool) -> Query? {
        var docRef: Query = usersCollectionRef.document(userID).collection(CollectionDocumentKey.books.rawValue)
        
        switch query.listType {
        case .categories:
            if let categoryID = query.fieldValue {
                docRef = docRef.whereField(DocumentKey.category.rawValue, arrayContains: categoryID)
            }
        case .newEntry, .none:
            docRef = docRef.order(by: query.orderedBy.rawValue, descending: query.descending)
        case .favorites:
            docRef = docRef
                .order(by: query.orderedBy.rawValue, descending: query.descending)
                .whereField(DocumentKey.favorite.rawValue, isEqualTo: true)
        case .recommanding:
            docRef = db
                .collection(CollectionDocumentKey.recommanded.rawValue)
                .order(by: query.orderedBy.rawValue, descending: query.descending)
        }
        
        if let lastBook = lastBookFetched, next == true {
            docRef = docRef.start(afterDocument: lastBook)
        }
        return docRef
    }
    
    private func setBookId(for book: Item) -> String {
        if let bookId = book.bookID, !bookId.isEmpty {
            return bookId
        }
        return UUID().uuidString
    }
}
// MARK: - Extension LibraryServiceProtocol
extension LibraryService: LibraryServiceProtocol {
    
    // MARK: Create/Update
    func createBook(with book: Item, and imageData: Data, completion: @escaping CompletionHandler) {
        guard Networkconnectivity.shared.isReachable == true else {
            completion(.noNetwork)
            return
        }
        guard let bookTitle = book.volumeInfo?.title, !bookTitle.isEmpty else {
            completion(.noBookTitle)
            return
        }
        var book = book
        let bookID = setBookId(for: book)
        saveImage(imageData: imageData, bookID: bookID) { [weak self] storageLink in
            book.volumeInfo?.imageLinks?.thumbnail = storageLink
            book.ownerID = self?.userID
            book.bookID = bookID
            
            self?.saveDocument(for: book, with: bookID, collection: .books) { error in
                if let error = error {
                    completion(.firebaseError(error))
                }
                if book.recommanding == true {
                    self?.recommandationService.addToRecommandation(for: book) { _ in }
                }
                completion(nil)
            }
        }
    }
    
    // MARK: Retrieve
    func getBookList(for query: BookQuery, limit: Int, forMore: Bool, completion: @escaping (Result<[Item], FirebaseError>) -> Void) {
        guard let docRef = createQuery(query: query, next: forMore) else { return }
        
        bookListListener = docRef.limit(to: limit).addSnapshotListener { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            if let error = error {
                completion(.failure(.firebaseError(error)))
                return
            }
            self.lastBookFetched = querySnapshot?.documents.last
            
            let data = querySnapshot?.documents.compactMap { documents -> Item? in
                do {
                    return try documents.data(as: Item.self)
                } catch {
                    completion(.failure(.firebaseError(error)))
                    return nil
                }
            }
            if let data = data {
                completion(.success(data))
            }
        }
    }
    
    func getBook(for bookID: String, ownerID: String, completion: @escaping (Result<Item, FirebaseError>) -> Void) {
        let docRef = usersCollectionRef
            .document(ownerID)
            .collection(CollectionDocumentKey.books.rawValue)
            .whereField(DocumentKey.bookID.rawValue, isEqualTo: bookID)
        
        docRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(.firebaseError(error)))
                return
            }
            do {
                if let document = try querySnapshot?.documents.first?.data(as: Item.self) {
                    completion(.success(document))
                } else {
                    completion(.failure(.nothingFound))
                }
            } catch {
                completion(.failure(.firebaseError(error)))
            }
        }
    }
    
    // MARK: Delete
    func deleteBook(book: Item, completion: @escaping CompletionHandler) {
        guard let bookID = book.bookID else { return }
        
        imageService.deleteImageFromStorage(for: bookID) {  [weak self] error in
            if let error = error {
                completion(.firebaseError(error))
                return
            }
            self?.deleteDocument(with: bookID, collection: .books, completion: { error in
                if let error = error {
                    completion(.firebaseError(error))
                    return
                }
                if book.recommanding == true {
                    self?.recommandationService.removeFromRecommandation(for: book) { _ in
                        if let error = error {
                            completion(.firebaseError(error))
                        }
                    }
                }
                completion(nil)
            })
        }
    }
    
    // MARK: - Field update
    func setStatusTo(to state: Bool, field: DocumentKey, for id: String?, completion: @escaping CompletionHandler) {
        updateStatus(with: id ?? "", favoriteState: state, collection: .books, field: field) { error in
            if let error = error {
                completion(.firebaseError(error))
                return
            }
            completion(nil)
        }
    }
    
    // MARK: - Listerner
    func removeBookListener() {
        bookListListener?.remove()
    }
}
