//
//  Router.swift
//  Reciplease
//
//  Created by Birkyboy on 22/09/2021.
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
                    "maxResults": 39,
                    "filter": "paid-ebooks",
                    "orderBy": "relevance"]
        }
    }

    // Conforming to URLRequestConvertible protocol, returning URLRequest
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(100_000)
        return try URLEncoding.default.encode(request, with: parameters)
    }
}