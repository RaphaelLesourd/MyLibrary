//
//  ApiManager.swift
//  MyLibrary
//
//  Created by Birkyboy on 30/10/2021.
//

import Alamofire

class GoogleBooksService {
    // MARK: - Properties
    private let session: Session
    private let validation: ValidationProtocol
    
    // MARK: - Initializer
    init(session: Session,
         validation: ValidationProtocol) {
        self.session = session
        self.validation = validation
    }
    /// Verifies is the query keyword is a en ISBN.
    /// The .isIsbn string extension property checks if the string is composed only of number
    /// and is the number of charters is more than 10 which correspond to an ISBN10 format;
    /// - Parameters:
    ///   - keyword: words being searched
    ///   - fromIndex: Used for paging, index where the query should start.
    /// - Returns: AlamofireRouter URLRequest
    private func setParameters(for keyword: String, fromIndex: Int) -> AlamofireRouter {
        guard validation.validateIsbn(keyword) else {
           return .withKeyWord(words: keyword, startIndex: fromIndex)
        }
        return .withIsbn(isbn: keyword)
    }
}

extension GoogleBooksService: SearchBookService {
    /// Fetch Book data from API
    /// - Parameters:
    ///   - query: String of the words being searched
    ///   - fromIndex: Int index of where the data should be fetched.
    ///   - completion: Return an array of Item of an errorogf type ApiError in case of failure
    func getBooks(for query: String?,
                  fromIndex: Int,
                  completion: @escaping (Result<[ItemDTO], ApiError>) -> Void) {
        guard let query = query, !query.isEmpty else {
            completion(.failure(.emptyQuery))
            return
        }
        let parameters = setParameters(for: query, fromIndex: fromIndex)
        session
            .request(parameters)
            .validate(statusCode: 200..<504)
            .responseDecodable(of: BookModel.self) { response in
                switch response.result {
                case .success(let jsonData):
                    // Error path, present an error message corresponding to the error code
                    guard let httpErrorCode = response.response?.statusCode else { return }
                    guard httpErrorCode == 200 || httpErrorCode == 204 else {
                        return completion(.failure(.httpError(httpErrorCode)))
                    }
                    // Happy path, parse JSON data
                    guard let books = jsonData.items, !books.isEmpty else {
                        return completion(.failure(.noBooks))
                    }
                    completion(.success(books))
                case .failure(let error):
                    completion(.failure(.afError(error)))
                }
            }
    }
}
