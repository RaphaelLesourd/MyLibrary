//
//  ApiErrors.swift
//  MyLibrary
//
//  Created by Birkyboy on 30/10/2021.
//

import Alamofire

enum ApiError: Error {
    case emptyQuery
    case noBooks
    case httpError(Int)
    case afError(AFError)
    
    var description: String {
        switch self {
        case .emptyQuery:
            return Text.Banner.emptyQuery
        case .afError(let error):
            return error.isSessionTaskError ? Text.Banner.noNetwork : error.localizedDescription
        case .noBooks:
            return Text.Banner.notFound
        case .httpError(let code):
            return getHttpErrorMessage(for: code)
        }
    }
    
    func getHttpErrorMessage(for code: Int) -> String {
        switch code {
        case 400:
            return Text.Banner.invalidRequest
        case 401:
            return Text.Banner.accessNotAuthorizedMessage
        case 403:
            return Text.Banner.forbiden
        case 404:
            return Text.Banner.notFound
        case 429:
            return Text.Banner.tooManyRequests
        case 500:
            return Text.Banner.internalServerError
        case 503:
            return Text.Banner.serviceUnavailable
        default:
            return Text.Banner.unknownError
        }
    }
}

extension ApiError: Equatable {
    static func == (lhs: ApiError, rhs: ApiError) -> Bool {
        return lhs.description == rhs.description
    }
}
