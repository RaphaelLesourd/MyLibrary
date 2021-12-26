//
//  BookCardAdapter.swift
//  MyLibrary
//
//  Created by Birkyboy on 26/12/2021.
//

protocol BookCardAdapter {
    func getBookCardData(for book: Item, completion: @escaping(BookCardData) -> Void)
    func getBookCategories(for categoryIds: [String], bookOwnerID: String,completion: @escaping (String) -> Void)
}
