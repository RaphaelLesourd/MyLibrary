//
//  QueryService.swift
//  MyLibrary
//
//  Created by Birkyboy on 20/12/2021.
//

class QueryService {
    /// Change the descending order when display by title or author.
    private func setDescendingOrder(for type: DocumentKey?) -> Bool {
        return type == .title || type == .author
    }
}
extension QueryService: QueryProtocol {
    /// Creates a new bookQuery to load data from the API
    /// - Parameters:
    ///  - Type: DocumentKey set by the selection in the options menu.
    /// - Returns: A new BookQuerry with new ordering key word.
    func updateQuery(from currentQuery: BookQuery?, with type: DocumentKey?) -> BookQuery {
        let descencing = setDescendingOrder(for: type)
        return BookQuery(listType: currentQuery?.listType,
                         orderedBy: type ?? .timestamp,
                         fieldValue: currentQuery?.fieldValue,
                         descending: !descencing)
    }
}
