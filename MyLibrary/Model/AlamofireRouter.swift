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
    case sendPushMessage(payload: MessageModel)
    
    private var baseURL: String {
        switch self {
        case .withIsbn, .withKeyWord:
            return ApiUrl.googleBooksURL
        case .sendPushMessage:
            return ApiUrl.fcmURL
        }
    }
    // Http methods
    private var method: HTTPMethod {
        switch self {
        case .withIsbn, .withKeyWord:
            return .get
        case .sendPushMessage:
            return .post
        }
    }
    // Path
    private var path: String {
        switch self {
        case .withIsbn, .withKeyWord:
            return "volumes"
        case .sendPushMessage:
            return "send"
        }
    }
    // Parameters
    private var parameters: Parameters {
        switch self {
        case .withIsbn(isbn: let isbn):
            return ["q": "isbn:\(isbn)"]
        case .withKeyWord(words: let words, let startIndex):
            return ["q": words,
                    "startIndex": startIndex,
                    "maxResults": 40,
                    "filter": "paid-ebooks",
                    "orderBy": "newest",
                    "zoom": 0,
                    "img": true]
        case .sendPushMessage(payload: let payload):
            return ["to": payload.token,
                    "content_available" : true,
                    "mutable_content": true,
                    "category": "content_added_notification",
                    "notification": ["title": "My Library",
                                     "subtitle": payload.title,
                                     "body": payload.body,
                                     "badge": 1,
                                     "priority": "high",
                                     "sound": "default"],
                    "data": ["bookID": payload.bookID,
                             "ownerID": payload.ownerID]
            ]
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
        case .sendPushMessage:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(ApiKeys.fcmKEY, forHTTPHeaderField: "Authorization")
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            return try URLEncoding.httpBody.encode(request, with: nil)
        }
    }
}
