//
//  ApiErrors.swift
//  MyLibrary
//
//  Created by Birkyboy on 30/10/2021.
//

import Foundation
import Alamofire

enum ApiError: Error {
    case emptyQuery
    case noBooks
    case afError(AFError)
    
    var description: String {
        switch self {
        case .emptyQuery:
            return "Votre recherche est vide"
        case .afError(let error):
            return error.isSessionTaskError ? "Pas de connection réseau" : error.localizedDescription
        case .noBooks:
            return "Rien trouvé"
        }
    }
}

extension ApiError: Equatable {
    static func == (lhs: ApiError, rhs: ApiError) -> Bool {
        return lhs.description == rhs.description
    }
}
