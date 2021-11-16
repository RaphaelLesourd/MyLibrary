//
//  Router.swift
//  MyLibrary
//
//  Created by Birkyboy on 30/10/2021.
//

import Foundation
import Alamofire

/// This enum allows to have a centralized endpoints query.
/// Should we need to make other type of queries in the future, new cases will just need to be added.
enum AlamofireRouter: URLRequestConvertible {
    // cases
    case withIsbn(isbn: String)
    case withKeyWord(words: String, startIndex: Int)
    
    private var baseURL: String {
        switch self {
        case .withIsbn, .withKeyWord:
            return "https://www.googleapis.com/books/v1/"
        }
    }
    // Http methods
    private var method: HTTPMethod {
        switch self {
        case .withIsbn, .withKeyWord:
            return .get
        }
    }
    // Path
    private var path: String {
        switch self {
        case .withIsbn, .withKeyWord:
            return "volumes"
        }
    }
    // Parameters
    private var parameters: [String: Any] {
        switch self {
        case .withIsbn(isbn: let isbn):
            return ["q": "isbn:\(isbn)"]
        case .withKeyWord(words: let words, let startIndex):
            return ["q": words,
                    "startIndex": startIndex,
                    "maxResults": 40,
                    "filter": "paid-ebooks",
                    "orderBy": "relevance",
                    "zoom": 0,
                    "img": true]
        }
    }
    // Conforming to URLRequestConvertible protocol, returning URLRequest
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        return try URLEncoding.default.encode(request, with: parameters)
    }
}
