//
//  SearchBookService.swift
//  MyLibrary
//
//  Created by Birkyboy on 29/01/2022.
//

protocol SearchBookService {
    func getBooks(for query: String?, fromIndex: Int, completion: @escaping (Result<[ItemDTO], ApiError>) -> Void)
}
