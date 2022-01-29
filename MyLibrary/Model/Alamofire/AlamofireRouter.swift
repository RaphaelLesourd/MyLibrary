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
    case pushMessage(with: MessageModel)
    
    // Parameters
    var parameters: Parameters {
        switch self {
        case .withIsbn(isbn: let isbn):
            return ["q": "isbn:\(isbn)"]
        case .withKeyWord(words: let words, let startIndex):
            return makeBookSearch(with: words, and: startIndex)
        case .pushMessage(with: let message):
            return makeMessage(with: message)
        }
    }
    // Conforming to URLRequestConvertible protocol, returning URLRequest
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue

        switch self {
        case .withIsbn, .withKeyWord:
            return try URLEncoding.default.encode(request, with: parameters)
        case .pushMessage:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(Keys.fcmKEY, forHTTPHeaderField: "Authorization")
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            return try URLEncoding.httpBody.encode(request, with: nil)
        }
    }
    // MARK: - Private functions

    private var baseURL: String {
        switch self {
        case .withIsbn, .withKeyWord:
            return ApiUrl.googleBooksURL
        case .pushMessage:
            return ApiUrl.fcmURL
        }
    }

    private var method: HTTPMethod {
        switch self {
        case .withIsbn, .withKeyWord:
            return .get
        case .pushMessage:
            return .post
        }
    }

    private var path: String {
        switch self {
        case .withIsbn, .withKeyWord:
            return "volumes"
        case .pushMessage:
            return "send"
        }
    }
    
    // MARK: - Parameters
    private func makeBookSearch(with words: String, and startIndex: Int) -> Parameters {
        return ["q": words,
                "startIndex": startIndex,
                "maxResults": 40,
                "filter": "paid-ebooks",
                "orderBy": "relevance",
                "zoom": 0,
                "img": true]
    }
    
    private func makeMessage(with payload: MessageModel) -> Parameters {
        return ["to": payload.token,
                "content_available": true,
                "mutable_content": true,
                "category": "comment",
                "notification": ["title": payload.title,
                                 "body": payload.body,
                                 "badge": 1,
                                 "priority": "high",
                                 "sound": "default"],
                "data": ["bookID": payload.bookID,
                         "ownerID": payload.ownerID,
                         "imageURL": payload.imageURL]
        ]
    }
}
