//
//  SearchManager.swift
//  MyLibrary
//
//  Created by Birkyboy on 29/10/2021.
//

import Foundation

protocol SearchMangerProtocol {
    func getBooks(with query: AlamofireRouter, completion: @escaping (Result<[Item], Error>) -> Void)
}

class SearchManager: SearchMangerProtocol {
    
    private var api: NetworkProtocol = NetworkService(session: .default)
 
    func getBooks(with query: AlamofireRouter, completion: @escaping (Result<[Item], Error>) -> Void) {
        api.getData(with: query) { result in
            switch result {
            case .success(let book):
                guard let books = book.items else { return }
                completion(.success(books))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
