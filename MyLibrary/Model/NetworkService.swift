//
//  BookingClient.swift
//  Reciplease
//
//  Created by Birkyboy on 07/09/2021.
//

import Foundation
import Alamofire

protocol NetworkProtocol {
    func getData(with query: String?, completion: @escaping (Result<BookModel, ApiError>) -> Void)
}

class NetworkService {
    // MARK: - Properties
    let session: Session
    
    // MARK: - Initializer
    init(session: Session = .default) {
        self.session = session
    }
    
    func getData(with query: String?, completion: @escaping (Result<BookModel, ApiError>) -> Void) {
        guard let query = query, !query.isEmpty else {
            completion(.failure(.emptyQuery))
            return
        }
        let parameters = isQueryIsbn(for: query)
        session
            .request(parameters)
            .validate()
            .responseDecodable(of: BookModel.self) { response in
                    switch response.result {
                    case .success(let jsonData):
                        completion(.success(jsonData))
                    case .failure(let error):
                        print(String(describing: error))
                        completion(.failure(.afError(error)))
                    }
            }
    }
    
    private func isQueryIsbn(for keyword: String) -> AlamofireRouter {
        return keyword.isIsbn ? .withIsbn(isbn: keyword) : .withKeyWord(words: keyword)
    }
}

extension NetworkService: NetworkProtocol {}
