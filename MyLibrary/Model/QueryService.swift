//
//  QueryService.swift
//  MyLibrary
//
//  Created by Birkyboy on 20/12/2021.
//

import Foundation

protocol QueryServiceProtocol {
    var currentQuery: BookQuery? { get set }
    func getQuery(with type: DocumentKey?) -> BookQuery
}

/// QueryService protocol concrete implementation
class QueryService {
    var currentQuery: BookQuery?
    
    /// Change the descending order when display by title or author.
    private func setDescendingOrder(for type: DocumentKey?) -> Bool {
        return type != .title || type != .author
    }
}

extension QueryService: QueryServiceProtocol {
    /// Creates a new bookQuery to load data from the API
    /// - Parameter Type: DocumentKey set by the selection in the options menu.
    /// - Returns: A new BookQuerry with new ordering key word.
    /// - Note: The field value remains an empty string. This field value is user to pass in a categoryID when displaying data by Categories.
    ///         due to the limitations of Firestore, filtering with more than one argmuent requires to create a custom index .
    ///         Those indecies are limited in numbers.
    func getQuery(with type: DocumentKey?) -> BookQuery {
        let descencing = setDescendingOrder(for: type)
        return BookQuery(listType: currentQuery?.listType,
                         orderedBy: type ?? .timestamp,
                         fieldValue: "",
                         descending: descencing)
    }
}
