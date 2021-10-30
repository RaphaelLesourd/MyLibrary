//
//  BookingClient.swift
//  Reciplease
//
//  Created by Birkyboy on 07/09/2021.
//

import Foundation
import Alamofire

protocol NetworkProtocol {
    func getData(with parameters: AlamofireRouter, completion: @escaping (Result<BookModel, Error>) -> Void)
}

class NetworkService {
    
    // MARK: - Properties
    let session: Session
    
    // MARK: - Initializer
    init(session: Session = .default) {
        self.session = session
    }
    
    func getData(with parameters: AlamofireRouter, completion: @escaping (Result<BookModel, Error>) -> Void) {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        session.request(parameters)
            .validate()
            .responseDecodable(of: BookModel.self, decoder: decoder) { response in
                    switch response.result {
                    case .success(let jsonData):
                        completion(.success(jsonData))
                    case .failure(let error):
                        print(String(describing: error))
                        completion(.failure(error))
                    }
            }
    }
}

extension NetworkService: NetworkProtocol {}
