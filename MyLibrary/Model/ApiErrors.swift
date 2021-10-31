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
    case afError(AFError)
    
    var description: String {
        switch self {
        case .emptyQuery:
            return "Votre recherche est vide"
        case .afError(let message):
            return message.localizedDescription
        }
    }
}
extension ApiError: Equatable {
    static func == (lhs: ApiError, rhs: ApiError) -> Bool {
        return lhs.description == rhs.description
    }
}
