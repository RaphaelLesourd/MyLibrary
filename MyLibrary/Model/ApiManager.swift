//
//  BookingClient.swift
//  Reciplease
//
//  Created by Birkyboy on 07/09/2021.
//

import Foundation
import Alamofire

protocol ApiManagerProtocol {
    func getData(with query: String?, fromIndex: Int, completion: @escaping (Result<[Item], ApiError>) -> Void)
}

class ApiManager {
    // MARK: - Properties
    let session: Session
    
    // MARK: - Initializer
    init(session: Session = .default) {
        self.session = session
    }
    /// Verifies is the query keyword is a en ISBN.
    /// The .isIsbn string extension property checks if the string is composed only of number
    /// and is the number of charters is more than 10 which correspond to an ISBN10 format;
    /// - Parameters:
    ///   - keyword: words being searched
    ///   - fromIndex: Used for paging, index where the query should start.
    /// - Returns: AlamofireRouter URLRequest
    private func isQueryIsbn(for keyword: String, fromIndex: Int) -> AlamofireRouter {
        return keyword.isIsbn ? .withIsbn(isbn: keyword) : .withKeyWord(words: keyword, startIndex: fromIndex)
    }
}

extension ApiManager: ApiManagerProtocol {
    /// Fetch Book data from API
    /// - Parameters:
    ///   - query: String of the words being searched
    ///   - fromIndex: Int index of where the data should be fetched.
    ///   - completion: Return an array of Item of an errorogf type ApiError in case of failure
    func getData(with query: String?, fromIndex: Int, completion: @escaping (Result<[Item], ApiError>) -> Void) {
        guard let query = query, !query.isEmpty else {
            completion(.failure(.emptyQuery))
            return
        }
        let parameters = isQueryIsbn(for: query, fromIndex: fromIndex)
        session
            .request(parameters)
            .validate()
            .responseDecodable(of: BookModel.self) { response in
                switch response.result {
                case .success(let jsonData):
                    guard let books = jsonData.items, !books.isEmpty else {
                         completion(.failure(.noBooks))
                        return
                    }
                    completion(.success(books))
                case .failure(let error):
                    completion(.failure(.afError(error)))
                }
            }
    }
}
