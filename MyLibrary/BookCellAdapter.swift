//
//  BookCellAdapterProtocol.swift
//  MyLibrary
//
//  Created by Birkyboy on 26/12/2021.
//

protocol BookCellAdapter {
    func getBookData(for book: Item, completion: @escaping (BookCellData) -> Void)
}
