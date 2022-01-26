//
//  QueryProtocol.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/12/2021.
//

protocol QueryProtocol {
    func updateQuery(from currentQuery: BookQuery?, with type: DocumentKey?) -> BookQuery
}
