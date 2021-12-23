//
//  QueryProtocol.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/12/2021.
//

protocol QueryProtocol {
    var currentQuery: BookQuery? { get set }
    func getQuery(with type: DocumentKey?) -> BookQuery
}
